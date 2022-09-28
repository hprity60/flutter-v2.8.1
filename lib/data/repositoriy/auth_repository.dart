import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/pref.dart';
import '../../core/remote_urls.dart';
import '../model/verify_user.dart';

abstract class AuthRepository {
  Future<bool> register(String email, password, firstName, lastName);
  Future login(String username, password);
  Future<VerifyUserModel> verifyUser(
      String email, password, firstName, lastName);
  Future forgotPassword(String email);
  Future resetPassword(String code, email, password);
}

class AuthRepositoryIml extends AuthRepository {
  // register user
  @override
  Future<bool> register(String email, password, firstName, lastName) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(RemoteUrls.userRegister),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Email': email,
          'Password': password,
          'FirstName': firstName,
          'LastName': lastName,
        }),
      );
      print("Email: $email");
      print("Password: $password");
      print("FirstName: $firstName");
      print("LastName: $lastName");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.body.isNotEmpty) {
        var item = const JsonDecoder().convert(response.body);
        print("item $item");
        print("Message ${item['Message']}");
        throw '${item['Message']}';
      } else {
        return false;
      }
    } on TimeoutException {
      throw 'Timeout Error';
    } on SocketException {
      throw "No Internet Connection";
    } on Error {
      throw 'General Error';
    }
  }

  // login
  @override
  Future login(String username, password) async {
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request('POST', Uri.parse(RemoteUrls.userLogin));
      request.bodyFields = {
        'username': username,
        'password': password,
        'grant_type': 'password'
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var item1 =
            const JsonDecoder().convert(await response.stream.bytesToString());
        print("item $item1");
        print("access_token ${item1['access_token']}");
        Preference.clearAll();
        Preference.setTokenFlag("${item1['access_token']}");
        return item1;
      } else {
        throw "Your email or password incorrect.";
      }
    } on TimeoutException {
      throw 'Timeout Error';
    } on SocketException {
      throw "No Internet Connection";
    } on Error {
      throw 'General Error';
    }
  }

// verify user
  @override
  Future<VerifyUserModel> verifyUser(
      String email, password, firstName, lastName) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(RemoteUrls.verifyUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${Preference.getTokenFlag()}',
        },
        body: jsonEncode(<String, String>{
          'Email': email,
          'Password': password,
          'FirstName': firstName,
          'LastName': lastName,
        }),
      );
      print(response.statusCode);
      log(response.body);
      var item = const JsonDecoder().convert(response.body);
      log("item $item");
      log("Message ${item['Message']}");
      if (response.statusCode == 200) {
        final verifyResponse =
            VerifyUserModel.fromJson(json.decode(response.body));
        return verifyResponse;
      } else {
        throw 'Your email or password incorrect!';
      }
    } on TimeoutException {
      throw 'Timeout Error';
    } on SocketException {
      throw "No Internet Connection";
    } on Error {
      throw 'General Error';
    }
  }

  // forgot password
  @override
  Future forgotPassword(String email) async {
    try {
      var headersList = {
        'Accept': 'Accept: application/json',
        'Authorization': 'Bearer ${Preference.getTokenFlag()}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var url = Uri.parse(RemoteUrls.forgetPassword);

      var body = {'Email': email};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.bodyFields = body;

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        log(resBody);
      } else {
        throw 'Your email is incorrect!';
      }
    } on TimeoutException {
      throw 'Timeout Error';
    } on SocketException {
      throw "No Internet Connection";
    } on Error {
      throw 'General Error';
    }
  }

  // reset password
  @override
  Future resetPassword(String code, email, password) async {
    try {
      var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${Preference.getTokenFlag()}',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(RemoteUrls.resetPassworde);
      var body = {
        "Code": code,
        "Email": email,
        "Password": password,
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);
      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      if (res.statusCode == 200) {
        log(resBody);
      } else {
        throw 'Your Code is incorrect!';
      }
    } on TimeoutException {
      throw 'Timeout Error';
    } on SocketException {
      throw "No Internet Connection";
    } on Error {
      throw 'General Error';
    }
  }
}
