import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/data/repositories/user_repository.dart';
import 'package:join_me/sign_up/blocs/sign_up_state.dart';

import 'package:join_me/utilities/validators/form_inputs/form_inputs.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());
  final AuthenticationRepository _authenticationRepository;

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.name,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          password,
          state.name,
          state.email,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          confirmedPassword,
          state.name,
          state.email,
          state.password,
        ]),
      ),
    );
  }

  Future<void> signUpWithCredentials() async {
    if (state.status.isInvalid) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
