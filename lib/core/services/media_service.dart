import 'package:image_picker/image_picker.dart';

abstract class IMediaService {
  Future<XFile?> pickImage({required ImageSource source});
}

class MediaServiceImpl implements IMediaService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return XFile('mock_path/image.jpg');
    } catch (e) {
      return null;
    }
  }
}
