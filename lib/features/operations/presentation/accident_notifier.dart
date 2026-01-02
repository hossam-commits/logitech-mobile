import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/accident_report_form.dart';
import '../../../core/services/accident_reporting_usecase.dart';
import '../../../core/services/providers.dart';

class AccidentNotifier extends Notifier<AccidentReportForm> {
  @override
  AccidentReportForm build() {
    return AccidentReportForm();
  }

  AccidentReportingUseCase get _useCase => ref.watch(accidentUseCaseProvider);

  void init() async {
    final loc = await _useCase.fetchLocation();
    state = state.copyWith(timestamp: DateTime.now(), location: loc);
  }

  void setAccidentType(String type) =>
      state = state.copyWith(accidentType: type);

  void setHasOtherParty(bool has) => state = state.copyWith(hasOtherParty: has);

  void setOtherPartyInfo(String plate, String phone) =>
      state = state.copyWith(otherPartyPlate: plate, otherPartyPhone: phone);

  Future<void> addVehiclePhoto() async {
    if (state.vehiclePhotos.length >= 4) return;
    final img = await _useCase.captureEvidence();
    if (img != null) {
      state = state.copyWith(vehiclePhotos: [...state.vehiclePhotos, img]);
    }
  }

  Future<void> addScenePhoto() async {
    final img = await _useCase.captureEvidence();
    if (img != null) {
      state = state.copyWith(scenePhotos: [...state.scenePhotos, img]);
    }
  }

  void setReportType(String type) => state = state.copyWith(reportType: type);

  Future<void> uploadReportDoc() async {
    final doc = await _useCase.uploadReport();
    if (doc != null) {
      state = state.copyWith(reportDoc: doc);
    }
  }

  Future<bool> submit() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
