import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/mock_vehicles.dart';
import 'vehicle_checkin_provider.dart';

class VehicleCheckInScreen extends ConsumerStatefulWidget {
  const VehicleCheckInScreen({super.key});

  @override
  ConsumerState<VehicleCheckInScreen> createState() =>
      _VehicleCheckInScreenState();
}

class _VehicleCheckInScreenState
    extends ConsumerState<VehicleCheckInScreen> {
  int _currentStep = 0;
  final List<Map<String, dynamic>> _vehicles = MOCK_VEHICLES;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(vehicleCheckInProvider);
    final controller = ref.read(vehicleCheckInProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('«” ·«„ „—ﬂ»…')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep == 0 && formState.vehicleId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('«·—Ã«¡ «Œ Ì«— «·„—ﬂ»…')),
            );
            return;
          }
          if (_currentStep == 1 && formState.odometer == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('«·—Ã«¡ ≈œŒ«· ﬁ—«¡… ⁄œ«œ ’ÕÌÕ…')),
            );
            return;
          }
          if (_currentStep == 2 && formState.photos.containsValue(null)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('ÌÃ» «· ﬁ«ÿ Ã„Ì⁄ «·’Ê— «·‹ 4')),
            );
            return;
          }

          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            final success = await controller.submit();
            if (success && mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(' „ «” ·«„ «·„—ﬂ»… »‰Ã«Õ ?'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: const Text('«Œ Ì«— «·„—ﬂ»…'),
            content: DropdownButtonFormField<String>(
              value: formState.vehicleId,
              decoration: const InputDecoration(
                labelText: '«Œ — «·„—ﬂ»… „‰ «·√”ÿÊ·',
              ),
              items: _vehicles
                  .map(
                    (v) => DropdownMenuItem(
                      value: v['id'] as String,
                      child: Text(' - '),
                    ),
                  )
                  .toList(),
              onChanged: (val) => controller.setVehicleId(val),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('ﬁ—«¡… «·⁄œ«œ'),
            content: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '«·⁄œ«œ «·Õ«·Ì (ﬂ„)',
                suffixText: 'KM',
              ),
              onChanged: (val) => controller.setOdometer(val),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('’Ê— «·„—ﬂ»… (ﬂ«„Ì—« ›ﬁÿ)'),
            content: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPhoto(
                        context, '√„«„', 'front', formState.photos['front']),
                    _buildPhoto(
                        context, 'Œ·›', 'back', formState.photos['back']),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPhoto(
                        context, 'Ì„Ì‰', 'right', formState.photos['right']),
                    _buildPhoto(
                        context, 'Ì”«—', 'left', formState.photos['left']),
                  ],
                ),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto(
    BuildContext context,
    String label,
    String key,
    XFile? file,
  ) {
    return InkWell(
      onTap: () =>
          ref.read(vehicleCheckInProvider.notifier).capturePhoto(key),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: file != null
                  ? Colors.green.shade50
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: file != null ? Colors.green : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: Icon(
              file != null ? Icons.check_circle : Icons.camera_alt,
              color: file != null ? Colors.green : Colors.grey,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
