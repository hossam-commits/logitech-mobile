import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/location_service.dart';
import 'package:logitech_mobile/core/services/media_service.dart';
import 'package:logitech_mobile/core/services/user_repository.dart';

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
      throw Exception(
        'طھط¹ط°ط± ط§ظ„ط­طµظˆظ„ ط¹ظ„ظ‰ ط§ظ„ظ…ظˆظ‚ط¹. ط§ظ„ط±ط¬ط§ط، ط§ظ„طھط£ظƒط¯ ظ…ظ† طھط´ط؛ظٹظ„ GPS',
      );
    }
    return loc;
  }

  Future<XFile?> takeSelfie() async =>
      await mediaService.pickImage(source: ImageSource.camera);

  Future<bool> validateOdometer(int input) async {
    final last = await userRepository.getLastOdometerReading();
    if (input < last) {
      throw Exception(
        'ظ‚ظٹظ…ط© ط§ظ„ط¹ط¯ط§ط¯ ط£ظ‚ظ„ ظ…ظ† ط§ظ„ظ‚ط±ط§ط،ط© ط§ظ„ط£ط®ظٹط±ط©',
      );
    }
    return true;
  }
}
