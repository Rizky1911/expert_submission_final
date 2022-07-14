import 'package:equatable/equatable.dart';

abstract class MovieNowPlayingEvent extends Equatable {
  const MovieNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class MovieNowPlaying extends MovieNowPlayingEvent {
  @override
  List<Object> get props => [];
}