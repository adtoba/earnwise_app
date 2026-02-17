var regex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
class InputValidator {

  static String? validateFullName(String? value) {
    if(value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      return null;
    }
  }

  static String? validateField(String? value) {
    if(value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      return null;
    }
  }

  static String? validateEmail(String? email) {
    if(email!.isEmpty) {
      return "Enter your email address";
    } else if (!regex.hasMatch(email)) {
      return 'invalid email address';
    } else {
      return null;
    }
  } 

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Field cannot be empty";
    } else if(password.length < 6) {
      return 'Password should not be less than 6';
    } else {
      return null;
    }
  }
}