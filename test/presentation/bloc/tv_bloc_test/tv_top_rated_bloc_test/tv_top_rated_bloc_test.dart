import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rated_bloc/tv_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rated_bloc/tv_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_top_rated_bloc/tv_top_rated_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_top_rated_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TvTopRatedBloc tvTopRatedBloc;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTopRatedTvs);
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
    expect(tvTopRatedBloc.state, TvTopRatedEmpty());
  });

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(TvTopRated()),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(TvTopRated()),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
