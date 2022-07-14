import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_popular_event.dart';
import 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies _popularMovies;

  MoviePopularBloc(this._popularMovies) : super(MoviePopularEmpty()) {
    on<MoviePopular>((event, emit) async {

      emit(MoviePopularLoading());
      final result = await _popularMovies.execute();

      result.fold(
            (failure) {
          emit(MoviePopularError(failure.message));
        },
            (data) {
          emit(MoviePopularHasData(data));
        },
      );
    });
  }
}