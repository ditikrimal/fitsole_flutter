import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image.asset(
                            'assets/fraved_logo.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    BtnFrave(
                        text: 'Sign in with email',
                        isTitle: true,
                        height: 55,
                        fontSize: 18,
                        border: 60,
                        fontWeight: FontWeight.w600,
                        colorText: Colors.white,
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('signInPage'),
                        width: size.width),
                    const SizedBox(height: 20.0),
                    BtnFrave(
                        text: 'Sign in with Google Account',
                        colorText: Colors.black87,
                        fontSize: 18,
                        border: 60,
                        isTitle: true,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Color.fromARGB(255, 206, 206, 206),
                        width: size.width),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFitsole(
                          text: 'Don\'t have an account?',
                          fontSize: 17,
                          color: Colors.black45,
                        ),
                        TextButton(
                          child: TextFitsole(
                              text: 'Sign up',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('signUpPage'),
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
}
