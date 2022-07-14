import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';


abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object> get props => [];
}

class TvWatchlistStatus extends TvWatchlistEvent {
  final int id;

  const TvWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class TvWatchlistAdd extends TvWatchlistEvent {
  final TvDetail movieDetail;

  const TvWatchlistAdd(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class TvWatchlistRemove extends TvWatchlistEvent {
  final TvDetail movieDetail;

  const TvWatchlistRemove(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class TvWatchlist extends TvWatchlistEvent {
  @override
  List<Object> get props => [];
}
