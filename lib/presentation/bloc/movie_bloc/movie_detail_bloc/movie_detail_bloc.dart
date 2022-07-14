import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// detail
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _movieDetail;

  MovieDetailBloc(this._movieDetail) : super(MovieDetailEmpty()) {
    on<MovieId>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final result = await _movieDetail.execute(id);

      result.fold(
            (failure) {
          emit(MovieDetailError(failure.message));
        },
            (data) {
          emit(MovieDetailHasData(data));
        },
      );
    });
  }
}
// recommendation
class MovieRecommendationsBloc extends Bloc<MovieDetailEvent, MovieRecommendationsState> {
  final GetMovieRecommendations _movieRecommendations;

  MovieRecommendationsBloc(this._movieRecommendations) : super(MovieRecommendationsEmpty()) {
    on<MovieId>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationsLoading());
      final result = await _movieRecommendations.execute(id);

      result.fold(
            (failure) {
          emit(MovieRecommendationsError(failure.message));
        },
            (data) {
          emit(MovieRecommendationsHasData(data));
        },
      );
    });
  }
}