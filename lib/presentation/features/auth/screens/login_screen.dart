import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/auth/screens/signup_screen.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/primary_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Login',
          style: TextStyles.largeBold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: TextStyles.mediumMedium,
            ),
            YMargin(10),
            PrimaryTextField(
              hint: "johndoe@gmail.com",
            ),
            YMargin(10),
            Text(
              'Password',
              style: TextStyles.mediumMedium,
            ),
            YMargin(10),
            PrimaryTextField(
              hint: "********",
              obscureText: true,
            ),  
            YMargin(10),
            Row(
              children: [
                Text(
                  "Forgot Your Password?",
                  style: TextStyles.mediumSemiBold,
                ),
                Spacer(),
                Text(
                  "Reset",
                  style: TextStyles.mediumSemiBold.copyWith(
                    color: Palette.primary
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(10)),
          child: Column(
            children: [
              YMargin(10),
              PrimaryButton(
                text: "Continue", 
                onPressed: () {
                  push(DashboardScreen());
                }
              ),
              YMargin(10),
              InkWell(
                onTap: () {
                  push(SignupScreen());
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyles.mediumSemiBold,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}