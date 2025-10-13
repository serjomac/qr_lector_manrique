import 'package:intl/intl.dart';

extension FormatString on DateTime {
  String get formtaStringDateInvitation {
    return '${DateFormat.MMMd('ES').format(this)}, ${DateFormat.jm().format(this)}';
  }

  DateTime addMonths(int months) {
    int aditionalsyeas = months ~/ 12;
    int aditionalsMonths = months % 12;
    int newYear = year + aditionalsyeas;
    int newMonth = month + aditionalsMonths;
    if (newMonth > 12) {
      newYear += 1;
      newMonth -= 12;
    }
    DateTime newDateTime = DateTime(newYear, newMonth, day,
        hour, minute, second);
    return newDateTime;
  }
}
