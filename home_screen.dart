import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'report_screen.dart';
import 'tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final List<Complaint> _complaints = [
    Complaint(
      id: 'JS-1001',
      title: 'Pothole on main road',
      category: 'Roads',
      location: 'Demo Ward, Bengaluru',
      description: 'Large pothole near the bus stop. Demo complaint.',
      status: ComplaintStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  void _addComplaint(Complaint complaint) {
    setState(() => _complaints.insert(0, complaint));
    setState(() => _index = 1);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Dashboard(onReport: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReportScreen(onSubmit: _addComplaint)),
      )),
      TrackingScreen(complaints: _complaints),
      const _RepresentativesScreen(),
      const _ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JanSamadhan', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.track_changes), label: 'My reports'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), label: 'Representatives'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final VoidCallback onReport;
  const _Dashboard({required this.onReport});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF155EEF), Color(0xFF528BFF)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your voice. Your community.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Report local civic issues and follow the action taken.', style: TextStyle(color: Colors.white)),
          ]),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: onReport,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: const Padding(padding: EdgeInsets.all(14), child: Text('Report a problem')),
        ),
        const SizedBox(height: 22),
        const Text('Browse issue categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.8, crossAxisSpacing: 10, mainAxisSpacing: 10,
          children: const [
            _CategoryTile(Icons.add_road, 'Roads'),
            _CategoryTile(Icons.water_drop_outlined, 'Water'),
            _CategoryTile(Icons.lightbulb_outline, 'Street lights'),
            _CategoryTile(Icons.delete_outline, 'Garbage'),
            _CategoryTile(Icons.water_damage_outlined, 'Drainage'),
            _CategoryTile(Icons.electrical_services, 'Electricity'),
          ],
        ),
        const SizedBox(height: 20),
        const Text('How it works', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const ListTile(leading: Icon(Icons.camera_alt_outlined), title: Text('Share the issue'), subtitle: Text('Add details, a photo and location.')),
        const ListTile(leading: Icon(Icons.forward_to_inbox_outlined), title: Text('Reach the right authority'), subtitle: Text('Reports are routed by area and issue type.')),
        const ListTile(leading: Icon(Icons.task_alt), title: Text('Track progress'), subtitle: Text('See acknowledgements and resolution updates.')),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CategoryTile(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Row(children: [const SizedBox(width: 12), Icon(icon, color: const Color(0xFF155EEF)), const SizedBox(width: 9), Flexible(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)))]),
  );
}

class _RepresentativesScreen extends StatelessWidget {
  const _RepresentativesScreen();
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: const [
    Text('Verified representatives', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
    SizedBox(height: 8),
    Text('Profiles will appear after official identity and constituency verification.'),
    SizedBox(height: 18),
    Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.verified_user_outlined)), title: Text('Representative directory'), subtitle: Text('MLA • MP • Ward Member • Councillor • Officer • Social Worker'))),
  ]);
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile and account settings — coming in the next build.'));
}
