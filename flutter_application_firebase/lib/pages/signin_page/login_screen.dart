import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/blocs/auth_bloc.dart';
import 'package:flutter_application_firebase/pages/bottom_navigation/navigation.dart';
import 'package:flutter_application_firebase/pages/signup_page/signup_screen.dart';

import '../../resources/loading_dialog.dart';
import '../../resources/msg_dialog.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool hidePassword = true;
  final _errorPassword = "Mật khẩu phải từ 6 kí tự trở lên";
  final _errorEmail = "Tài khoản không hợp lệ";
  bool _emailInvalid = false;
  bool _passwordInvalid = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        color: Colors.grey,
                        padding: const EdgeInsets.all(5),
                        child: const Image(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/motorbike.png"),
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Hello !!!",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Protect your vehicle",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Email",
                        errorText: _emailInvalid ? _errorEmail : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: hidePassword,
                      controller: _password,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        errorText: _passwordInvalid ? _errorPassword : null,
                        suffixIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Text(
                            hidePassword ? "SHOW" : "HIDE",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        alignment: Alignment.center,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _onSignInClicked,
                      child: const Text(
                        "SIGN IN",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "New User ? ",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up now",
                                style: TextStyle(color: Colors.blue, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Xử lý quên mật khẩu
                          },
                          child: const Text(
                            "Forgot your password ?",
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onSignInClicked() {
    String email = _email.text;
    String pass = _password.text;
    final AuthBloc authBloc = AuthBloc();
    LoadingDialog.showLoadingDialog(context, "Loading...");
    authBloc.signIn(email, pass, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BottomNavigationCustom()));
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Sign-In", msg);
    });
  }
}
