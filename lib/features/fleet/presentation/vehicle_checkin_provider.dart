import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/fleet/domain/vehicle_checkin_form.dart';
import 'package:logitech_mobile/features/fleet/presentation/vehicle_checkin_notifier.dart';

final vehicleCheckInProvider =
    NotifierProvider<VehicleCheckInNotifier, VehicleCheckInForm>(
      VehicleCheckInNotifier.new,
    );
