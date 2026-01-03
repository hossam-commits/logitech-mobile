/// lib/features/tickets/data/repositories/ticket_repository_refactored.dart
///
/// Refactored repository using dependency injection to switch between
/// mock and real data sources based on AppConfig.useMockData.
/// 
/// This demonstrates the 12-Factor App Principle III: Config
/// (configuration determines runtime behavior, not code).

import 'package:logitech_mobile/features/tickets/data/datasources/ticket_remote_datasource.dart';
import 'package:logitech_mobile/features/tickets/data/models/ticket_model.dart';
import 'package:logitech_mobile/features/tickets/domain/entities/ticket.dart';
import 'package:logitech_mobile/core/config/app_config.dart';
import 'package:logitech_mobile/core/services/mock_data_provider.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets();
  Future<void> createTicket(Ticket ticket);
}

/// Implementation with configurable data source
class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDatasource remoteDatasource;
  final MockDataProvider mockDataProvider;

  TicketRepositoryImpl({
    required this.remoteDatasource,
    required this.mockDataProvider,
  });

  @override
  Future<List<Ticket>> getTickets() async {
    // Configuration determines which data source to use
    if (AppConfig.useMockData) {
      print('[TicketRepository] Using MOCK DATA for tickets');
      return mockDataProvider.getTickets();
    }

    try {
      print('[TicketRepository] Fetching tickets from Firestore');
      final models = await remoteDatasource.getTickets();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      print('[TicketRepository] Error fetching from Firestore: $e');
      // Fallback to mock data if remote fails
      print('[TicketRepository] Falling back to MOCK DATA');
      return mockDataProvider.getTickets();
    }
  }

  @override
  Future<void> createTicket(Ticket ticket) async {
    if (AppConfig.useMockData) {
      print('[TicketRepository] Mock mode: createTicket is a no-op');
      return;
    }

    try {
      final model = TicketModel.fromEntity(ticket);
      await remoteDatasource.createTicket(model);
    } catch (e) {
      print('[TicketRepository] Error creating ticket: $e');
      rethrow;
    }
  }
}
