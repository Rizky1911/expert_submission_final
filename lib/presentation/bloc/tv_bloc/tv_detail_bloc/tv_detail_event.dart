import 'package:equatable/equatable.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class TvId extends TvDetailEvent {
  final int id;

  TvId(this.id);

  @override
  List<Object> get props => [id];
}