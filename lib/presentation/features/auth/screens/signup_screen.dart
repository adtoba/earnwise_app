import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/auth_provider.dart';
import 'package:earnwise_app/core/utils/input_validator.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {

  bool _isChecked = false;
  bool _isObscure = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  
  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First Name',
                  style: TextStyles.mediumMedium,
                ),
                YMargin(10),
                SearchTextField(
                  controller: firstNameController,
                  hint: "John",
                  validator: InputValidator.validateField,
                ),
                YMargin(10),
                Text(
                  'Last Name',
                  style: TextStyles.mediumMedium,
                ),
                YMargin(10),
                SearchTextField(
                  controller: lastNameController,
                  hint: "Doe",
                  validator: InputValidator.validateField,
                ),
                YMargin(10),
                Text(
                  'Email Address',
                  style: TextStyles.mediumMedium,
                ),
                YMargin(10),
                SearchTextField(
                  hint: "johndoe@gmail.com",
                  controller: emailController,
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
                  obscureText: _isObscure,
                  validator: InputValidator.validatePassword,
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.sw(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YMargin(10),
            PrimaryButton(
              text: "Continue", 
              isLoading: ref.watch(authNotifier).isLoading,
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  if(_isChecked) {
                    ref.read(authNotifier).register(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } else {
                    showErrorToast("Please agree to the T&C and Privacy Policy");
                  }
                  
                }
              }
            ),
            YMargin(20),
            InkWell(
              onTap: () {
                pop();
              },
              child: Text(
                "Already have an account? Login",
                style: TextStyles.mediumSemiBold,
              ),
            ),
            YMargin(60)
          ],
        ),
      )
    );
  }
}