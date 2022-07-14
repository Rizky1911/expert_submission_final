import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_airing_today_bloc/tv_airing_today_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_airing_today_bloc/tv_airing_today_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvAiringTodayBloc extends Bloc<TvAiringTodayEvent, TvAiringTodayState> {
  final GetAiringTodayTvs _airingTodayTvs;

  TvAiringTodayBloc(this._airingTodayTvs) : super(TvAiringTodayEmpty()) {
    on<TvAiringToday>((event, emit) async {

      emit(TvAiringTodayLoading());
      final result = await _airingTodayTvs.execute();

      result.fold(
            (failure) {
          emit(TvAiringTodayError(failure.message));
        },
            (data) {
          emit(TvAiringTodayHasData(data));
        },
      );
    });
  }
}