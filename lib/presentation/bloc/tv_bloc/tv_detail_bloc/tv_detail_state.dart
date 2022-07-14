import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

//detail
abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail result;

  TvDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

// Recommendation
abstract class TvRecommendationsState extends Equatable {
  const TvRecommendationsState();

  @override
  List<Object> get props => [];
}

class TvRecommendationsEmpty extends TvRecommendationsState {}

class TvRecommendationsLoading extends TvRecommendationsState {}

class TvRecommendationsError extends TvRecommendationsState {
  final String message;

  TvRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class TvRecommendationsHasData extends TvRecommendationsState {
  final List<Tv> result;

  TvRecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}