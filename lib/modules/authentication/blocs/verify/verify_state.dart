// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object> get props => [];
}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class VerifyLoaded extends VerifyState {
 final VerifyUserModel userModel;
 const VerifyLoaded({
    required this.userModel,
  });
 
  @override
  List<Object> get props => [userModel];
}

class VerifyFailed extends VerifyState {
  final String errorMsg;
  const VerifyFailed({
    required this.errorMsg,
  });
  @override
  List<Object> get props => [errorMsg];
}
