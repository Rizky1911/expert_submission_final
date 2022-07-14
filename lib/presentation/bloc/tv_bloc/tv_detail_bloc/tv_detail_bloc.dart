import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// detail
class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _movieDetail;

  TvDetailBloc(this._movieDetail) : super(TvDetailEmpty()) {
    on<TvId>((event, emit) async {
      final id = event.id;

      emit(TvDetailLoading());
      final result = await _movieDetail.execute(id);

      result.fold(
            (failure) {
          emit(TvDetailError(failure.message));
        },
            (data) {
          emit(TvDetailHasData(data));
        },
      );
    });
  }
}
// recommendation
class TvRecommendationsBloc extends Bloc<TvDetailEvent, TvRecommendationsState> {
  final GetTvRecommendations _movieRecommendations;

  TvRecommendationsBloc(this._movieRecommendations) : super(TvRecommendationsEmpty()) {
    on<TvId>((event, emit) async {
      final id = event.id;

      emit(TvRecommendationsLoading());
      final result = await _movieRecommendations.execute(id);

      result.fold(
            (failure) {
          emit(TvRecommendationsError(failure.message));
        },
            (data) {
          emit(TvRecommendationsHasData(data));
        },
      );
    });
  }
}