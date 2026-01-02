import 'package:image_picker/image_picker.dart';

import 'media_service.dart';

class SubmitVehicleCheckInUseCase {
  final IMediaService mediaService;
  SubmitVehicleCheckInUseCase(this.mediaService);

  Future<XFile?> captureVehicleImage() async =>
      await mediaService.pickImage(source: ImageSource.camera);
}
