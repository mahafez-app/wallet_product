import '../../domain/entities/transaction_page.dart';
import 'transaction_dto.dart';

final class TransactionPageDto {
  const TransactionPageDto({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
  });

  final List<TransactionDto> transactions;
  final int totalCount;
  final TransactionsPageCursor? nextCursor;

  TransactionPage toEntity() {
    return TransactionPage(
      transactions: transactions,
      totalCount: totalCount,
      nextCursor: nextCursor,
    );
  }
}
