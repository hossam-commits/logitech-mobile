import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/accident_report_form.dart';
import 'accident_notifier.dart';

final accidentProvider = NotifierProvider<AccidentNotifier, AccidentReportForm>(
  AccidentNotifier.new,
);
