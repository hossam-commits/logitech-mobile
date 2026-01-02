import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/create_ticket_form.dart';
import 'ticket_notifier.dart';
import '../../../core/services/providers.dart';

final createTicketProvider =
    StateNotifierProvider<TicketNotifier, CreateTicketForm>(
  (ref) => TicketNotifier(ref.watch(ticketUseCaseProvider)),
);
