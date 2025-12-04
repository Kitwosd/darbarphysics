part of 'localization_bloc.dart';

sealed class LocalizationEvent {}

class ChangeLocaleEvent extends LocalizationEvent {
  final Locale locale;

  ChangeLocaleEvent(this.locale);
}
