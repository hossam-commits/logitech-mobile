import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/daily_preparation_form.dart';
import '../../../core/services/daily_preparation_usecase.dart';

class PreparationNotifier extends StateNotifier<DailyPreparationForm> {
  final DailyPreparationUseCase _useCase;

  PreparationNotifier(this._useCase) : super(DailyPreparationForm());

  Future<void> updateLocation() async {
    try {
      final loc = await _useCase.fetchLocation();
      state = state.copyWith(
        locationCoordinates: loc,
        city: 'غير معروف',
      );
    } catch (e) {
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
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
