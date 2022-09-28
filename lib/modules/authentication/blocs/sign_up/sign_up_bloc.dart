import '../../../../utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/repositoriy/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository repository;
  final GlobalKey<FormState> signUpFormKey =
      GlobalKey<FormState>(debugLabel: 'signUpFormKey');
  SignUpBloc(this.repository) : super(SignUpInitial()) {
    on<SignUpEventSubmit>(_onRegister);
  }

  void _onRegister(SignUpEventSubmit event, Emitter<SignUpState> emit) async {
    if (!signUpFormKey.currentState!.validate()) return;

    if (event.firstName.isEmpty) {
      emit(const SignUpFailed(errorMsg: "First Name Required!"));
      return;
    }
    if (!Utils.isUsername(event.firstName)) {
      emit(const SignUpFailed(errorMsg: "Enter correct charecter!"));
      return;
    }
    if (event.lastName.isEmpty) {
      emit(const SignUpFailed(errorMsg: "Last Name Required!"));
      return;
    }
    if (!Utils.isUsername(event.lastName)) {
      emit(const SignUpFailed(errorMsg: "Enter correct charecter!"));
      return;
    }
    if (event.email.isEmpty) {
      emit(const SignUpFailed(errorMsg: "Email Required!"));
      return;
    }
    if (!Utils.isEmail(event.email)) {
      emit(const SignUpFailed(errorMsg: "Enter a valid Email Address!"));
      return;
    }
    if (event.password.isEmpty) {
      emit(const SignUpFailed(errorMsg: "Password Required!"));
      return;
    }
    if (event.password.length < 8) {
      emit(const SignUpFailed(errorMsg: "Password Atleast 8 character!"));
      return;
    }
    emit(SignUpLoading());
    try {
      await repository.register(
          event.email, event.password, event.firstName, event.lastName);
      emit(SignUpLoaded(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName));
    } catch (e) {
      emit(SignUpFailed(errorMsg: e.toString()));
    }
  }
}
