abstract class ILocationService {
  Future<String?> getCurrentCoordinates();
}

class LocationServiceImpl implements ILocationService {
  @override
  Future<String?> getCurrentCoordinates() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return '24.7136, 46.6753'; // Riyadh
  }
}
