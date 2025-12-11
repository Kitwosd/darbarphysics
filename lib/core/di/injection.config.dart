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

import '../../features/home/data/repos_impl/home_repo_impl.dart'
    as _i781;
import '../../features/home/domain/repos/home_repo.dart'
    as _i297;
import '../../features/home/presentation/bloc/home_bloc.dart'
    as _i940;
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
    gh.factory<_i297.HomeRepo>(() => _i781.HomeRepoImpl(gh<_i557.ApiClient>()));
    gh.factory<_i940.HomeBloc>(() => _i940.HomeBloc(gh<_i297.HomeRepo>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
