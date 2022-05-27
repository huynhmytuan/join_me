import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String formatDuration(int duration) {
    final formatter = NumberFormat('00');
    if (duration >= 3600) {
      final hours = duration ~/ 3600;
      final mins = (duration - (hours * 3600)) ~/ 60;
      final seconds = duration - (hours * 3600) - (mins * 60);
      return '''${formatter.format(hours.round())}:${formatter.format(mins.round())}:${formatter.format(seconds.round())}''';
    } else {
      final mins = duration ~/ 60;
      final seconds = (duration - (mins * 60)).toInt();
      return '${formatter.format(mins.round())}:${formatter.format(seconds.round())}';
    }
  }
}
