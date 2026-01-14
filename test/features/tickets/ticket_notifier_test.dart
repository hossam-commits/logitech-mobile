import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import 'package:logitech_mobile/features/tickets/presentation/ticket_notifier.dart';
import 'package:logitech_mobile/features/tickets/presentation/ticket_provider.dart';
import 'package:logitech_mobile/features/tickets/domain/create_ticket_form.dart';
import 'package:logitech_mobile/core/services/ticket_manager_usecase.dart';
import 'package:logitech_mobile/core/services/media_service.dart';

// Mock classes using mockito
class MockTicketManagerUseCase extends Mock implements TicketManagerUseCase {}

class MockMediaService extends Mock implements IMediaService {}

void main() {
  group('TicketNotifier - Riverpod 3.x State Management', () {
    late MockTicketManagerUseCase mockUseCase;
    late ProviderContainer container;

    setUp(() {
      mockUseCase = MockTicketManagerUseCase();
      container = ProviderContainer(
        overrides: [ticketUseCaseProvider.overrideWithValue(mockUseCase)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Happy Path: initializes with default CreateTicketForm state', () {
      final state = container.read(createTicketProvider);
      expect(state.type, isNull);
      expect(state.priority, TicketPriority.medium);
      expect(state.title, isNull);
      expect(state.description, isNull);
      expect(state.photos, isEmpty);
      expect(state.isValid, isFalse);
    });

    test('Happy Path: setType updates the form state correctly', () {
      final notifier = container.read(createTicketProvider.notifier);
      notifier.setType(TicketType.maintenance);
      final state = container.read(createTicketProvider);

      expect(state.type, TicketType.maintenance);
    });

    test('Happy Path: setPriority transitions state from medium to urgent', () {
      final notifier = container.read(createTicketProvider.notifier);
      expect(
        container.read(createTicketProvider).priority,
        TicketPriority.medium,
      );

      notifier.setPriority(TicketPriority.urgent);
      expect(
        container.read(createTicketProvider).priority,
        TicketPriority.urgent,
      );
    });

    test('Happy Path: setTitle and setDescription populate the form', () {
      final notifier = container.read(createTicketProvider.notifier);
      notifier.setTitle('عطل في الفرامل');
      notifier.setDescription('المكابح لا تعمل بشكل صحيح');

      final state = container.read(createTicketProvider);
      expect(state.title, 'عطل في الفرامل');
      expect(state.description, 'المكابح لا تعمل بشكل صحيح');
    });

    test('Happy Path: form becomes valid when all required fields are set', () {
      final notifier = container.read(createTicketProvider.notifier);
      expect(container.read(createTicketProvider).isValid, isFalse);

      notifier.setType(TicketType.accident);
      notifier.setTitle('حادث');
      notifier.setDescription('حادث بسيط');

      final state = container.read(createTicketProvider);
      expect(state.isValid, isTrue);
    });

    test(
      'Edge Case: addPhoto with empty photos list adds single image',
      () async {
        final mockFile = XFile('/path/to/image.jpg');
        when(
          mockUseCase.pickAttachment(ImageSource.gallery),
        ).thenAnswer((_) async => mockFile);

        final notifier = container.read(createTicketProvider.notifier);
        await notifier.addPhoto(ImageSource.gallery);

        final state = container.read(createTicketProvider);
        expect(state.photos, hasLength(1));
        expect(state.photos.first.path, '/path/to/image.jpg');
      },
    );

    test('Edge Case: addPhoto respects max 10 photo limit', () async {
      final notifier = container.read(createTicketProvider.notifier);
      final mockFile = XFile('/path/to/image.jpg');

      when(
        mockUseCase.pickAttachment(ImageSource.gallery),
      ).thenAnswer((_) async => mockFile);

      // Add 10 photos
      for (int i = 0; i < 10; i++) {
        await notifier.addPhoto(ImageSource.gallery);
      }
      expect(container.read(createTicketProvider).photos, hasLength(10));

      // Attempt to add 11th photo
      await notifier.addPhoto(ImageSource.gallery);
      expect(container.read(createTicketProvider).photos, hasLength(10));
    });

    test('Edge Case: removePhoto at valid index removes the photo', () async {
      final notifier = container.read(createTicketProvider.notifier);
      final mockFile = XFile('/path/to/image.jpg');

      when(
        mockUseCase.pickAttachment(ImageSource.gallery),
      ).thenAnswer((_) async => mockFile);

      // Add 3 photos
      await notifier.addPhoto(ImageSource.gallery);
      await notifier.addPhoto(ImageSource.gallery);
      await notifier.addPhoto(ImageSource.gallery);

      expect(container.read(createTicketProvider).photos, hasLength(3));

      notifier.removePhoto(1);
      expect(container.read(createTicketProvider).photos, hasLength(2));
    });

    test(
      'Error Handling: removePhoto with invalid index does nothing',
      () async {
        final notifier = container.read(createTicketProvider.notifier);
        notifier.removePhoto(-1);
        notifier.removePhoto(100);

        expect(container.read(createTicketProvider).photos, isEmpty);
      },
    );

    test('Happy Path: submit resets form when valid', () async {
      final notifier = container.read(createTicketProvider.notifier);
      notifier.setType(TicketType.fuel);
      notifier.setTitle('طلب وقود');
      notifier.setDescription('احتاج وقود');

      final resultBefore = await notifier.submit();
      expect(resultBefore, isTrue);

      final stateAfter = container.read(createTicketProvider);
      expect(stateAfter.type, isNull);
      expect(stateAfter.title, isNull);
      expect(stateAfter.description, isNull);
      expect(stateAfter.photos, isEmpty);
    });

    test('Error Handling: submit returns false when form is invalid', () async {
      final notifier = container.read(createTicketProvider.notifier);
      notifier.setType(TicketType.carWash);
      // Missing title and description

      final result = await notifier.submit();
      expect(result, isFalse);

      // Form state should remain unchanged
      final state = container.read(createTicketProvider);
      expect(state.type, TicketType.carWash);
    });

    test('copyWith creates a new form instance with updated fields', () {
      final form1 = CreateTicketForm()
        ..type = TicketType.maintenance
        ..priority = TicketPriority.high
        ..title = 'عطل';

      final form2 = form1.copyWith(
        priority: TicketPriority.urgent,
        title: 'عطل خطير',
      );

      expect(form1.priority, TicketPriority.high);
      expect(form2.priority, TicketPriority.urgent);
      expect(form1.title, 'عطل');
      expect(form2.title, 'عطل خطير');
      expect(form2.type, TicketType.maintenance);
    });
  });
}
