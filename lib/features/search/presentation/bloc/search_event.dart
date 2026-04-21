// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetSearchedDataEvent extends SearchEvent {
  final String query;
  const GetSearchedDataEvent({required this.query});
}
