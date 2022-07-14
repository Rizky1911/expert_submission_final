import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

//detail
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail result;

  MovieDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

// Recommendation
abstract class MovieRecommendationsState extends Equatable {
  const MovieRecommendationsState();

  @override
  List<Object> get props => [];
}

class MovieRecommendationsEmpty extends MovieRecommendationsState {}

class MovieRecommendationsLoading extends MovieRecommendationsState {}

class MovieRecommendationsError extends MovieRecommendationsState {
  final String message;

  MovieRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieRecommendationsHasData extends MovieRecommendationsState {
  final List<Movie> result;

  MovieRecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}