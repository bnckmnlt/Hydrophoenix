import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/auth/presentation/widgets/auth_field.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SignupPage());

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Hello World"),
                  Text("Hello World"),
                ],
              ),
              AuthField(
                  labelText: "Email address", controller: _emailController)
            ],
          ),
        ),
      )),
    );
  }
}
