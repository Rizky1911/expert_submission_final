import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rated_bloc/tv_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rated_bloc/tv_top_rated_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTvs _topRatedTvs;

  TvTopRatedBloc(this._topRatedTvs) : super(TvTopRatedEmpty()) {
    on<TvTopRated>((event, emit) async {

      emit(TvTopRatedLoading());
      final result = await _topRatedTvs.execute();

      result.fold(
            (failure) {
          emit(TvTopRatedError(failure.message));
        },
            (data) {
          emit(TvTopRatedHasData(data));
        },
      );
    });
  }
}