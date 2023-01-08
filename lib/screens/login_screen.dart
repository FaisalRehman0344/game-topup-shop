import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/components/custom_field.dart';
import 'package:topup_shop/models/login_state.dart';
import 'package:topup_shop/routes/my_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  String? username, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/main.png", width: 120),
                  const SizedBox(height: 25),
                  customField("Username", (val) {
                    username = val;
                  }),
                  const SizedBox(height: 20),
                  customField("Password", (val) {
                    password = val;
                  }),
                  const SizedBox(height: 40),
                  MaterialButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        if (username == password && password == "03441140754") {
                          await LoginState.login;
                          context.go(Routes.adming);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid Credentials")));
                        }
                      }
                    },
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 60),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
