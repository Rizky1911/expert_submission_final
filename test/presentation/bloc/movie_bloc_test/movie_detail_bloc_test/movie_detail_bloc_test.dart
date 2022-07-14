import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc movieRecommendationsBloc;

  const testId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);

    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  // movie detail test
  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(testId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(MovieId(testId)),
      expect: () => <MovieDetailState>[
        MovieDetailLoading(),
        MovieDetailHasData(testMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(testId));
        return MovieId(testId).props;
      });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get search is unsuccessful.',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(MovieId(testId)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (bloc) => MovieDetailLoading(),
  );

  // movie recommendations
  test('initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testMovieList));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(MovieId(testId)),
      expect: () => <MovieRecommendationsState>[
        MovieRecommendationsLoading(),
        MovieRecommendationsHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(testId));
        return MovieId(testId).props;
      });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, Error] when get data is unsuccessful.',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(MovieId(testId)),
    expect: () => <MovieRecommendationsState>[
      MovieRecommendationsLoading(),
      MovieRecommendationsError('Server Failure'),
    ],
    verify: (bloc) => MovieRecommendationsLoading(),
  );
}
