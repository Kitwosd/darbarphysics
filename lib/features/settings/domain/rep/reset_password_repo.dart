import 'package:durbar_physics/features/settings/data/models/reset_password_model.dart';

abstract class ResetPasswordRepo {
  Future<String> resetPassword(ResetPasswordModel passwords );
}
