import 'package:auth_app/data/model/verify_user.dart';

import '../../../utils/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/verify/verify_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final verifyBloc = sl.get<VerifyBloc>();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<VerifyBloc, VerifyState>(
            builder: (context, state) {
              if (state is VerifyLoading) {
                return const CircularProgressIndicator();
              }
              if (state is VerifyFailed) {
                return Text(state.errorMsg);
              }
              if (state is VerifyLoaded) {
                return Center(child: _buildProfile(state.userModel));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildProfile(VerifyUserModel userModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 50),
      Image.network(userModel.profileUrl),
      const SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "User name: ${userModel.firstname}",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            " ${userModel.lastname}",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
      Text(
        "Email: ${userModel.email}",
        style: const TextStyle(fontSize: 20),
      ),
    ],
  );
}
