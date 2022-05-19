import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:join_me/utilities/validators/form_inputs/form_inputs.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    bool? isShowPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
