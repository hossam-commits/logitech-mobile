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
        city: 'ط؛ظٹط± ظ…ط¹ط±ظˆظپ',
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
    if (odo == null) return 'ط§ظ„ط±ط¬ط§ط، ط¥ط¯ط®ط§ظ„ ظ‚ط±ط§ط،ط© ط¹ط¯ط§ط¯ طµط­ظٹط­ط©';

    state = state.copyWith(currentOdometer: odo);

    if (state.selfie == null) {
      return 'ط§ظ„ط±ط¬ط§ط، ط§ظ„طھظ‚ط§ط· طµظˆط±ط© ط³ظٹظ„ظپظٹ';
    }
    if (state.locationCoordinates == null) {
      return 'ط§ظ„ط±ط¬ط§ط، طھظپط¹ظٹظ„ ط§ظ„ظ…ظˆظ‚ط¹';
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
