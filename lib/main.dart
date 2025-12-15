import 'package:flutter/material.dart';
import 'widgets/data_widget.dart';

void main() {
  runApp(const SprayerApp());
}

class SprayerApp extends StatelessWidget {
  const SprayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Pesticide Sprayer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SprayerDashboard(),
    );
  }
}

class SprayerDashboard extends StatefulWidget {
  const SprayerDashboard({super.key});

  @override
  State<SprayerDashboard> createState() => _SprayerDashboardState();
}

class _SprayerDashboardState extends State<SprayerDashboard> {
  // Edit this to point to your Raspberry Pi API (e.g. http://192.168.1.100:5000)
  String _piBaseUrl = '';
  // Controls whether field mapping is active (toggled by the UI switch)
  bool _mappingActive = true;

  // Show a dialog allowing the user to set the Pi base URL used by DataWidget.
  void _showSetPiDialog() async {
    final controller = TextEditingController(text: _piBaseUrl);
    final res = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Raspberry Pi base URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'http://<pi-ip>:5000'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );
    if (res != null) setState(() => _piBaseUrl = res.trim());
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'defected':
        return Colors.red;
      case 'healthy':
      default:
        return Colors.green;
    }
  }

  Widget _statusBadge(String status) {
    final colour = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colour.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colour),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colour,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample values (replace with your live data)
    const location = 'Section B – Aisle 3';
    const batteryLevel = 0.85; // 85%
    const tankLevel = 0.60; // 60%
    const fieldStatuses = <String>[
      'Healthy', 'Healthy', 'Defected', 'Healthy', 'Defected', 'Healthy'
    ];
    final List<Widget> statusBadges = <Widget>[];
    for (final status in fieldStatuses) {
      statusBadges.add(_statusBadge(status));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Pesticide Sprayer'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'Set Raspberry Pi URL',
            onPressed: _showSetPiDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_piBaseUrl.isNotEmpty) ...[
              const Text('Connected to Pi API:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_piBaseUrl),
              const SizedBox(height: 12),
              // DataWidget will fetch data from Pi
              DataWidget(baseUrl: _piBaseUrl),
              const SizedBox(height: 12),
            ] else ...[
              Card(
                color: Colors.yellow[50],
                  child: const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('No Raspberry Pi URL set'),
                    subtitle: Text('Tap the cloud icon in the top-right to add the Pi address (e.g. http://192.168.1.100:5000).'),
                ),
              ),
              const SizedBox(height: 12),
            ],

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Sprayer Location'),
                subtitle: Text(location),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.battery_full),
                title: const Text('Battery Level'),
                subtitle: Text('${(batteryLevel * 100).toStringAsFixed(0)}%'),
                trailing: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: batteryLevel,
                    // use valueColor for compatibility across Flutter SDKs
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.local_florist),
                title: const Text('Pesticide Tank Level'),
                subtitle: Text('${(tankLevel * 100).toStringAsFixed(0)}%'),
                trailing: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: tankLevel,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.orange),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Field Mapping'),
                subtitle: Text(_mappingActive ? 'Active' : 'Inactive'),
                trailing: Switch(
                  value: _mappingActive,
                  onChanged: (val) => setState(() => _mappingActive = val),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Field Health Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statusBadges,
            ),
          ],
        ),
      ),
    );
  }
}
