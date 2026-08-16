import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_state.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  final String? monthFilter;
  const LoadTransactionsEvent({this.monthFilter});
  @override
  List<Object?> get props => [monthFilter];
}

class AddTransactionItemEvent extends TransactionEvent {
  final TransactionItem transaction;
  final int bonusExp;
  const AddTransactionItemEvent(this.transaction, {this.bonusExp = 0});
  @override
  List<Object?> get props => [transaction, bonusExp];
}

class UpdateTransactionItemEvent extends TransactionEvent {
  final TransactionItem transaction;
  const UpdateTransactionItemEvent(this.transaction);
  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionItemEvent extends TransactionEvent {
  final String id;
  const DeleteTransactionItemEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleTransactionClearedEvent extends TransactionEvent {
  final String id;
  const ToggleTransactionClearedEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class BulkToggleTransactionClearedEvent extends TransactionEvent {
  final bool cleared;
  const BulkToggleTransactionClearedEvent(this.cleared);
  @override
  List<Object?> get props => [cleared];
}

class SetTransactionFilterEvent extends TransactionEvent {
  final String? category;
  final bool? cleared;
  final String? search;
  final TransactionSortField? sortField;
  final bool? sortAscending;
  final bool clearCategory;
  final bool clearCleared;

  const SetTransactionFilterEvent({
    this.category,
    this.cleared,
    this.search,
    this.sortField,
    this.sortAscending,
    this.clearCategory = false,
    this.clearCleared = false,
  });

  @override
  List<Object?> get props => [
        category,
        cleared,
        search,
        sortField,
        sortAscending,
        clearCategory,
        clearCleared,
      ];
}
