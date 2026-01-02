import 'package:image_picker/image_picker.dart';

class DailyPreparationForm {
  int? currentOdometer;
  XFile? selfie;
  String? locationCoordinates;
  String? city;

  bool get isValid =>
      currentOdometer != null &&
      selfie != null &&
      locationCoordinates != null;

  DailyPreparationForm copyWith({
    int? currentOdometer,
    XFile? selfie,
    String? locationCoordinates,
    String? city,
  }) {
    return DailyPreparationForm()
      ..currentOdometer = currentOdometer ?? this.currentOdometer
      ..selfie = selfie ?? this.selfie
      ..locationCoordinates = locationCoordinates ?? this.locationCoordinates
      ..city = city ?? this.city;
  }
}
