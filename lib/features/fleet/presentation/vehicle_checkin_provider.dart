import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/vehicle_checkin_form.dart';
import 'vehicle_checkin_notifier.dart';
import '../../../core/services/providers.dart';

final vehicleCheckInProvider =
    NotifierProvider<VehicleCheckInNotifier, VehicleCheckInForm>(
      VehicleCheckInNotifier.new,
    );
