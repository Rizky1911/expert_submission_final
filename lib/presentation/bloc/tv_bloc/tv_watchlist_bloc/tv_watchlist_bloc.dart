import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchListStatusTv _getWatchListStatus;
  final SaveWatchlistTv _saveWatchlist;
  final RemoveWatchlistTv _removeWatchlist;
  final GetWatchlistTvs _getTvWatchlist;

  TvWatchlistBloc(this._getWatchListStatus, this._saveWatchlist,
      this._removeWatchlist, this._getTvWatchlist)
      : super(TvWatchlistEmpty()) {
    on<TvWatchlistStatus>((event, emit) async {
      final id = event.id;

      emit(TvWatchlistLoading());

      final result = await _getWatchListStatus.execute(id);

      emit(TvWatchlistHasStatus(result));
    });

    on<TvWatchlistAdd>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _saveWatchlist.execute(movie);

      result.fold((failure) {
        emit(TvWatchlistError(failure.message));
      }, (message) {
        emit(TvWatchlistSuccessMessage(message));
      });
    });

    on<TvWatchlistRemove>((event, emit) async {
      final movie = event.movieDetail;

      final result = await _removeWatchlist.execute(movie);

      result.fold((failure) {
        emit(TvWatchlistError(failure.message));
      }, (message) {
        emit(TvWatchlistSuccessMessage(message));
      });
    });

    on<TvWatchlist>((event, emit) async {
      emit(TvWatchlistLoading());

      final result = await _getTvWatchlist.execute();

      result.fold((failure) {
        emit(TvWatchlistError(failure.message));
      }, (data) {
        emit(TvWatchlistHasData(data));
      });
    });
  }
}
