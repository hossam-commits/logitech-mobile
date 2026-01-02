import 'package:flutter/material.dart';

import 'package:logitech_mobile/core/constants/mock_tickets_data.dart';
import 'ticket_details_screen.dart';

class TicketsHistoryScreen extends StatefulWidget {
  const TicketsHistoryScreen({super.key});

  @override
  State<TicketsHistoryScreen> createState() => _TicketsHistoryScreenState();
}

class _TicketsHistoryScreenState extends State<TicketsHistoryScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all'
        ? mockTicketsData
        : mockTicketsData.where((t) => t['status'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('سجل التذاكر')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('all', 'الكل'),
                const SizedBox(width: 8),
                _buildFilterChip('open', 'مفتوحة'),
                const SizedBox(width: 8),
                _buildFilterChip('closed', 'مغلقة'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];
                final isUrgent = t['priority'] == 'urgent';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => TicketDetailsScreen(ticket: t),
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isUrgent ? Icons.warning : Icons.confirmation_number,
                        color: isUrgent ? Colors.red : Colors.blue,
                      ),
                    ),
                    title: Text(
                      t['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      ' • ',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t['status'] == 'open' ? 'مفتوحة' : 'مغلقة',
                          style: TextStyle(
                            color: t['status'] == 'open'
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => setState(() => _filter = key),
      selectedColor: const Color(0xFF2563EB),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }
}
