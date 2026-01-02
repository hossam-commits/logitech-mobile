import 'package:image_picker/image_picker.dart';

import 'media_service.dart';

class TicketManagerUseCase {
  final IMediaService mediaService;
  TicketManagerUseCase(this.mediaService);

  Future<XFile?> pickAttachment(ImageSource source) async =>
      await mediaService.pickImage(source: source);
}
