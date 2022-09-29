// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyUserModel {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String profileUrl;
  VerifyUserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.profileUrl,
  });

factory VerifyUserModel.fromJson(Map<String, dynamic> json) {
    return VerifyUserModel(
      firstname: json['FirstName'],
      lastname: json['LastName'],
      email: json['Email'],
      password: json['Password']??'',
      profileUrl: json['ProfileImageUrl'],
    );
  }

}
