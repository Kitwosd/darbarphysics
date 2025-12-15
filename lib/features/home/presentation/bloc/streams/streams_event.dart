part of 'streams_bloc.dart';

sealed class StreamsEvent extends Equatable {
  const StreamsEvent();

  @override
  List<Object> get props => [];
}

class GetStreamsEvent extends StreamsEvent {}
