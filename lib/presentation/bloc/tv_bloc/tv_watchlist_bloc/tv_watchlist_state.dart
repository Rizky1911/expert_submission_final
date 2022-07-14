import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistSuccessMessage extends TvWatchlistState {
  final String message;

  TvWatchlistSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistHasData extends TvWatchlistState {
  final List<Tv> result;

  TvWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvWatchlistHasStatus extends TvWatchlistState {
  final bool status;

  TvWatchlistHasStatus(this.status);

  @override
  List<Object> get props => [status];
}