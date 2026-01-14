import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/media_service.dart';

class TicketManagerUseCase {
  final IMediaService mediaService;
  TicketManagerUseCase(this.mediaService);

  Future<XFile?> pickAttachment(ImageSource source) async =>
      await mediaService.pickImage(source: source);
}
