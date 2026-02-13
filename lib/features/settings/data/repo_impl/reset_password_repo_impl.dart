import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/settings/data/models/reset_password_model.dart';
import 'package:durbar_physics/features/settings/domain/rep/reset_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ResetPasswordRepo)
class ResetPasswordRepoImpl implements ResetPasswordRepo {
  final ApiClient apiClient;
  ResetPasswordRepoImpl(this.apiClient);
  @override
  Future<String> resetPassword(ResetPasswordModel passwords) async {
    final response = await apiClient.request(
      path: 'password-change/',
      method: ApiMethod.post,
      data: passwords.toJson(),
    );
    return response['message']?.toString() ?? 'Password Changed Successfully';
  }
}
