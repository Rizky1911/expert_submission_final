import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvAiringTodayState extends Equatable {
  const TvAiringTodayState();

  @override
  List<Object> get props => [];
}

class TvAiringTodayEmpty extends TvAiringTodayState {}

class TvAiringTodayLoading extends TvAiringTodayState {}

class TvAiringTodayError extends TvAiringTodayState {
  final String message;

  TvAiringTodayError(this.message);

  @override
  List<Object> get props => [message];
}

class TvAiringTodayHasData extends TvAiringTodayState {
  final List<Tv> result;

  TvAiringTodayHasData(this.result);

  @override
  List<Object> get props => [result];
}