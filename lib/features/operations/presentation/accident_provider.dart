import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/operations/domain/accident_report_form.dart';
import 'package:logitech_mobile/features/operations/presentation/accident_notifier.dart';

final accidentProvider = NotifierProvider<AccidentNotifier, AccidentReportForm>(
  AccidentNotifier.new,
);
