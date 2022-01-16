import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tricycleapp/controller/authcontroller.dart';
import 'package:tricycleapp/widgets/sigupform_widget.dart';

enum pageState { signupState, otpState }

class SigupScreen extends StatelessWidget {
  static const screenName = '/signup';

  pageState currentPageState = pageState.signupState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: SigupformWidget()),
    );
  }
}
