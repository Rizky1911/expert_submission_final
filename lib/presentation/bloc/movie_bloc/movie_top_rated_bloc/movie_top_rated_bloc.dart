import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_top_rated_event.dart';
import 'movie_top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _topRatedMovies;

  MovieTopRatedBloc(this._topRatedMovies) : super(MovieTopRatedEmpty()) {
    on<MovieTopRated>((event, emit) async {

      emit(MovieTopRatedLoading());
      final result = await _topRatedMovies.execute();

      result.fold(
            (failure) {
          emit(MovieTopRatedError(failure.message));
        },
            (data) {
          emit(MovieTopRatedHasData(data));
        },
      );
    });
  }
}