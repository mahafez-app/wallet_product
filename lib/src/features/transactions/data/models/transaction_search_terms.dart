abstract final class TransactionSearchTerms {
  static String normalizeDigits(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    for (final codeUnit in value.codeUnits) {
      final isDigit = codeUnit >= 48 && codeUnit <= 57;
      if (isDigit) {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }

  static List<String> counterpartySuffixes(String? counterpartyNumber) {
    final normalizedDigits = normalizeDigits(counterpartyNumber);
    if (normalizedDigits.length < 2) {
      return const <String>[];
    }

    final suffixes = <String>[];
    for (var start = normalizedDigits.length - 2; start >= 0; start--) {
      suffixes.add(normalizedDigits.substring(start));
    }
    return suffixes;
  }
}
