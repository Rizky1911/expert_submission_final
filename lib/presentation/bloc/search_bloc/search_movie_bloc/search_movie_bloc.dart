import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/search_bloc/debounce.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_movie_bloc/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/search_bloc/search_movie_bloc/search_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;

  SearchMovieBloc(this._searchMovies) : super(SearchMovieEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchMovieLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
            (failure) {
          emit(SearchMovieError(failure.message));
        },
            (data) {
          emit(SearchMovieHasData(data));
        },
      );
    }
    , transformer: debounce(const Duration(milliseconds: 500)));
  }

}