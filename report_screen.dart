import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ReportScreen extends StatefulWidget {
  final ValueChanged<Complaint> onSubmit;
  const ReportScreen({super.key, required this.onSubmit});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();
  String _category = 'Roads';

  @override
  void dispose() {
    _title.dispose(); _description.dispose(); _location.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final complaint = Complaint(
      id: 'JS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: _title.text.trim(),
      category: _category,
      location: _location.text.trim(),
      description: _description.text.trim(),
      status: ComplaintStatus.submitted,
      createdAt: DateTime.now(),
    );
    widget.onSubmit(complaint);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo report added. Connect Supabase to submit live reports.')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Report a problem')),
    body: Form(
      key: _formKey,
      child: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('Tell us what needs attention', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: const InputDecoration(labelText: 'Issue category'),
          items: ['Roads', 'Water', 'Drainage', 'Garbage', 'Street lights', 'Electricity', 'Public safety', 'Other']
            .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _category = v ?? 'Roads'),
        ),
        const SizedBox(height: 14),
        TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Short title'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null),
        const SizedBox(height: 14),
        TextFormField(controller: _description, maxLines: 4, decoration: const InputDecoration(labelText: 'Describe the problem'), validator: (v) => (v == null || v.trim().length < 10) ? 'Please add at least 10 characters' : null),
        const SizedBox(height: 14),
        TextFormField(controller: _location, decoration: const InputDecoration(labelText: 'Area / village / ward / city', prefixIcon: Icon(Icons.location_on_outlined)), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter the location' : null),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo picker will be connected in the next backend step.'))), icon: const Icon(Icons.add_a_photo_outlined), label: const Text('Attach photo or video (next step)')),
        const SizedBox(height: 24),
        FilledButton(onPressed: _submit, child: const Padding(padding: EdgeInsets.all(14), child: Text('Submit report'))),
        const SizedBox(height: 10),
        const Text('Do not include private information about other people. For emergencies, contact the appropriate emergency service directly.', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    ),
  );
}
