import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/tickets/domain/create_ticket_form.dart';
import 'package:logitech_mobile/features/tickets/presentation/ticket_notifier.dart';

final createTicketProvider = NotifierProvider<TicketNotifier, CreateTicketForm>(
  TicketNotifier.new,
);
