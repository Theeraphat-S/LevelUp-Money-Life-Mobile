import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

class CheckInDailyEvent extends DashboardEvent {
  const CheckInDailyEvent();
}

class ClaimQuestRewardEvent extends DashboardEvent {
  final String questId;

  const ClaimQuestRewardEvent(this.questId);

  @override
  List<Object?> get props => [questId];
}
