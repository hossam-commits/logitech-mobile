import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/daily_preparation_form.dart';
import 'daily_preparation_notifier.dart';

final preparationProvider =
    NotifierProvider<PreparationNotifier, DailyPreparationForm>(
  PreparationNotifier.new,
);
