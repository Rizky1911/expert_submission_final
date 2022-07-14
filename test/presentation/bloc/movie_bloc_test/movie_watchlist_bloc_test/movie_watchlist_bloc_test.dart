import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist_bloc/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist_bloc/movie_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_watchlist_bloc/movie_watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';


@GenerateMocks(
    [GetWatchListStatus, GetWatchlistMovies, RemoveWatchlist, SaveWatchlist])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockSaveWatchlist mockSaveWatchlist;
  late MovieWatchlistBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockSaveWatchlist = MockSaveWatchlist();
    watchlistMoviesBloc = MovieWatchlistBloc(
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
      mockGetWatchlistMovies,
    );
  });

  test('the initial state should be empty ', () {
    expect(watchlistMoviesBloc.state, MovieWatchlistEmpty());
  });

  group('get watchlist movies test cases', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emits [Loading, HasData] state when data is successfully fetched..',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlist()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasData([testWatchlistMovie]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
        return MovieWatchlist().props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emits [Loading, Error] state when data is failed fetched..',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer(
                (_) async => Left(ServerFailure('Server Failure')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlist()),
      expect: () => <MovieWatchlistState>[
        MovieWatchlistLoading(),
        MovieWatchlistError('Server Failure'),
      ],
      verify: (bloc) => MovieWatchlistLoading(),
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emits [Loading, Empty] state when data is retrieved empty..',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlist()),
      expect: () => <MovieWatchlistState>[
        MovieWatchlistLoading(),
        MovieWatchlistHasData([]),
      ],
    );
  });

  group('get watchlist status movies test cases', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should be return true when the watchlist is true',
      build: () {
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasStatus(true)
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        return MovieWatchlistStatus(testMovieDetail.id).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'should be return false when the watchlist is false',
        build: () {
          when(mockGetWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(MovieWatchlistStatus(testMovieDetail.id)),
        expect: () => <MovieWatchlistState>[
          MovieWatchlistLoading(),
          MovieWatchlistHasStatus(false)
        ],
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(testMovieDetail.id));
          return MovieWatchlistStatus(testMovieDetail.id).props;
        });
  });

  group('remove watchlist test cases', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should update watchlist status when remove movie to watchlist is success',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistRemove(testMovieDetail)),
      expect: () => [
        MovieWatchlistSuccessMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return MovieWatchlistRemove(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should throw failure message status when remove movie from watchlist is failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
            Left(DatabaseFailure("cannot remove data from watchlist")));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistRemove(testMovieDetail)),
      expect: () => [
        MovieWatchlistError("cannot remove data from watchlist"),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return MovieWatchlistRemove(testMovieDetail).props;
      },
    );
  });

  group('add watchlist test cases', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should update watchlist status when adding movie to watchlist is success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistAdd(testMovieDetail)),
      expect: () => [
        MovieWatchlistSuccessMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return MovieWatchlistAdd(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should throw failure message status when adding movie to watchlist is failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async =>
        Left(DatabaseFailure("cannot add data to watchlist")));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistAdd(testMovieDetail)),
      expect: () => [
        MovieWatchlistError("cannot add data to watchlist"),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return MovieWatchlistAdd(testMovieDetail).props;
      },
    );
  });


}
