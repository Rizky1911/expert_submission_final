import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';


abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();

  @override
  List<Object> get props => [];
}

class MovieWatchlistStatus extends MovieWatchlistEvent {
  final int id;

  const MovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class MovieWatchlistAdd extends MovieWatchlistEvent {
  final MovieDetail movieDetail;

  const MovieWatchlistAdd(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieWatchlistRemove extends MovieWatchlistEvent {
  final MovieDetail movieDetail;

  const MovieWatchlistRemove(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieWatchlist extends MovieWatchlistEvent {
  @override
  List<Object> get props => [];
}
