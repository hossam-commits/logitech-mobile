import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/create_ticket_form.dart';
import 'ticket_notifier.dart';

final createTicketProvider =
    NotifierProvider<TicketNotifier, CreateTicketForm>(
  TicketNotifier.new,
);
