abstract class IUserRepository {
  Future<int> getLastOdometerReading();
}

class UserRepositoryImpl implements IUserRepository {
  @override
  Future<int> getLastOdometerReading() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 50000;
  }
}
