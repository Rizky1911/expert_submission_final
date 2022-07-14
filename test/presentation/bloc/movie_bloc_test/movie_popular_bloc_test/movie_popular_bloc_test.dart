import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetMoviePopular;
  late MoviePopularBloc moviePopularBloc;

  setUp(() {
    mockGetMoviePopular = MockGetPopularMovies();
    moviePopularBloc = MoviePopularBloc(mockGetMoviePopular);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(moviePopularBloc.state, MoviePopularEmpty());
  });

  blocTest<MoviePopularBloc, MoviePopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMoviePopular.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return moviePopularBloc;
    },
    act: (bloc) => bloc.add(MoviePopular()),
    expect: () => [
      MoviePopularLoading(),
      MoviePopularHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMoviePopular.execute());
    },
  );

  blocTest<MoviePopularBloc, MoviePopularState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMoviePopular.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviePopularBloc;
    },
    act: (bloc) => bloc.add(MoviePopular()),
    expect: () => [
      MoviePopularLoading(),
      MoviePopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMoviePopular.execute());
    },
  );
}
