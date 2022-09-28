import 'dart:io' show Platform;

import 'package:auth_app/modules/authentication/widgets/custom_button.dart';
import 'package:auth_app/modules/authentication/widgets/default_text_field.dart';
import 'package:auth_app/utils/consts.dart';

import '../../../utils/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router_name.dart';
import '../../../utils/utils.dart';
import '../blocs/sign_up/sign_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signUpBloc = sl.get<SignUpBloc>();

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailed) {
          Utils.errorSnackBar(context, state.errorMsg);
        } else if (state is SignUpLoaded) {
          Navigator.pushNamed(context, RouteNames.loginScreen);
          Utils.successSnackBar(
              context, "You're account successfully created.");
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
            key: signUpBloc.signUpFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Create Your Account!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 90),
                  DefaultTextField(
                    hintText: 'Enter First Name',
                    controller: firstnameController,
                  ),
                  const SizedBox(height: 20),
                   DefaultTextField(
                    hintText: 'Enter Last Name',
                    controller: lastnameController,
                  ),
                  const SizedBox(height: 20),
                   DefaultTextField(
                    hintText: 'Enter Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                   DefaultTextField(
                    hintText: 'Enter Password',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      print(state);
                      if (state is SignUpLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return CustomButton(
                            text:  'Sign Up',
                            press: () {
                              signUpBloc.add(
                                SignUpEventSubmit(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  firstName: firstnameController.text,
                                  lastName: lastnameController.text,
                                ),
                              );
                            });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Have an account?  '),
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(
                              context, RouteNames.loginScreen);
                        },
                        child: const Text(
                          'SignIn Now',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
