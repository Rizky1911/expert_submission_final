import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_bloc/debounce.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_tv_bloc/search_tv_event.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_tv_bloc/search_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTvs _searchTvs;

  SearchTvBloc(this._searchTvs) : super(SearchTvEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTvLoading());
      final result = await _searchTvs.execute(query);

      result.fold(
            (failure) {
          emit(SearchTvError(failure.message));
        },
            (data) {
          emit(SearchTvHasData(data));
        },
      );
    }
    , transformer: debounce(const Duration(milliseconds: 500)));
  }

}