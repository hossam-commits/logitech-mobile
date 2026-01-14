import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/operations/presentation/preparation_provider.dart';

class DailyPreparationScreen extends ConsumerStatefulWidget {
  const DailyPreparationScreen({super.key});

  @override
  ConsumerState<DailyPreparationScreen> createState() =>
      _DailyPreparationScreenState();
}

class _DailyPreparationScreenState
    extends ConsumerState<DailyPreparationScreen> {
  final _odometerController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(preparationProvider);
    final controller = ref.read(preparationProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('التحضير اليومي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'الموقع الحالي',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    form.locationCoordinates ?? 'لم يتم التحديد',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (form.city != null)
                    Text(
                      form.city!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => controller.updateLocation(),
                    icon: const Icon(Icons.my_location),
                    label: const Text('تحديث الموقع'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.speed, size: 40, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text(
                    'قراءة العداد',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _odometerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'القراءة الحالية',
                      suffixText: 'KM',
                      hintText: 'أكبر من 50,000',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => controller.captureSelfie(),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: form.selfie != null
                        ? Colors.green
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: form.selfie == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_front,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'التقط صورة سيلفي',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, size: 80),
                            ),
                            const Positioned(
                              bottom: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
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

                      final error = await controller.submit(
                        _odometerController.text,
                      );

                      if (!mounted) return;
                      setState(() => _isSubmitting = false);

                      if (error == null) {
                        navigator.pop();
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('تم التحضير بنجاح، يوم موفق! 🌟'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.red,
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
                      'بدء الدوام',
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
}
