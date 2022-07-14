import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_now_playing_bloc/movie_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_now_playing_bloc/movie_now_playing_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_now_playing_bloc/movie_now_playing_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_now_palying_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetMovieNowPlaying;
  late MovieNowPlayingBloc movieNowPlayingBloc;

  setUp(() {
    mockGetMovieNowPlaying = MockGetNowPlayingMovies();
    movieNowPlayingBloc = MovieNowPlayingBloc(mockGetMovieNowPlaying);
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
    expect(movieNowPlayingBloc.state, MovieNowPlayingEmpty());
  });

  blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieNowPlaying.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieNowPlayingBloc;
    },
    act: (bloc) => bloc.add(MovieNowPlaying()),
    expect: () => [
      MovieNowPlayingLoading(),
      MovieNowPlayingHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieNowPlaying.execute());
    },
  );

  blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieNowPlaying.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieNowPlayingBloc;
    },
    act: (bloc) => bloc.add(MovieNowPlaying()),
    expect: () => [
      MovieNowPlayingLoading(),
      MovieNowPlayingError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieNowPlaying.execute());
    },
  );
}
