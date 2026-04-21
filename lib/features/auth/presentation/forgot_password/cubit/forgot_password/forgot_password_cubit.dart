import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/auth/domain/repo/forgot_password_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepo repo;
  ForgotPasswordCubit(this.repo) : super(ForgotPasswordState());

  void getEmail(String email) {
    emit(
      state.copyWith(
        email: email,
        emailError: '',
        status: ApiDataStatus.initial,
      ),
    );
  }

  Future<void> submitEmail() async {
    if (state.email.isEmpty) {
      emit(state.copyWith(emailError: 'Please enter valid email'));
      return;
    }
    emit(state.copyWith(status: ApiDataStatus.loading));

    try {
      final successMessage = await repo.sendEmail(state.email);
      emit(
        state.copyWith(
          message: successMessage,
          status: ApiDataStatus.success,
          emailError: '', // clear old errors
        ),
      );
    } catch (e) {
      String specificEmailError = '';
      String generalErrorMessage = 'Something went wrong';

      //1. Check if the error is custom Api Exception
      if (e is ApiException) {
        //if e.response contains raw parsed json from backend
        //Structure: {'email': ['Error 1']} or  {'detail': "some error.."}

        if (e.response is Map<String, dynamic>) {
          final data = e.response as Map<String, dynamic>;

          //handle 'email' field error
          if (data.containsKey('email')) {
            final emailData = e.response['email'];
            //backend might response with STring or list
            if (emailData is List && emailData.isNotEmpty) {
              specificEmailError = emailData.first.toString();
            } else {
              specificEmailError = emailData.toString();
            }
          }

          //handle generic error like 'detail' or 'message'
          if (data.containsKey('message')) {
            generalErrorMessage = e.response['message'].toString();
          } else if (data.containsKey('details')) {
            generalErrorMessage = e.response['details'].toString();
          } else {
            //aba what if the response is just string and not map
            generalErrorMessage = e.errorMessage;
          }
        } else {
          //unknown  error(parsing, runtime etc)
          generalErrorMessage = e.toString();
        }
      } else {
        generalErrorMessage = e.toString();
      }
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          emailError: specificEmailError,
          message: generalErrorMessage,
          email: '',
        ),
      );
    }
  }
}
