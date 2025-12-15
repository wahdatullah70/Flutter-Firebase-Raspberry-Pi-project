import 'package:flutter/material.dart';
import 'dart:async';
import '../services/data_service.dart';

/// Widget that polls the Pi `/data` endpoint and displays basic telemetry.
///
/// The widget is deliberately small and focused: it polls every 3s and shows
/// a loading indicator when no data is available. On network failures it
/// displays a helpful message.
class DataWidget extends StatefulWidget {
  final String baseUrl;
  const DataWidget({super.key, required this.baseUrl});

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  Map<String, dynamic>? _data;
  String? _error;
  Timer? _timer;
  late final DataService _service;

  @override
  void initState() {
    super.initState();
    _service = DataService(widget.baseUrl);
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetch());
  }

  Future<void> _fetch() async {
    setState(() {
      _error = null; // reset error while fetching
    });
    final d = await _service.fetchData();
    if (!mounted) return;
    if (d == null) {
      setState(() {
        _data = null;
        _error = 'No data (network or server error)';
      });
      return;
    }
    setState(() {
      _data = d;
      _error = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimestamp(int? ts) {
    if (ts == null) return 'Unknown';
    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      return '${dt.toLocal()}';
    } catch (_) {
      return 'Invalid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _error != null
            ? SizedBox(
                height: 80,
                child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))),
              )
            : _data == null
                ? const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Power: ${_data!['power_w']} W', style: const TextStyle(fontSize: 18)),
                      Text('Battery: ${_data!['battery_v']} V', style: const TextStyle(fontSize: 18)),
                      Text('Status: ${_data!['status']}', style: const TextStyle(fontSize: 16)),
                      Text('Updated: ${_formatTimestamp(_data!['timestamp'] as int?)}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
      ),
    );
  }
}
