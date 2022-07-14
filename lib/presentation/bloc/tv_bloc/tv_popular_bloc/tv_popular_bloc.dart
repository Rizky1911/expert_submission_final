import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular_bloc/tv_popular_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular_bloc/tv_popular_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTvs _popularTvs;

  TvPopularBloc(this._popularTvs) : super(TvPopularEmpty()) {
    on<TvPopular>((event, emit) async {

      emit(TvPopularLoading());
      final result = await _popularTvs.execute();

      result.fold(
            (failure) {
          emit(TvPopularError(failure.message));
        },
            (data) {
          emit(TvPopularHasData(data));
        },
      );
    });
  }
}