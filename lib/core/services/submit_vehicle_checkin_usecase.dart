import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/media_service.dart';

class SubmitVehicleCheckInUseCase {
  final IMediaService mediaService;
  SubmitVehicleCheckInUseCase(this.mediaService);

  Future<XFile?> captureVehicleImage() async =>
      await mediaService.pickImage(source: ImageSource.camera);
}
