// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../common/enums/enums.dart' as _i202;
import '../../features/auth/data/repo_impl.dart/forgot_password_repo_impl.dart'
    as _i234;
import '../../features/auth/domain/repo/forgot_password_repo.dart' as _i550;
import '../../features/auth/presentation/forgot_password/cubit/change_password/change_password_cubit.dart'
    as _i208;
import '../../features/auth/presentation/forgot_password/cubit/forgot_password/forgot_password_cubit.dart'
    as _i149;
import '../../features/auth/presentation/forgot_password/cubit/otp/otp_cubit.dart'
    as _i437;
import '../../features/auth/presentation/login/cubit/login_cubit.dart' as _i179;
import '../../features/auth/presentation/signup/cubit/sign_up_cubit.dart'
    as _i408;
import '../../features/courses/data/repo_impl/courses_repo_impl.dart' as _i801;
import '../../features/courses/domain/repo/courses_repo.dart' as _i652;
import '../../features/courses/presentation/bloc/banner/banner_bloc.dart'
    as _i427;
import '../../features/courses/presentation/bloc/courses/courses_bloc.dart'
    as _i518;
import '../../features/courses/presentation/bloc/enrolled_courses/enrolled_courses_bloc.dart'
    as _i878;
import '../../features/courses/presentation/bloc/review/review_bloc.dart'
    as _i710;
import '../../features/home/data/repos_impl/home_repo_impl.dart' as _i386;
import '../../features/home/domain/repos/home_repo.dart' as _i130;
import '../../features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart'
    as _i107;
import '../../features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart'
    as _i585;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/home/presentation/bloc/streams/streams_bloc.dart'
    as _i610;
import '../../features/home/presentation/bloc/videos/videos_bloc.dart' as _i373;
import '../../features/live_classes/data/repo_impl/live_classes_repo_impl.dart'
    as _i816;
import '../../features/live_classes/domain/repos/live_classes_repo.dart'
    as _i1021;
import '../../features/live_classes/presentation/bloc/live_classes_bloc.dart'
    as _i280;
import '../../features/payment/data/repo_impl.dart/payment_repo_impl.dart'
    as _i93;
import '../../features/payment/data/services/khalti_payment_service.dart'
    as _i912;
import '../../features/payment/data/services/khalti_service.dart' as _i123;
import '../../features/payment/domain/repo/payment_repo.dart' as _i50;
import '../../features/payment/presentation/bloc/payment_bloc.dart' as _i206;
import '../../features/profile/data/models/profile_model.dart' as _i36;
import '../../features/profile/data/repo_impl/profile_repository_impl.dart'
    as _i301;
import '../../features/profile/domain/repo/profile_repo.dart' as _i364;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/profile/presentation/cubit/profile_state.dart' as _i356;
import '../../features/search/data/repo_impl/search_repo_impl.dart' as _i790;
import '../../features/search/domain/repo/search_repo.dart' as _i1033;
import '../../features/search/presentation/bloc/search_bloc.dart' as _i552;
import '../../features/settings/bloc/reset_password_cubit/reset_password_cubit.dart'
    as _i584;
import '../../features/settings/data/repo_impl/reset_password_repo_impl.dart'
    as _i966;
