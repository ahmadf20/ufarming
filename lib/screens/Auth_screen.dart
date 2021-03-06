import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ufarming/screens/main_screen.dart';
import 'package:ufarming/services/auth_service.dart';
import 'package:ufarming/utils/custom_bot_toast.dart';
import 'package:ufarming/utils/my_colors.dart';
import 'package:ufarming/utils/my_text_field.dart';
import 'package:ufarming/widgets/my_flat_button.dart';

enum AuthState { login, register }

class AuthScreen extends StatefulWidget {
  final AuthState authState;

  AuthScreen({Key key, this.authState}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthState state;

  TextEditingController emailTC = TextEditingController();
  TextEditingController nameTC = TextEditingController();
  TextEditingController usernameTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();

  Future loginHandler() async {
    if (usernameTC.text.isEmpty || passwordTC.text.isEmpty) return;

    BotToast.showLoading();
    login(usernameTC.text, passwordTC.text).then((res) {
      if (res == true)
        Get.offAll(MainScreen());
      else
        customBotToastText(res);
    }).whenComplete(() {
      BotToast.closeAllLoading();
    });
  }

  Future registerHandler() async {
    if (usernameTC.text.isEmpty ||
        passwordTC.text.isEmpty ||
        nameTC.text.isEmpty ||
        emailTC.text.isEmpty) return;

    BotToast.showLoading();
    Map data = {
      'username': usernameTC.text,
      'email': emailTC.text,
      'password': passwordTC.text,
      'name': nameTC.text,
    };
    register(data).then((res) {
      if (res == true)
        Get.offAll(MainScreen());
      else
        customBotToastText(res);
    }).whenComplete(() {
      BotToast.closeAllLoading();
    });
  }

  @override
  void initState() {
    super.initState();
    state = widget.authState ?? AuthState.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/leaves2.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state == AuthState.login ? 'SIGN IN' : 'REGISTER',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: MyColors.darkGrey,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    state == AuthState.login
                        ? 'Sign to continue learning without any limitation right on your hand'
                        : 'Create your account to start your journey with us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 14,
                      color: MyColors.grey,
                    ),
                  ),
                  SizedBox(height: 40),
                  if (state == AuthState.register)
                    Column(
                      children: [
                        MyTextField(
                          label: 'Email Address',
                          controller: emailTC,
                          validator: (val) {
                            if (!val.isEmail)
                              return 'Enter a valid email adress';
                          },
                        ),
                        SizedBox(height: 15),
                        MyTextField(
                          label: 'Full Name',
                          controller: nameTC,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  MyTextField(
                    label: 'Username',
                    controller: usernameTC,
                  ),
                  SizedBox(height: 15),
                  MyTextField(
                    label: 'Password',
                    controller: passwordTC,
                    obscureText: true,
                  ),
                  SizedBox(height: 45),
                  MyFlatButton(
                    text:
                        state == AuthState.login ? 'Sign In' : 'Create Account',
                    onPressed: () {
                      if (state == AuthState.login)
                        loginHandler();
                      else
                        registerHandler();
                    },
                  ),
                  SizedBox(height: 35),
                  GestureDetector(
                    onTap: () {
                      state = state == AuthState.login
                          ? AuthState.register
                          : AuthState.login;
                      if (mounted) setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state == AuthState.login
                              ? 'Don\'t have an account?'
                              : 'Already have an account?',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 15,
                            color: MyColors.darkGrey,
                          ),
                        ),
                        Text(
                          state == AuthState.login ? ' Register' : ' Sign In',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 15,
                            color: MyColors.darkGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
