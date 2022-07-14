import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_airing_today_bloc/tv_airing_today_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_airing_today_bloc/tv_airing_today_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_airing_today_bloc/tv_airing_today_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_airing_today_bloc_test.mocks.dart';


@GenerateMocks([GetAiringTodayTvs])
void main() {
  late MockGetAiringTodayTvs mockGetAiringTodayTvs;
  late TvAiringTodayBloc tvAiringTodayBloc;

  setUp(() {
    mockGetAiringTodayTvs = MockGetAiringTodayTvs();
    tvAiringTodayBloc = TvAiringTodayBloc(mockGetAiringTodayTvs);
  });

  final tTv = Tv(
      backdropPath: "/n6vVs6z8obNbExdD3QHTr4Utu1Z.jpg",
      firstAirDate: "2019-07-25",
      genreIds: [
        10765,
        10759
      ],
      id: 76479,
      name: "The Boys",
      originCountry: [
        "US"
      ],
      originalLanguage: "en",
      originalName: "The Boys",
      overview: "A group of vigilantes known informally as “The Boys” set out to take down corrupt superheroes with no more than blue-collar grit and a willingness to fight dirty.",
      popularity: 4866.719,
      posterPath: "/stTEycfG9928HYGEISBFaG1ngjM.jpg",
      voteAverage: 8.4,
      voteCount: 6319
  );

  final tTvList = <Tv>[tTv];

  test('initial state should be empty', () {
    expect(tvAiringTodayBloc.state, TvAiringTodayEmpty());
  });

  blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(TvAiringToday()),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvs.execute());
    },
  );

  blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(TvAiringToday()),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvs.execute());
    },
  );
}
