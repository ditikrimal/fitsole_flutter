import 'package:fitsole_flutter/domain/blocs/blocs.dart';
import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:fitsole_flutter/presentation/helpers/helpers.dart';
import 'package:fitsole_flutter/presentation/helpers/validation_form.dart';
import 'package:fitsole_flutter/presentation/screen/home/home.dart';

import 'package:fitsole_flutter/presentation/screen/login/loading_page.dart';
import 'package:fitsole_flutter/presentation/screen/login/register_page.dart';
import 'package:fitsole_flutter/presentation/themes/colors_frave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passowrdController;
  final _keyForm = GlobalKey<FormState>();
  bool isChangeSuffixIcon = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passowrdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    _passowrdController.clear();
    _passowrdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          modalLoading(
            context,
          );
        } else if (state is FailureAuthState) {
          Navigator.pop(context);
          modalWarning(context, state.error, state.errorStatus);
          print('Error: ${state.error}');
          print('Error Status: ${state.errorStatus}');
        } else if (state is SuccessAuthState) {
          Navigator.pop(context);
          userBloc.add(OnGetUserEvent());
          Navigator.pushAndRemoveUntil(
              context, routeSlide(page: HomePage()), (_) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: SafeArea(
            child: Form(
              key: _keyForm,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image.asset(
                            'assets/fraved_logo.png',
                          ),
                        ),
                      ),
                      const TextFitsole(
                          text: 'Log In',
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: ColorsFrave.primaryColorFrave),
                      const SizedBox(height: 5),
                      const TextFitsole(
                        text: 'Welcome back',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      TextFormFrave(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: validatedEmail,
                        hintText: 'Enter your Email ID',
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                      ),
                      const SizedBox(height: 20),
                      TextFormFrave(
                        controller: _passowrdController,
                        isPassword: isChangeSuffixIcon,
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.password_rounded),
                        validator: passwordValidator.validators[0],
                      ),
                      const SizedBox(height: 20),
                      BtnFrave(
                        text: 'Log In',
                        width: size.width,
                        fontSize: 18,
                        isTitle: true,
                        fontWeight: FontWeight.w600,
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            authBloc.add(LoginEvent(
                                _emailController.text.trim(),
                                _passowrdController.text.trim()));
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChangeSuffixIcon,
                                onChanged: (value) {
                                  setState(() {
                                    isChangeSuffixIcon = value!;
                                  });
                                },
                                activeColor: ColorsFrave.primaryColorFrave,
                              ),
                              TextFitsole(
                                text: 'Remember me',
                                fontSize: 17,
                                color: Colors.black,
                                isTitle: true,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                                child: TextFitsole(
                                  text: 'Forgot password?',
                                  color: Colors.black,
                                  fontSize: 17,
                                  isTitle: true,
                                  fontWeight: FontWeight.w500,
                                ),
                                onPressed: () => Navigator.push(
                                    context, routeSlide(page: LoadingPage()))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'or continue with',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 232, 232, 232),
                        radius: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image.asset(
                            'assets/Google.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextFitsole(
                            text: 'Don\'t have an account?',
                            fontSize: 17,
                            color: Colors.black,
                            isTitle: true,
                            fontWeight: FontWeight.w400,
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                                context, routeFade(page: SignUpPage())),
                            child: TextFitsole(
                              text: 'Sign Up',
                              fontSize: 17,
                              color: ColorsFrave.primaryColorFrave,
                              isTitle: true,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
