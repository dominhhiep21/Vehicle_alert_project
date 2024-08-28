import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/pages/signin_page/login_screen.dart';

import '../../blocs/auth_bloc.dart';
import '../../resources/loading_dialog.dart';
import '../../resources/msg_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidePassword = true;
  AuthBloc authBloc = AuthBloc();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10,top: 80),
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
                    const SizedBox(height: 20,),
                    const Text("Hello !!!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Text("Register your account",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                   children: [
                    StreamBuilder(
                      stream: authBloc.nameStream,
                      builder: (context, snapshot) {
                        return TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name",
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 10,),  
                      StreamBuilder(
                        stream: authBloc.emailStream,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                          )
                          );
                        }
                      ),
                    const SizedBox(height: 20,),
                    StreamBuilder(
                      stream: authBloc.passStream,
                      builder: (context, snapshot) {
                        return TextField(
                          obscureText: hidePassword,
                          controller: _passController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Password",
                            suffixIcon: TextButton(
                              onPressed: (){
                                setState(() {
                                  if(hidePassword == true){
                                    hidePassword = false;
                                  }else{
                                    hidePassword = true;
                                  }
                                });
                              },
                              child: Text(hidePassword?"SHOW":"HIDE",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )
                            )
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 10,),
                    StreamBuilder(
                      stream: authBloc.phoneStream,
                      builder: (context, snapshot) {
                        return TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Phone Number",
                          )
                        );
                      }
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        alignment: Alignment.center,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      onPressed: (){
                        _onSignUpClicked();
                      }, 
                      child: const Text("SIGN IN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Have A Account ?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SigninScreen(),));
                              },
                              child: const Text(" Sign in now",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                              onTap: (){},
                              child: const Text("Forget your message ?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15
                                ),
                              ),
                            )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _onSignUpClicked() {
  var isValid = authBloc.isValid(
    _nameController.text,
    _emailController.text,
    _passController.text,
    _phoneController.text,
  );

  if (isValid) {
    // Hiển thị dialog đang tải
    LoadingDialog.showLoadingDialog(context, 'Loading...');

    // Tạo người dùng mới
    authBloc.signUp(
      _emailController.text,
      _passController.text,
      _nameController.text, // Đặt đúng thứ tự tham số name và phone
      _phoneController.text, // Đặt đúng thứ tự tham số name và phone
      () {
        // Ẩn dialog đang tải khi đăng ký thành công
        LoadingDialog.hideLoadingDialog(context);
        // Điều hướng đến trang HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      },
      (msg) {
        // Ẩn dialog đang tải khi có lỗi
        LoadingDialog.hideLoadingDialog(context);
        // Hiển thị hộp thoại thông báo lỗi
        MsgDialog.showMsgDialog(context, "Sign-Up", msg);
      },
    );
  }
}

}