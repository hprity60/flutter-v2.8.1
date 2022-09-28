import 'dart:io' show Platform;

import 'package:auth_app/modules/authentication/widgets/custom_button.dart';
import 'package:auth_app/modules/authentication/widgets/default_text_field.dart';

import '../../../utils/consts.dart';

import '../../../utils/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/router_name.dart';
import '../../../utils/utils.dart';
import '../blocs/verify/verify_bloc.dart';

class VerifyScreen extends StatelessWidget {
  VerifyScreen({Key? key}) : super(key: key);

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final verifyBloc = sl.get<VerifyBloc>();
    return BlocListener<VerifyBloc, VerifyState>(
      listener: (context, state) {
        if (state is VerifyFailed) {
          Utils.errorSnackBar(context, state.errorMsg);
        } else if (state is VerifyLoaded) {
          Navigator.pushNamed(context, RouteNames.userProfileScreen);
          Utils.successSnackBar(context, "Your account verified successfully!");
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: verifyBloc.verifyFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Verify Your Account!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 90),
                  DefaultTextField(
                      controller: firstnameController,
                      hintText: 'Enter First Name'),
                  const SizedBox(height: 20),
                  DefaultTextField(
                      controller: lastnameController,
                      hintText: 'Enter Last Name'),
                  const SizedBox(height: 20),
                  DefaultTextField(
                      controller: emailController,
                      hintText: 'Enter Email Address'),
                  const SizedBox(height: 20),
                  DefaultTextField(
                      controller: passwordController,
                      hintText: 'Enter Password'),
                  const SizedBox(height: 50),
                  BlocBuilder<VerifyBloc, VerifyState>(
                    builder: (context, state) {
                      if (state is VerifyLoading) {
                        return const CircularProgressIndicator();
                      }
                      return CustomButton(
                        text: 'Verify',
                        press: () {
                          verifyBloc.add(
                            VerifyEventSubmit(
                              email: emailController.text,
                              password: passwordController.text,
                              firstName: firstnameController.text,
                              lastName: lastnameController.text,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
