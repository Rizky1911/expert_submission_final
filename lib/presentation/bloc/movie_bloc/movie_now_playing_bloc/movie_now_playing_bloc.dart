import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_now_playing_bloc/movie_now_playing_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_now_playing_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies _nowPlayingMovies;

  MovieNowPlayingBloc(this._nowPlayingMovies) : super(MovieNowPlayingEmpty()) {
    on<MovieNowPlaying>((event, emit) async {

      emit(MovieNowPlayingLoading());
      final result = await _nowPlayingMovies.execute();

      result.fold(
            (failure) {
          emit(MovieNowPlayingError(failure.message));
        },
            (data) {
          emit(MovieNowPlayingHasData(data));
        },
      );
    });
  }
}