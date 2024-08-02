import 'package:fitsole_flutter/domain/blocs/user/user_bloc.dart';
import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:fitsole_flutter/presentation/helpers/helpers.dart';
import 'package:fitsole_flutter/presentation/themes/colors_frave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class VerifyOTPPage extends StatefulWidget {
  final String email;
  const VerifyOTPPage({super.key, required this.email});

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  late final TextEditingController _otpController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clear();
    _otpController.dispose();
    super.dispose();
  }

  void clear() {
    _otpController.clear();
  }

  final defaultPinTheme = PinTheme(
    decoration: BoxDecoration(
      color: Color.fromARGB(200, 208, 208, 208),
      borderRadius: BorderRadius.circular(10),
    ),
    width: 60,
    height: 60,
    textStyle: TextStyle(fontSize: 24, color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print(state);

        if (state is LoadingUserState) {
          modalLoading(context);
        }
        if (state is SuccessUserState) {
          Navigator.of(context).pop();
          modalSuccess(context, "Your email has been verified.", onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('signInPage');
          });
        }
        if (state is FailureUserState) {
          Navigator.of(context).pop(); // Close the loading dialog
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0x69F4F4F4),
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon:
                const Icon(Icons.close_rounded, size: 25, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: Color(0x69F4F4F4),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFitsole(
                  text: 'OTP Verification',
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 10),
                TextFitsole(
                  text: 'An OTP has been sent to your email address',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                SizedBox(height: 30),
                TextFitsole(
                  text: widget.email,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Pinput(
                    enableSuggestions: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    defaultPinTheme: defaultPinTheme,
                    controller: _otpController,
                    length: 6, // Adjusted length to 6
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30),
                BtnFrave(
                  text: 'Verify',
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    userBloc.add(
                        OnVerifyOTPEvent(_otpController.text, widget.email));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
