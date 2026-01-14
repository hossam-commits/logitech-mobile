import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/core/services/daily_preparation_usecase.dart';
import 'package:logitech_mobile/core/services/providers.dart';
import 'package:logitech_mobile/features/operations/domain/daily_preparation_form.dart';

class PreparationNotifier extends Notifier<DailyPreparationForm> {
  @override
  DailyPreparationForm build() {
    return const DailyPreparationForm();
  }

  DailyPreparationUseCase get _useCase => ref.watch(preparationUseCaseProvider);

  Future<void> updateLocation() async {
    try {
      final loc = await _useCase.fetchLocation();
      state = state.copyWith(locationCoordinates: loc, city: 'غير معروف');
    } on Exception catch (_) {
      // Handle error if needed
    }
  }

  Future<void> captureSelfie() async {
    final image = await _useCase.takeSelfie();
    if (image != null) {
      state = state.copyWith(selfie: image);
    }
  }

  Future<String?> submit(String odometerInput) async {
    final odo = int.tryParse(odometerInput);
    if (odo == null) {
      return 'الرجاء إدخال قراءة عداد صحيحة';
    }

    state = state.copyWith(currentOdometer: odo);

    if (state.selfie == null) {
      return 'الرجاء التقاط صورة سيلفي';
    }
    if (state.locationCoordinates == null) {
      return 'الرجاء تفعيل الموقع';
    }

    try {
      await _useCase.validateOdometer(odo);
      await Future.delayed(const Duration(seconds: 1));
      return null;
    } on Exception catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
