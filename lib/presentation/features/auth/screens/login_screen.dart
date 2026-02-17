import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/auth_provider.dart';
import 'package:earnwise_app/core/utils/input_validator.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/auth/screens/signup_screen.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isObscure = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authProvider = ref.watch(authNotifier);

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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: TextStyles.mediumMedium,
              ),
              YMargin(10),
              SearchTextField(
                controller: emailController,
                hint: "johndoe@gmail.com",
                validator: InputValidator.validateEmail,
              ),
              YMargin(10),
              Text(
                'Password',
                style: TextStyles.mediumMedium,
              ),
              YMargin(10),
              SearchTextField(
                controller: passwordController,
                hint: "********",
                validator: InputValidator.validatePassword,
                obscureText: _isObscure,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off, 
                    color: isDarkMode 
                      ? Palette.textGreyscale700Dark 
                      : Palette.textGreyscale700Light
                  ),
                ),
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
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YMargin(10),
            PrimaryButton(
              isLoading: authProvider.isLoading,
              text: "Continue", 
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  authProvider.login(
                    email: emailController.text, 
                    password: passwordController.text
                  );
                }
              }
            ),
            YMargin(20),
            InkWell(
              onTap: () {
                push(SignupScreen());
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyles.mediumSemiBold,
              ),
            ),
            YMargin(60)
          ],
        ),
      ),
    );
  }
}