import '../../features/settings/domain/rep/reset_password_repo.dart' as _i323;
import '../hive_services/services/hive_course_service.dart' as _i963;
import '../hive_services/services/hive_video_service.dart' as _i143;
import '../network/api_client.dart' as _i557;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i123.KhaltiService>(() => _i123.KhaltiService());
    gh.singleton<_i557.ApiClient>(() => registerModule.apiClient);
    gh.lazySingleton<_i963.HiveCourseService>(() => _i963.HiveCourseService());
    gh.lazySingleton<_i143.HiveVideoService>(() => _i143.HiveVideoService());
    gh.factory<_i1021.LiveClassesRepo>(
      () => _i816.LiveClassesRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i652.CoursesRepo>(
      () => _i801.CoursesRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i50.PaymentRepo>(
      () => _i93.PaymentRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i107.CourseBookmarkBloc>(
      () => _i107.CourseBookmarkBloc(gh<_i963.HiveCourseService>()),
    );
    gh.lazySingleton<_i585.VideosBookmarkBloc>(
      () => _i585.VideosBookmarkBloc(gh<_i143.HiveVideoService>()),
    );
    gh.factory<_i364.ProfileRepo>(
      () => _i301.ProfileRepositoryImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i323.ResetPasswordRepo>(
      () => _i966.ResetPasswordRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i130.HomeRepo>(() => _i386.HomeRepoImpl(gh<_i557.ApiClient>()));
    gh.factory<_i550.ForgotPasswordRepo>(
      () => _i234.ForgotPasswordRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i179.LoginCubit>(() => _i179.LoginCubit(gh<_i557.ApiClient>()));
    gh.factory<_i408.SignUpCubit>(
      () => _i408.SignUpCubit(gh<_i557.ApiClient>()),
    );
    gh.factory<_i1033.SearchRepo>(
      () => _i790.SearchRepoImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i208.ChangePasswordCubit>(
      () => _i208.ChangePasswordCubit(gh<_i550.ForgotPasswordRepo>()),
    );
    gh.factory<_i149.ForgotPasswordCubit>(
      () => _i149.ForgotPasswordCubit(gh<_i550.ForgotPasswordRepo>()),
    );
    gh.factory<_i437.OtpCubit>(
      () => _i437.OtpCubit(gh<_i550.ForgotPasswordRepo>()),
    );
    gh.factory<_i552.SearchBloc>(
      () => _i552.SearchBloc(gh<_i1033.SearchRepo>()),
    );
    gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc(gh<_i130.HomeRepo>()));
    gh.factory<_i427.BannerBloc>(
      () => _i427.BannerBloc(gh<_i652.CoursesRepo>()),
    );
    gh.factory<_i878.EnrolledCoursesBloc>(
      () => _i878.EnrolledCoursesBloc(gh<_i652.CoursesRepo>()),
    );
    gh.factory<_i710.ReviewBloc>(
      () => _i710.ReviewBloc(gh<_i652.CoursesRepo>()),
    );
    gh.factory<_i280.LiveClassesBloc>(
      () => _i280.LiveClassesBloc(gh<_i1021.LiveClassesRepo>()),
    );
    gh.factory<_i912.KhaltiPaymentService>(
      () => _i912.KhaltiPaymentService(gh<_i50.PaymentRepo>()),
    );
    gh.factory<_i206.PaymentBloc>(
      () => _i206.PaymentBloc(gh<_i50.PaymentRepo>()),
    );
    gh.factory<_i356.ProfileState>(
      () => _i356.ProfileState(
        status: gh<_i202.ApiDataStatus>(),
        profile: gh<_i36.ProfileModel>(),
        error: gh<String>(),
        pickedImage: gh<_i183.XFile>(),
        userNameError: gh<String>(),
        emailError: gh<String>(),
        phoneError: gh<String>(),
        bioError: gh<String>(),
        academicError: gh<String>(),
        justUpdated: gh<bool>(),
      ),
    );
    gh.factory<_i518.CoursesBloc>(
      () => _i518.CoursesBloc(gh<_i130.HomeRepo>()),
    );
    gh.factory<_i610.StreamsBloc>(
      () => _i610.StreamsBloc(gh<_i130.HomeRepo>()),
    );
    gh.factory<_i373.VideosBloc>(() => _i373.VideosBloc(gh<_i130.HomeRepo>()));
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(gh<_i364.ProfileRepo>()),
    );
    gh.factory<_i584.ResetPasswordCubit>(
      () => _i584.ResetPasswordCubit(gh<_i323.ResetPasswordRepo>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
