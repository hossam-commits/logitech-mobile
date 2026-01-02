import 'package:image_picker/image_picker.dart';

class AccidentReportForm {
  final DateTime? timestamp;
  final String? location;
  final String accidentType;
  final bool hasOtherParty;
  final String? otherPartyPlate;
  final String? otherPartyPhone;
  final List<XFile> vehiclePhotos;
  final List<XFile> scenePhotos;
  final String reportType;
  final XFile? reportDoc;

  const AccidentReportForm({
    this.timestamp,
    this.location,
    this.accidentType = 'collision',
    this.hasOtherParty = false,
    this.otherPartyPlate,
    this.otherPartyPhone,
    this.vehiclePhotos = const [],
    this.scenePhotos = const [],
    this.reportType = 'najm',
    this.reportDoc,
  });

  bool get isStep1Valid => timestamp != null && location != null;
  bool get isStep2Valid =>
      !hasOtherParty || (otherPartyPlate != null && otherPartyPlate!.isNotEmpty);
  bool get isStep3Valid =>
      vehiclePhotos.length == 4 && scenePhotos.isNotEmpty;
  bool get isStep4Valid => reportDoc != null;

  AccidentReportForm copyWith({
    DateTime? timestamp,
    String? location,
    String? accidentType,
    bool? hasOtherParty,
    String? otherPartyPlate,
    String? otherPartyPhone,
    List<XFile>? vehiclePhotos,
    List<XFile>? scenePhotos,
    String? reportType,
    XFile? reportDoc,
  }) {
    return AccidentReportForm(
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      accidentType: accidentType ?? this.accidentType,
      hasOtherParty: hasOtherParty ?? this.hasOtherParty,
      otherPartyPlate: otherPartyPlate ?? this.otherPartyPlate,
      otherPartyPhone: otherPartyPhone ?? this.otherPartyPhone,
      vehiclePhotos: vehiclePhotos ?? this.vehiclePhotos,
      scenePhotos: scenePhotos ?? this.scenePhotos,
      reportType: reportType ?? this.reportType,
      reportDoc: reportDoc ?? this.reportDoc,
    );
  }
}