import 'dart:io' show Platform;

import 'package:auth_app/modules/authentication/widgets/custom_button.dart';
import 'package:auth_app/modules/authentication/widgets/default_text_field.dart';
import 'package:auth_app/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router_name.dart';
import '../../../utils/injection_container.dart';
import '../../../utils/utils.dart';
import '../blocs/forgot_password/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgotPasswordBloc = sl.get<ForgotPasswordBloc>();
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailed) {
          Utils.errorSnackBar(context, state.errorMsg);
        } else if (state is ForgotPasswordLoaded) {
          Navigator.pushNamed(context, RouteNames.resetPasswordScreen);
          Utils.successSnackBar(
              context, "Verification Code sent to your email account!");
          // Utils.showSnackBar(context, state.);
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
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: forgotPasswordBloc.forgotFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'Forgot Your Password?',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 90),
                      DefaultTextField(
                        hintText: 'Enter Your Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                        builder: (context, state) {
                          print(state);
                          if (state is ForgotPasswordLoading) {
                            return const CircularProgressIndicator();
                          }
                          return CustomButton(
                              text: 'Forgot Password',
                              press: () {
                                forgotPasswordBloc.add(
                                  ForgotPasswordEventSubmit(
                                    email: emailController.text,
                                  ),
                                );
                              });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
