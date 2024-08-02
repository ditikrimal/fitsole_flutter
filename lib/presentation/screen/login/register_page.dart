import 'package:fitsole_flutter/domain/blocs/blocs.dart';
import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:fitsole_flutter/presentation/helpers/helpers.dart';
import 'package:fitsole_flutter/presentation/helpers/validation_form.dart';
import 'package:fitsole_flutter/presentation/screen/login/login_page.dart';
import 'package:fitsole_flutter/presentation/screen/login/otp_page.dart';
import 'package:fitsole_flutter/presentation/themes/colors_frave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController passowrdController;
  late final TextEditingController passController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passowrdController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clear();
    fullNameController.dispose();
    emailController.dispose();
    passowrdController.dispose();
    passController.dispose();
    super.dispose();
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    passowrdController.clear();
    passController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(
            context,
          );
        }
        if (state is SuccessUserState) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VerifyOTPPage(
                    email: emailController.text,
                  )));
        }
        if (state is FailureUserState) {
          print(state.error);
          Navigator.of(context).pop();
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              child: const TextFitsole(
                text: 'Log In',
                fontSize: 17,
                color: ColorsFrave.primaryColorFrave,
                fontWeight: FontWeight.w500,
              ),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, routeFade(page: SignInPage()), (_) => false),
            ),
            const SizedBox(width: 5)
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            children: [
              const TextFitsole(
                text: 'Welcome to Fitsole',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                isTitle: true,
              ),
              const SizedBox(height: 5.0),
              TextFitsole(
                text: 'Create Account',
                fontSize: 17,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              const SizedBox(height: 20.0),
              TextFormFrave(
                hintText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                controller: fullNameController,
                validator:
                    RequiredValidator(errorText: 'Full Name is required'),
              ),
              const SizedBox(height: 15.0),
              TextFormFrave(
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  controller: emailController,
                  validator: validatedEmail),
              const SizedBox(height: 15.0),
              TextFormFrave(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.vpn_key_rounded),
                isPassword: true,
                controller: passowrdController,
                validator: passwordValidator,
              ),
              const SizedBox(height: 15.0),
              TextFormFrave(
                  hintText: 'Repeat Password',
                  controller: passController,
                  prefixIcon: const Icon(Icons.vpn_key_rounded),
                  isPassword: true,
                  validator: (val) =>
                      MatchValidator(errorText: 'Password do not macth ')
                          .validateMatch(val!, passowrdController.text)),
              const SizedBox(height: 25.0),
              Row(
                children: const [
                  Icon(Icons.check_circle_rounded,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  TextFitsole(
                    text: ' By Signing up, I agree to the',
                    fontSize: 15,
                  ),
                  TextFitsole(
                      text: ' Terms of Use',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 130, 130, 130)),
                ],
              ),
              const SizedBox(height: 15.0),
              BtnFrave(
                text: 'Sign up',
                width: size.width,
                fontSize: 18,
                isTitle: true,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    userBloc.add(OnAddNewUser(
                        fullNameController.text.trim(),
                        emailController.text.trim(),
                        passowrdController.text.trim()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
