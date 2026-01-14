import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/operations/domain/daily_preparation_form.dart';
import 'package:logitech_mobile/features/operations/presentation/daily_preparation_notifier.dart';

final preparationProvider =
    NotifierProvider<PreparationNotifier, DailyPreparationForm>(
      PreparationNotifier.new,
    );
