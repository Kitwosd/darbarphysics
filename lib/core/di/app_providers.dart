import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/localization/bloc/localization_bloc.dart';
import 'package:durbar_physics/core/theme/theme_cubit.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/enrolled_courses/enrolled_courses_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> get providers => [
  // Core Providers
  BlocProvider<LocalizationBloc>(create: (_) => LocalizationBloc()),
  BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),

  // Feature Providers (Global)
  BlocProvider<CoursesBloc>(
    create: (_) => getIt<CoursesBloc>()..add(GetCoursesEvent()),
  ),

  // For the bookmark to save the state of the bookmarks
  BlocProvider<CourseBookmarkBloc>(
    create: (_) => getIt<CourseBookmarkBloc>()..add(LoadBookmarkCoursesEvent()),
  ),
  BlocProvider<VideosBookmarkBloc>(
    create: (_) => getIt<VideosBookmarkBloc>()..add(LoadVideosEvent()),
  ),
  BlocProvider<EnrolledCoursesBloc>(
    create: (_) => getIt<EnrolledCoursesBloc>()..add(GetEnrolledCoursesEvent()),
  ),
  BlocProvider<ProfileCubit>(
    create: (_) => getIt<ProfileCubit>()..getProfile(),
  ),
];
