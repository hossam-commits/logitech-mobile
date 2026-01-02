import 'package:image_picker/image_picker.dart';

import 'location_service.dart';
import 'user_repository.dart';
import 'media_service.dart';

class DailyPreparationUseCase {
  final ILocationService locationService;
  final IUserRepository userRepository;
  final IMediaService mediaService;

  DailyPreparationUseCase(
    this.locationService,
    this.userRepository,
    this.mediaService,
  );

  Future<String> fetchLocation() async {
    final loc = await locationService.getCurrentCoordinates();
    if (loc == null) {
      throw Exception('تعذر الحصول على الموقع. الرجاء التأكد من تشغيل GPS');
    }
    return loc;
  }

  Future<XFile?> takeSelfie() async =>
      await mediaService.pickImage(source: ImageSource.camera);

  Future<bool> validateOdometer(int input) async {
    final last = await userRepository.getLastOdometerReading();
    if (input < last) {
      throw Exception('قيمة العداد أقل من القراءة الأخيرة');
    }
    return true;
  }
}
