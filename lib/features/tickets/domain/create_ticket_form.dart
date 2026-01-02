import 'package:image_picker/image_picker.dart';

enum TicketType { maintenance, fuel, carWash, accident, general }
enum TicketPriority { low, medium, high, urgent }

class CreateTicketForm {
  TicketType? type;
  TicketPriority priority = TicketPriority.medium;
  String? title;
  String? description;
  List<XFile> photos = [];

  bool get isValid =>
      type != null &&
      title != null &&
      title!.trim().isNotEmpty &&
      description != null &&
      description!.trim().isNotEmpty;

  CreateTicketForm copyWith({
    TicketType? type,
    TicketPriority? priority,
    String? title,
    String? description,
    List<XFile>? photos,
  }) {
    return CreateTicketForm()
      ..type = type ?? this.type
      ..priority = priority ?? this.priority
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..photos = photos ?? this.photos;
  }
}
