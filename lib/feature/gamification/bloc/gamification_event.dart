import 'package:equatable/equatable.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadGamificationDataEvent extends GamificationEvent {
  const LoadGamificationDataEvent();
}

class ToggleQuestEvent extends GamificationEvent {
  final String questId;
  const ToggleQuestEvent(this.questId);
  @override
  List<Object?> get props => [questId];
}

class ClaimQuestEvent extends GamificationEvent {
  final String questId;
  const ClaimQuestEvent(this.questId);
  @override
  List<Object?> get props => [questId];
}
