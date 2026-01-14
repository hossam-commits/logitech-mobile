import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:logitech_mobile/core/services/providers.dart';
import 'package:logitech_mobile/core/services/ticket_manager_usecase.dart';
import 'package:logitech_mobile/features/tickets/domain/create_ticket_form.dart';

class TicketNotifier extends Notifier<CreateTicketForm> {
  @override
  CreateTicketForm build() {
    return CreateTicketForm();
  }

  TicketManagerUseCase get _useCase => ref.watch(ticketUseCaseProvider);

  void setType(TicketType? type) => state = state.copyWith(type: type);

  void setPriority(TicketPriority priority) =>
      state = state.copyWith(priority: priority);

  void setTitle(String val) => state = state.copyWith(title: val);

  void setDescription(String val) => state = state.copyWith(description: val);

  Future<void> addPhoto(ImageSource source) async {
    if (state.photos.length >= 10) return;
    final image = await _useCase.pickAttachment(source);
    if (image != null) {
      state = state.copyWith(photos: [...state.photos, image]);
    }
  }

  void removePhoto(int index) {
    if (index < 0 || index >= state.photos.length) return;
    final newPhotos = List<XFile>.from(state.photos)..removeAt(index);
    state = state.copyWith(photos: newPhotos);
  }

  Future<bool> submit() async {
    if (!state.isValid) return false;
    await Future.delayed(const Duration(seconds: 1));
    state = CreateTicketForm();
    return true;
  }
}
