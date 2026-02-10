import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/primary_textfield.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Sign Up',
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
              'Full Name',
              style: TextStyles.mediumMedium,
            ),
            YMargin(10),
            PrimaryTextField(
              hint: "John Doe",
            ),
            YMargin(10),
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
                Checkbox(
                  value: _isChecked, 
                  activeColor: Palette.primary,
                  checkColor: Colors.white,
                  onChanged: (value) {
                    _toggleCheckbox(value);
                  }
                ),
                XMargin(10),
                Text(
                  "I agree to the T&C and Privacy Policy",
                  style: TextStyles.mediumSemiBold,
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
                  pop();
                },
                child: Text(
                  "Already have an account? Login",
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