import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular_bloc/tv_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular_bloc/tv_popular_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_popular_bloc/tv_popular_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late TvPopularBloc tvPopularBloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    tvPopularBloc = TvPopularBloc(mockGetPopularTvs);
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
    expect(tvPopularBloc.state, TvPopularEmpty());
  });

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(TvPopular()),
    expect: () => [
      TvPopularLoading(),
      TvPopularHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(TvPopular()),
    expect: () => [
      TvPopularLoading(),
      TvPopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
