import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/presentation/auth/pages/signup.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_vectors.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppBar(
          title: SvgPicture.asset(
            AppVectors.logo,
            height: 40,
            width: 40,
          ),
        ),
        bottomNavigationBar: _signUpText(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textLogin(),
              const SizedBox(
                height: 50,
              ),
              _emailField(context),
              const SizedBox(
                height: 20,
              ),
              _passwordField(context),
              const SizedBox(
                height: 60,
              ),
              BasicAppButton(onPressed: () {}, title: 'Sign In')
            ],
          ),
        ));
  }

  Widget _textLogin() {
    return const Text(
      'Sign In',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Enter Email')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Password')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signUpText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Not A Member?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SignUpPage()));
              },
              child: const Text('Register Now'))
        ],
      ),
    );
  }
}
