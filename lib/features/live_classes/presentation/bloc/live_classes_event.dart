part of 'live_classes_bloc.dart';

abstract class LiveClassesEvent extends Equatable {
  const LiveClassesEvent();

  @override
  List<Object> get props => [];
}

class GetLiveClassesEvent extends LiveClassesEvent {}

class GetDetailLiveClassEvent extends LiveClassesEvent {
  final int id;
  const GetDetailLiveClassEvent({required this.id});
}
