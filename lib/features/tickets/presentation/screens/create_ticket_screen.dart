import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/create_ticket_form.dart';
import '../ticket_notifier.dart';
import '../ticket_provider.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createTicketProvider);
    final controller = ref.read(createTicketProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('تذكرة جديدة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'نوع التذكرة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TicketType>(
                  value: form.type,
                  hint: const Text('اختر نوع التذكرة'),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: TicketType.maintenance,
                      child: Row(
                        children: [
                          Icon(Icons.build, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('صيانة'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: TicketType.fuel,
                      child: Row(
                        children: [
                          Icon(Icons.local_gas_station, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('وقود'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: TicketType.carWash,
                      child: Row(
                        children: [
                          Icon(Icons.local_car_wash, color: Colors.cyan),
                          SizedBox(width: 8),
                          Text('غسيل'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: TicketType.accident,
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حادث'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: TicketType.general,
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('عام'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (val) => controller.setType(val),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الأولوية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPriorityChip(
                  controller,
                  form.priority,
                  TicketPriority.low,
                  'عادية',
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _buildPriorityChip(
                  controller,
                  form.priority,
                  TicketPriority.medium,
                  'متوسطة',
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildPriorityChip(
                  controller,
                  form.priority,
                  TicketPriority.high,
                  'عالية',
                  Colors.orange,
                ),
                const SizedBox(width: 8),
                _buildPriorityChip(
                  controller,
                  form.priority,
                  TicketPriority.urgent,
                  'عاجلة',
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'التفاصيل',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'عنوان التذكرة',
                hintText: 'مثال: عطل في الفرامل',
              ),
              onChanged: (val) => controller.setTitle(val),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'الوصف التفصيلي',
                hintText: 'اشرح المشكلة بالتفصيل...',
              ),
              onChanged: (val) => controller.setDescription(val),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المرفقات (صور)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('/10', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: form.photos.length + 1,
                itemBuilder: (context, index) {
                  if (index == form.photos.length) {
                    return InkWell(
                      onTap: () => _showAttachmentOptions(context, controller),
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.blue),
                            Text('إضافة', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 12,
                        child: InkWell(
                          onTap: () => controller.removePhoto(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      setState(() => _isSubmitting = true);
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      final success = await controller.submit();

                      if (!mounted) return;
                      setState(() => _isSubmitting = false);

                      if (success) {
                        navigator.pop();
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('تم إرسال التذكرة بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (!form.isValid) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('يرجى تعبئة جميع الحقول المطلوبة'),
                          ),
                        );
                      }
                    },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'إرسال التذكرة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(
    TicketNotifier controller,
    TicketPriority current,
    TicketPriority target,
    String label,
    Color color,
  ) {
    final isSelected = current == target;
    return Expanded(
      child: InkWell(
        onTap: () => controller.setPriority(target),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context, TicketNotifier controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                controller.addPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('من الاستوديو'),
              onTap: () {
                Navigator.pop(context);
                controller.addPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
