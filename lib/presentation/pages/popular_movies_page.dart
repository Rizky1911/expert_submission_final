import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_popular_bloc/movie_popular_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MoviePopularBloc>().add(MoviePopular());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (context, state) {
            if (state is MoviePopularLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MoviePopularHasData) {
              final result = state.result;
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final movie = result[index];
                    return MovieCard(movie);
                  },
                  itemCount: result.length,
              );
            } else if (state is MoviePopularError) {
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
}
