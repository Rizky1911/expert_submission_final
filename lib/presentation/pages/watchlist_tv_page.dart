import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/tv_card_list.dart';

class WatchlistTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvsPageState createState() => _WatchlistTvsPageState();
}

class _WatchlistTvsPageState extends State<WatchlistTvsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvWatchlistBloc>().add(TvWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<TvWatchlistBloc>().add(TvWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
          builder: (context, state) {
            if (state is TvWatchlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvWatchlistHasData) {
              final result = state.result;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return TvCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is TvWatchlistError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
