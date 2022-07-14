import 'package:equatable/equatable.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTvEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}