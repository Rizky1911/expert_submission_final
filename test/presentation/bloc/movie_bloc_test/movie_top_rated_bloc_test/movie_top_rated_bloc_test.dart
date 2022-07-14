import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_top_rated_bloc/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_top_rated_bloc/movie_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_top_rated_bloc/movie_top_rated_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_top_rated_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetMovieTopRated;
  late MovieTopRatedBloc movieTopRatedBloc;

  setUp(() {
    mockGetMovieTopRated = MockGetTopRatedMovies();
    movieTopRatedBloc = MovieTopRatedBloc(mockGetMovieTopRated);
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
    expect(movieTopRatedBloc.state, MovieTopRatedEmpty());
  });

  blocTest<MovieTopRatedBloc, MovieTopRatedState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieTopRated.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieTopRatedBloc;
    },
    act: (bloc) => bloc.add(MovieTopRated()),
    expect: () => [
      MovieTopRatedLoading(),
      MovieTopRatedHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieTopRated.execute());
    },
  );

  blocTest<MovieTopRatedBloc, MovieTopRatedState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieTopRated.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieTopRatedBloc;
    },
    act: (bloc) => bloc.add(MovieTopRated()),
    expect: () => [
      MovieTopRatedLoading(),
      MovieTopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieTopRated.execute());
    },
  );
}
