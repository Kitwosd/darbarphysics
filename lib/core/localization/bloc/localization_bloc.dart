import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationState(const Locale('en'))) {
    on<ChangeLocaleEvent>((event, emit) {
      emit(LocalizationState(event.locale));
    });
  }
}
