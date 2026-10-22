class DateTimeHelpers {
  static bool isUpcoming(DateTime dateTime) {
    return dateTime.isAfter(DateTime.now());
  }

  static String timeRemaining(DateTime dateTime) {
    final diff = dateTime.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays > 0) return '${diff.inDays} days remaining';
    if (diff.inHours > 0) return '${diff.inHours} hours remaining';
    return '${diff.inMinutes} mins remaining';
  }
}
