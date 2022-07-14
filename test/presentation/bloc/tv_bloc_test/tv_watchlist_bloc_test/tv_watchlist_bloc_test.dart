import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';


@GenerateMocks(
    [GetWatchListStatusTv, GetWatchlistTvs, RemoveWatchlistTv, SaveWatchlistTv])
void main() {
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockSaveWatchlist mockSaveWatchlist;
  late TvWatchlistBloc watchlistTvsBloc;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockSaveWatchlist = MockSaveWatchlist();
    watchlistTvsBloc = TvWatchlistBloc(
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
      mockGetWatchlistTvs,
    );
  });

  test('the initial state should be empty ', () {
    expect(watchlistTvsBloc.state, TvWatchlistEmpty());
  });

  group('get watchlist tvs test cases', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emits [Loading, HasData] state when data is successfully fetched..',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlist()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistHasData([testWatchlistTv]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
        return TvWatchlist().props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emits [Loading, Error] state when data is failed fetched..',
      build: () {
        when(mockGetWatchlistTvs.execute()).thenAnswer(
                (_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlist()),
      expect: () => <TvWatchlistState>[
        TvWatchlistLoading(),
        TvWatchlistError('Server Failure'),
      ],
      verify: (bloc) => TvWatchlistLoading(),
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emits [Loading, Empty] state when data is retrieved empty..',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlist()),
      expect: () => <TvWatchlistState>[
        TvWatchlistLoading(),
        TvWatchlistHasData([]),
      ],
    );
  });

  group('get watchlist status tvs test cases', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should be return true when the watchlist is true',
      build: () {
        when(mockGetWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistStatus(testTvDetail.id)),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistHasStatus(true)
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testTvDetail.id));
        return TvWatchlistStatus(testTvDetail.id).props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
        'should be return false when the watchlist is false',
        build: () {
          when(mockGetWatchListStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return watchlistTvsBloc;
        },
        act: (bloc) => bloc.add(TvWatchlistStatus(testTvDetail.id)),
        expect: () => <TvWatchlistState>[
          TvWatchlistLoading(),
          TvWatchlistHasStatus(false)
        ],
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(testTvDetail.id));
          return TvWatchlistStatus(testTvDetail.id).props;
        });
  });

  group('remove watchlist test cases', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should update watchlist status when remove tv to watchlist is success',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistRemove(testTvDetail)),
      expect: () => [
        TvWatchlistSuccessMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        return TvWatchlistRemove(testTvDetail).props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should throw failure message status when remove tv from watchlist is failed',
      build: () {
        when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer((_) async =>
            Left(DatabaseFailure("cannot remove data from watchlist")));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistRemove(testTvDetail)),
      expect: () => [
        TvWatchlistError("cannot remove data from watchlist"),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvDetail));
        return TvWatchlistRemove(testTvDetail).props;
      },
    );
  });

  group('add watchlist test cases', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should update watchlist status when adding tv to watchlist is success',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistAdd(testTvDetail)),
      expect: () => [
        TvWatchlistSuccessMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        return TvWatchlistAdd(testTvDetail).props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should throw failure message status when adding tv to watchlist is failed',
      build: () {
        when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer((_) async =>
            Left(DatabaseFailure("cannot add data to watchlist")));
        return watchlistTvsBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistAdd(testTvDetail)),
      expect: () => [
        TvWatchlistError("cannot add data to watchlist"),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvDetail));
        return TvWatchlistAdd(testTvDetail).props;
      },
    );
  });


}
