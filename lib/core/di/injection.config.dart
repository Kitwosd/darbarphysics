// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/data/repos/mock_home_repo.dart' as _i403;
import '../../features/home/domain/repos/home_repo.dart' as _i130;
import '../../features/courses/presentation/courses/courses_bloc.dart' as _i786;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/home/presentation/bloc/live_classes/live_classes_bloc.dart'
    as _i332;
import '../../features/home/presentation/bloc/streams/streams_bloc.dart'
    as _i610;
import '../../features/home/presentation/bloc/videos/videos_bloc.dart' as _i373;
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
    gh.singleton<_i557.ApiClient>(() => registerModule.apiClient);
    gh.factory<_i130.HomeRepo>(() => _i403.MockHomeRepo());
    gh.factory<_i786.CoursesBloc>(
      () => _i786.CoursesBloc(gh<_i130.HomeRepo>()),
    );
    gh.factory<_i332.LiveClassesBloc>(
      () => _i332.LiveClassesBloc(gh<_i130.HomeRepo>()),
    );
    gh.factory<_i610.StreamsBloc>(
      () => _i610.StreamsBloc(gh<_i130.HomeRepo>()),
    );
    gh.factory<_i373.VideosBloc>(() => _i373.VideosBloc(gh<_i130.HomeRepo>()));
    gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc(gh<_i130.HomeRepo>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
