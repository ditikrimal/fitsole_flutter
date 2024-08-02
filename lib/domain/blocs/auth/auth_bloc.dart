import 'dart:async';
import 'package:fitsole_flutter/data/local_storage/secure_storage.dart';
import 'package:fitsole_flutter/domain/services/services.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<CheckLoginEvent>(_checkingLogin);
    on<LogOutEvent>(_logout);
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());

      final data = await authServices.login(
          email: event.email, password: event.password);

      await Future.delayed(Duration(milliseconds: 350));

      if (data.resp) {
        await secureStorage.deleteSecureStorage();

        await secureStorage.setAuthToken(data.token);

        emit(SuccessAuthState());
      } else {
        emit(FailureAuthState(
          error: data.message,
          errorStatus: data.messageStatus,
        ));
      }
    } catch (e) {
      emit(FailureAuthState(error: e.toString(), errorStatus: '500'));
    }
  }

  Future<void> _checkingLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());

      if (await secureStorage.readToken() != null) {
        final data = await authServices.renewToken();

        if (data.resp) {
          await secureStorage.setAuthToken(data.token);
          emit(SuccessAuthState());
        } else {
          await secureStorage.deleteSecureStorage();

          emit(LogOutState());
        }
      } else {
        await secureStorage.deleteSecureStorage();
        emit(LogOutState());
      }
    } catch (e) {
      await secureStorage.deleteSecureStorage();

      emit(LogOutState());
    }
  }

  Future<void> _logout(LogOutEvent event, Emitter<AuthState> emit) async {
    await secureStorage.deleteSecureStorage();
    emit(LogOutState());
  }
}
