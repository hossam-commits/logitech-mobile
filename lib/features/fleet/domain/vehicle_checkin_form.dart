import 'package:image_picker/image_picker.dart';

class VehicleCheckInForm {
  final String? vehicleId;
  final int? odometer;
  final Map<String, XFile?> photos;

  const VehicleCheckInForm({
    this.vehicleId,
    this.odometer,
    this.photos = const {
      'front': null,
      'back': null,
      'right': null,
      'left': null,
    },
  });

  bool get isValid =>
      vehicleId != null &&
      odometer != null &&
      odometer! > 0 &&
      !photos.containsValue(null);

  VehicleCheckInForm copyWith({
    String? vehicleId,
    int? odometer,
    Map<String, XFile?>? photos,
  }) {
    return VehicleCheckInForm(
      vehicleId: vehicleId ?? this.vehicleId,
      odometer: odometer ?? this.odometer,
      photos: photos ?? this.photos,
    );
  }
}