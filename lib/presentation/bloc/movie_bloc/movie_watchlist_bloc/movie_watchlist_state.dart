import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistEmpty extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistSuccessMessage extends MovieWatchlistState {
  final String message;

  MovieWatchlistSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final List<Movie> result;

  MovieWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MovieWatchlistHasStatus extends MovieWatchlistState {
  final bool status;

  MovieWatchlistHasStatus(this.status);

  @override
  List<Object> get props => [status];
}