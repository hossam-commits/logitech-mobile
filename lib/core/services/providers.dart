import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/core/services/accident_reporting_usecase.dart';
import 'package:logitech_mobile/core/services/daily_preparation_usecase.dart';
import 'package:logitech_mobile/core/services/location_service.dart';
import 'package:logitech_mobile/core/services/media_service.dart';
import 'package:logitech_mobile/core/services/submit_vehicle_checkin_usecase.dart';
import 'package:logitech_mobile/core/services/ticket_manager_usecase.dart';
import 'package:logitech_mobile/core/services/user_repository.dart';
import 'package:logitech_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:logitech_mobile/features/auth/data/repositories/auth_repository_impl.dart';

final mediaServiceProvider = Provider<IMediaService>(
  (ref) => MediaServiceImpl(),
);

final locationServiceProvider = Provider<ILocationService>(
  (ref) => LocationServiceImpl(),
);

final userRepoProvider = Provider<IUserRepository>(
  (ref) => UserRepositoryImpl(),
);

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final checkInUseCaseProvider = Provider<SubmitVehicleCheckInUseCase>((ref) {
  return SubmitVehicleCheckInUseCase(ref.watch(mediaServiceProvider));
});

final ticketUseCaseProvider = Provider<TicketManagerUseCase>((ref) {
  return TicketManagerUseCase(ref.watch(mediaServiceProvider));
});

final preparationUseCaseProvider = Provider<DailyPreparationUseCase>((ref) {
  return DailyPreparationUseCase(
    ref.watch(locationServiceProvider),
    ref.watch(userRepoProvider),
    ref.watch(mediaServiceProvider),
  );
});

final accidentUseCaseProvider = Provider<AccidentReportingUseCase>((ref) {
  return AccidentReportingUseCase(
    ref.watch(mediaServiceProvider),
    ref.watch(locationServiceProvider),
  );
});
