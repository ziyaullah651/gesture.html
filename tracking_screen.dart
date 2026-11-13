import 'package:flutter/material.dart';
import '../models/complaint.dart';

class TrackingScreen extends StatelessWidget {
  final List<Complaint> complaints;
  const TrackingScreen({super.key, required this.complaints});

  @override
  Widget build(BuildContext context) {
    if (complaints.isEmpty) return const Center(child: Text('No reports yet. Submit your first civic issue.'));
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('My reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...complaints.map((c) => Card(
        child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), Chip(label: Text(c.statusLabel))]),
          Text('${c.category} • ${c.location}'),
          const SizedBox(height: 8),
          Text(c.description),
          const SizedBox(height: 8),
          Text('Reference: ${c.id}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ])),
      )),
    ]);
  }
}
