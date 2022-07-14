import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_detail_bloc/tv_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist_bloc/tv_watchlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/tv_detail.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(TvId(widget.id));
      context.read<TvRecommendationsBloc>().add(TvId(widget.id));
      context.read<TvWatchlistBloc>().add(TvWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAddedToWatchlist = context.select<TvWatchlistBloc, bool>((bloc) {
      if (bloc.state is TvWatchlistHasStatus) {
        return (bloc.state as TvWatchlistHasStatus).status;
      }
      return false;
    });
    
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            final result = state.result;
            return SafeArea(
              child: DetailContent(
                result,
                isAddedToWatchlist,
              ),
            );
          } else if (state is TvDetailError) {
            return Expanded(
              child: Center(
                child: Text(state.message),
              ),
            );
          } else {
            return Text('Failed');
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailContent extends StatefulWidget {
  final TvDetail tv;
  bool isAddedWatchlist;

  DetailContent(this.tv, this.isAddedWatchlist, {Key? key})
      : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!widget.isAddedWatchlist) {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(TvWatchlistAdd(widget.tv));
                                } else {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(TvWatchlistRemove(widget.tv));
                                }

                                final message = context.select<
                                    TvWatchlistBloc,
                                    String>((value) => (value.state
                                is TvWatchlistHasStatus)
                                    ? (value.state as TvWatchlistHasStatus)
                                    .status ==
                                    false
                                    ? watchlistAddSuccessMessage
                                    : watchlistRemoveSuccessMessage
                                    : !widget.isAddedWatchlist
                                    ? watchlistAddSuccessMessage
                                    : watchlistRemoveSuccessMessage);

                                if (message == watchlistAddSuccessMessage ||
                                    message == watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                                setState(() {
                                  widget.isAddedWatchlist =
                                  !widget.isAddedWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres),
                            ),
                            Text(
                              widget.tv.numberOfEpisodes.toString()+' Episodes',
                            ),
                            Text(
                              widget.tv.numberOfSeasons.toString()+' Seasons',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc, TvRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvRecommendationsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationsHasData) {
                                  final result = state.result;
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                    Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: result.length,
                                    ),
                                  );
                                } else if (state is TvRecommendationsError) {
                                  return Expanded(
                                    child: Center(
                                      child: Text(state.message),
                                    ),
                                  );
                                } else {
                                  return Text('Failed');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
