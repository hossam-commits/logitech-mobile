import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/location_service.dart';
import 'package:logitech_mobile/core/services/media_service.dart';

class AccidentReportingUseCase {
  final IMediaService mediaService;
  final ILocationService locationService;

  AccidentReportingUseCase(this.mediaService, this.locationService);

  Future<String> fetchLocation() async {
    final loc = await locationService.getCurrentCoordinates();
    return loc ?? 'Unknown Location';
  }

  Future<XFile?> captureEvidence() async =>
      await mediaService.pickImage(source: ImageSource.camera);

  Future<XFile?> uploadReport() async =>
      await mediaService.pickImage(source: ImageSource.gallery);
}
