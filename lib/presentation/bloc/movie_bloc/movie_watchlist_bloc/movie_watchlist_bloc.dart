import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist_bloc/movie_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist_bloc/movie_watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchlistMovies _getMovieWatchlist;

  MovieWatchlistBloc(this._getWatchListStatus, this._saveWatchlist,
      this._removeWatchlist, this._getMovieWatchlist)
      : super(MovieWatchlistEmpty()) {
    on<MovieWatchlistStatus>((event, emit) async {
      final id = event.id;

      emit(MovieWatchlistLoading());

      final result = await _getWatchListStatus.execute(id);

      emit(MovieWatchlistHasStatus(result));
    });

    on<MovieWatchlistAdd>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _saveWatchlist.execute(movie);

      result.fold((failure) {
        emit(MovieWatchlistError(failure.message));
      }, (message) {
        emit(MovieWatchlistSuccessMessage(message));
      });
    });

    on<MovieWatchlistRemove>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _removeWatchlist.execute(movie);

      result.fold((failure) {
        emit(MovieWatchlistError(failure.message));
      }, (message) {
        emit(MovieWatchlistSuccessMessage(message));
      });
    });

    on<MovieWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());

      final result = await _getMovieWatchlist.execute();

      result.fold((failure) {
        emit(MovieWatchlistError(failure.message));
      }, (data) {
        emit(MovieWatchlistHasData(data));
      });
    });
  }
}
