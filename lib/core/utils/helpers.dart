import 'package:jiffy/jiffy.dart';

String formatSmartTime(DateTime scheduledDateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final callDay = DateTime(
    scheduledDateTime.year,
    scheduledDateTime.month,
    scheduledDateTime.day,
  );
  final timeLabel = Jiffy.parse(scheduledDateTime.toIso8601String()).jm;

  if (callDay == today) {
    final diff = scheduledDateTime.difference(now);
    if (!diff.isNegative && diff.inMinutes <= 60) {
      final minutes = diff.inMinutes <= 0 ? 1 : diff.inMinutes;
      return "Today, in $minutes ${minutes == 1 ? "minute" : "minutes"}";
    }
    return "Today by $timeLabel";
  }

  if (callDay == today.add(const Duration(days: 1))) {
    return "Tomorrow by $timeLabel";
  }

  final dateLabel = Jiffy.parse(scheduledDateTime.toIso8601String()).yMMMMd;
  return "$dateLabel by $timeLabel";
}