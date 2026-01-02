import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/daily_preparation_form.dart';
import 'daily_preparation_notifier.dart';
import '../../../core/services/providers.dart';

final preparationProvider =
    StateNotifierProvider<PreparationNotifier, DailyPreparationForm>(
      (ref) => PreparationNotifier(ref.watch(preparationUseCaseProvider)),
    );
