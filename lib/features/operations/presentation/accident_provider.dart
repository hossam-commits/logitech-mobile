import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/accident_report_form.dart';
import 'accident_notifier.dart';
import '../../../core/services/providers.dart';

final accidentProvider =
    StateNotifierProvider<AccidentNotifier, AccidentReportForm>(
  (ref) => AccidentNotifier(ref.watch(accidentUseCaseProvider)),
);
