import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail, GetTvRecommendations])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc movieDetailBloc;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late TvRecommendationsBloc movieRecommendationsBloc;

  const testId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    movieDetailBloc = TvDetailBloc(mockGetTvDetail);

    mockGetTvRecommendations = MockGetTvRecommendations();
    movieRecommendationsBloc = TvRecommendationsBloc(mockGetTvRecommendations);
  });

  // movie detail test
  test('initial state should be empty', () {
    expect(movieDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(testId))
            .thenAnswer((_) async => Right(testTvDetail));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(TvId(testId)),
      expect: () => <TvDetailState>[
        TvDetailLoading(),
        TvDetailHasData(testTvDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(testId));
        return TvId(testId).props;
      });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get search is unsuccessful.',
    build: () {
      when(mockGetTvDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(TvId(testId)),
    expect: () => <TvDetailState>[
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (bloc) => TvDetailLoading(),
  );

  // movie recommendations
  test('initial state should be empty', () {
    expect(movieRecommendationsBloc.state, TvRecommendationsEmpty());
  });

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTvRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testTvList));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(TvId(testId)),
      expect: () => <TvRecommendationsState>[
        TvRecommendationsLoading(),
        TvRecommendationsHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(testId));
        return TvId(testId).props;
      });

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, Error] when get data is unsuccessful.',
    build: () {
      when(mockGetTvRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(TvId(testId)),
    expect: () => <TvRecommendationsState>[
      TvRecommendationsLoading(),
      TvRecommendationsError('Server Failure'),
    ],
    verify: (bloc) => TvRecommendationsLoading(),
  );
}
