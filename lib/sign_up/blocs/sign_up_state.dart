import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:join_me/utilities/validators/form_inputs/form_inputs.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Name name;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props {
    return [
      name,
      email,
      password,
      confirmedPassword,
      status,
    ];
  }

  SignUpState copyWith({
    Name? name,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
