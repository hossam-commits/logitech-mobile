import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../accident_provider.dart';

class AccidentWizardScreen extends ConsumerStatefulWidget {
  const AccidentWizardScreen({super.key});

  @override
  ConsumerState<AccidentWizardScreen> createState() =>
      _AccidentWizardScreenState();
}

class _AccidentWizardScreenState
    extends ConsumerState<AccidentWizardScreen> {
  int _step = 0;
  final _plateController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(accidentProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(accidentProvider);
    final controller = ref.read(accidentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '≈»·«€ ⁄‰ Õ«œÀ',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _step,
        onStepContinue: () async {
          if (_step == 0 && !form.isStep1Valid) {
            _showError('«·—Ã«¡ «· √ﬂœ „‰ «·„Êﬁ⁄');
            return;
          }
          if (_step == 1 && !form.isStep2Valid) {
            _showError('»Ì«‰«  «·ÿ—› «·¬Œ— ‰«ﬁ’…');
            return;
          }
          if (_step == 2 && !form.isStep3Valid) {
            _showError(
                'ÌÃ»  ’ÊÌ— «·„—ﬂ»… (4 ’Ê—) Ê«·„Êﬁ⁄');
            return;
          }
          if (_step == 3 && !form.isStep4Valid) {
            _showError('ÌÃ» —›⁄  ﬁ—Ì— —”„Ì');
            return;
          }

          if (_step < 4) {
            setState(() => _step += 1);
          } else {
            final success = await controller.submit();
            if (success && mounted) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (c) => const AlertDialog(
                  title: Text(' „ «·—›⁄'),
                  content: Text(
                      ' „  ”ÃÌ· «·Õ«œÀ Ê≈»·«€ «·„‘—›. ”·«„ ﬂ!'),
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
              );
            }
          }
        },
        onStepCancel: () {
          if (_step > 0) {
            setState(() => _step -= 1);
          }
        },
        steps: [
          Step(
            title: const Text('«·„Êﬁ⁄'),
            content: Column(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ),
                Text(
                  form.location ?? 'Ã«—Ì  ÕœÌœ «·„Êﬁ⁄...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('‰Ê⁄ «·Õ«œÀ'),
                Wrap(
                  spacing: 8,
                  children: ['collision', 'fire', 'other']
                      .map(
                        (t) => ChoiceChip(
                          label: Text(
                            t == 'collision'
                                ? ' ’«œ„'
                                : t == 'fire'
                                    ? 'Õ—Ìﬁ'
                                    : '¬Œ—',
                          ),
                          selected: form.accidentType == t,
                          onSelected: (b) =>
                              controller.setAccidentType(t),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            isActive: _step >= 0,
            state: form.isStep1Valid
                ? StepState.complete
                : StepState.editing,
          ),
          Step(
            title: const Text('«·ÿ—› «·¬Œ—'),
            content: Column(
              children: [
                SwitchListTile(
                  title: const Text('ÌÊÃœ ÿ—› ¬Œ—ø'),
                  value: form.hasOtherParty,
                  onChanged: (v) =>
                      controller.setHasOtherParty(v),
                ),
                if (form.hasOtherParty) ...[
                  TextField(
                    controller: _plateController,
                    decoration: const InputDecoration(
                      labelText: '—ﬁ„ «··ÊÕ…',
                    ),
                    onChanged: (v) => controller.setOtherPartyInfo(
                      v,
                      _phoneController.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: '—ﬁ„ «·ÃÊ«·',
                    ),
                    onChanged: (v) => controller.setOtherPartyInfo(
                      _plateController.text,
                      v,
                    ),
                  ),
                ],
              ],
            ),
            isActive: _step >= 1,
            state: form.isStep2Valid
                ? StepState.complete
                : StepState.editing,
          ),
          Step(
            title: const Text('«·’Ê—'),
            content: Column(
              children: [
                OutlinedButton.icon(
                  onPressed: () => controller.addVehiclePhoto(),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    '’Ê— „—ﬂ» ﬂ (\/4)',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => controller.addScenePhoto(),
                  icon: const Icon(Icons.add_a_photo),
                  label: Text(
                    '’Ê— «·Õ«œÀ (\)',
                  ),
                ),
                const Text(
                  'ÌÃ» «” Œœ«„ «·ﬂ«„Ì—« ›ﬁÿ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            isActive: _step >= 2,
            state: form.isStep3Valid
                ? StepState.complete
                : StepState.editing,
          ),
          Step(
            title: const Text('«· ﬁ—Ì—'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: ['najm', 'muroor']
                      .map(
                        (t) => ChoiceChip(
                          label: Text(
                            t == 'najm' ? '‰Ã„' : '«·„—Ê—',
                          ),
                          selected: form.reportType == t,
                          onSelected: (b) =>
                              controller.setReportType(t),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => controller.uploadReportDoc(),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: form.reportDoc == null
                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              Text('—›⁄ «· ﬁ—Ì— (PDF/Image)'),
                            ],
                          )
                        : const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            isActive: _step >= 3,
            state: form.isStep4Valid
                ? StepState.complete
                : StepState.editing,
          ),
          Step(
            title: const Text(' √ﬂÌœ'),
            content: const Text(
              'Â· √‰  „ √ﬂœ „‰ ’Õ… «·»Ì«‰« ø ”Ì „ ≈—”«· »·«€ ›Ê—Ì ··„‘—›Ì‰.',
            ),
            isActive: _step >= 4,
            state: StepState.indexed,
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}
