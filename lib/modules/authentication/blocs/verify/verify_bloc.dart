// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auth_app/data/model/verify_user.dart';
import 'package:auth_app/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/repositoriy/auth_repository.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final GlobalKey<FormState> verifyFormKey = GlobalKey<FormState>();

  final AuthRepository repository;
  VerifyBloc(
    this.repository,
  ) : super(VerifyInitial()) {
    on<VerifyEventSubmit>(_onVerify);
  }

  void _onVerify(VerifyEventSubmit event, Emitter<VerifyState> emit) async {
    if (!verifyFormKey.currentState!.validate()) return;
    if (event.firstName.isEmpty) {
      emit(const VerifyFailed(errorMsg: "First Name Required!"));
      return;
    }
    if (!Utils.isUsername(event.firstName.trim())) {
      emit(const VerifyFailed(errorMsg: "Enter correct charecter!"));
      return;
    }
    if (event.lastName.isEmpty) {
      emit(const VerifyFailed(errorMsg: "Last Name Required!"));
      return;
    }
    if (!Utils.isUsername(event.lastName)) {
      emit(const VerifyFailed(errorMsg: "Enter correct charecter!"));
      return;
    }
    if (event.email.isEmpty) {
      emit(const VerifyFailed(errorMsg: "Email Required!"));
      return;
    }
    if (!Utils.isEmail(event.email)) {
      emit(const VerifyFailed(errorMsg: "Enter a valid Email Address!"));
      return;
    }
    if (event.password.isEmpty) {
      emit(const VerifyFailed(errorMsg: "Password Required!"));
      return;
    }
    if (event.password.length < 8) {
      emit(const VerifyFailed(errorMsg: "Password Atleast 8 character!"));
      return;
    }
    emit(VerifyLoading());
    try {
    final userModel =  await repository.verifyUser(
          event.email, event.password, event.firstName, event.lastName);
      emit(VerifyLoaded(userModel: userModel));
    } catch (e) {
      emit(VerifyFailed(errorMsg: e.toString()));
    }
  }
}
