import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/vehicle_checkin_form.dart';
import '../../../core/services/submit_vehicle_checkin_usecase.dart';

class VehicleCheckInNotifier extends StateNotifier<VehicleCheckInForm> {
  final SubmitVehicleCheckInUseCase _useCase;

  VehicleCheckInNotifier(this._useCase) : super(VehicleCheckInForm());

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
