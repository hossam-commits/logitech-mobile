import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/constants/mock_tickets_data.dart';
import '../../../operations/presentation/screens/accident_wizard_screen.dart';
import '../../../fleet/presentation/vehicle_checkin_screen.dart';
import '../../../operations/presentation/screens/daily_preparation_screen.dart';
import '../../../tickets/presentation/screens/create_ticket_screen.dart';
import '../../../tickets/presentation/screens/ticket_details_screen.dart';

class DashboardHomeContent extends StatefulWidget {
  const DashboardHomeContent({super.key});

  @override
  State<DashboardHomeContent> createState() =>
      _DashboardHomeContentState();
}

class _DashboardHomeContentState
    extends State<DashboardHomeContent> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '„—Õ»«° «·”«∆ﬁ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              intl.DateFormat('EEEE, d MMMM', 'ar_SA')
                  .format(DateTime.now()),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Switch(
            value: _isOnline,
            onChanged: (val) =>
                setState(() => _isOnline = val),
            activeColor: Colors.green,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const AccidentWizardScreen(),
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text(
                '≈»·«€ ⁄‰ Õ«œÀ ÿ«—∆',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  icon: Icons.directions_car_filled_outlined,
                  label: '«” ·«„ „—ﬂ»…',
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          const VehicleCheckInScreen(),
                    ),
                  ),
                ),
                _buildActionCard(
                  icon: Icons.assignment_outlined,
                  label: '«· Õ÷Ì— «·ÌÊ„Ì',
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          const DailyPreparationScreen(),
                    ),
                  ),
                ),
                _buildActionCard(
                  icon: Icons.confirmation_number_outlined,
                  label: ' –ﬂ—… ÃœÌœ…',
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          const CreateTicketScreen(),
                    ),
                  ),
                ),
                _buildActionCard(
                  icon: Icons.history,
                  label: '”Ã·Ì',
                  color: Colors.teal,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¬Œ— «· –«ﬂ—',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...MOCK_TICKETS_DATA.take(2).map(
                    (t) => Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) =>
                                  TicketDetailsScreen(
                                ticket: t,
                              ),
                            ),
                          ),
                          child: _buildTicketItem(
                            t['id'],
                            t['title'],
                            t['status'],
                            t['status'] == 'open'
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isOnline
              ? [
                  const Color(0xFF2563EB),
                  const Color(0xFF1D4ED8),
                ]
              : [
                  Colors.grey,
                  Colors.grey.shade700,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isOnline ? '√‰  „ ’· «·¬‰' : '√‰  €Ì— „ ’·',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            _isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketItem(
    String id,
    String title,
    String status,
    Color statusColor,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.confirmation_number_outlined,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                id,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status == 'open' ? '„› ÊÕ…' : '„€·ﬁ…',
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
