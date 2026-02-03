import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/auth/domain/repo/forgot_password_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'otp_state.dart';

@injectable
class OtpCubit extends Cubit<OtpState> {
  final ForgotPasswordRepo repo;
  OtpCubit(this.repo) : super(OtpState());

  void getOtp(String otp) {
    emit(state.copyWith(otp: otp, errorMessage: ''));
  }

  Future<void> verifyOtp(String email) async {
    if (state.otp.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter the OTP'));
      return;
    }
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final token = await repo.verifyOtp(state.otp, email);
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          token: token,
          errorMessage: '',
        ),
      );
    } catch (e) {
      String generalErrorMessage = '';

      //1. check if the error is the custom ApiException
      if (e is ApiException) {
        //if e.response contains raw parsed json from backed
        //Structure : {'error' : 'token expired'}

        if (e.response is Map<String, dynamic>) {
          final data = e.response as Map<String, dynamic>;

          //handle error field which is the only error in this otp expiration
          if (data.containsKey('error')) {
            generalErrorMessage = data['error'].toString();
          }
        } else {
          //unknonw errors
          generalErrorMessage = e.toString();
        }
      } else {
        generalErrorMessage = e.toString();
      }
      emit(
        state.copyWith(
          errorMessage: generalErrorMessage,
          status: ApiDataStatus.error,
          token: '',
        ),
      );
    }
  }
}
