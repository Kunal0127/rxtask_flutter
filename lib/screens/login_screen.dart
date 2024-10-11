import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxtask/utils/app_prefs.dart';
import 'package:rxtask/utils/app_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  } else if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Mobile number must contain only digits';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                maxLength: 10,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                obscureText: obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                    return 'Password must contain at least one uppercase letter';
                  } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
                    return 'Password must contain at least one lowercase letter';
                  } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                    return 'Password must contain at least one number';
                  } else if (!RegExp(r'^(?=.*[@$!%*?&])').hasMatch(value)) {
                    return 'Password must contain at least one special character (@\$!%*?&)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?")),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (_mobileController.text == '9033006262' &&
                        _passwordController.text == 'eVital@12') {
                      Get.showSnackbar(
                        GetSnackBar(
                          // title: "login success",
                          message: "login success",
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      AppPrefs.setValue(key: "isLogin", value: true);
                      Get.offNamed(AppRoutes.home);
                    }
                  } else {
                    Get.showSnackbar(
                      GetSnackBar(
                        // title: "login failed",
                        message: "login failed",
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              TextButton(onPressed: () {}, child: Text("Create new account")),
            ],
          ),
        ),
      ),
    );
  }
}
  