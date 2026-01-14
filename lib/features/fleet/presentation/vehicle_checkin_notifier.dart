import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/providers.dart';
import 'package:logitech_mobile/core/services/submit_vehicle_checkin_usecase.dart';
import 'package:logitech_mobile/features/fleet/domain/vehicle_checkin_form.dart';

class VehicleCheckInNotifier extends Notifier<VehicleCheckInForm> {
  @override
  VehicleCheckInForm build() {
    return const VehicleCheckInForm();
  }

  SubmitVehicleCheckInUseCase get _useCase => ref.watch(checkInUseCaseProvider);

  void setVehicleId(String? id) => state = state.copyWith(vehicleId: id);

  void setOdometer(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      state = state.copyWith(odometer: parsed);
    }
  }

  Future<void> capturePhoto(String side) async {
    final image = await _useCase.captureVehicleImage();
    if (image != null) {
      final newPhotos = Map<String, XFile?>.from(state.photos);
      newPhotos[side] = image;
      state = state.copyWith(photos: newPhotos);
    }
  }

  Future<bool> submit() async {
    if (!state.isValid) return false;
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
