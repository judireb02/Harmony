import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime date;

  const DateText({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM').format(date);

    return Text(
      formattedDate,
      style: Theme.of(context).primaryTextTheme.titleSmall,
    );
  }
}
