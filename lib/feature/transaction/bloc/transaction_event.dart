import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/dto/transaction_dto.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  const LoadTransactionsEvent();
}

class CreateTransactionEvent extends TransactionEvent {
  final CreateTransactionRequest request;

  const CreateTransactionEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  const DeleteTransactionEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class FilterTransactionsByTypeEvent extends TransactionEvent {
  final TransactionType? filterType;

  const FilterTransactionsByTypeEvent(this.filterType);

  @override
  List<Object?> get props => [filterType];
}
