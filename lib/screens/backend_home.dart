import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../services/api_service.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../widgets/data_widget.dart';

class BackendHomeScreen extends StatelessWidget {
  const BackendHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solar Pesticide Sprayer'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
              Tab(icon: Icon(Icons.person_outline), text: 'Account'),
              Tab(icon: Icon(Icons.storage_outlined), text: 'Firestore'),
              Tab(icon: Icon(Icons.cloud_upload_outlined), text: 'Storage'),
              Tab(icon: Icon(Icons.http_outlined), text: 'API'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SprayerDashboardTab(),
            _AccountTab(),
            _FirestoreTab(),
            _StorageTab(),
            _ApiTab(),
          ],
        ),
      ),
    );
  }
}

class _SprayerDashboardTab extends StatefulWidget {
  const _SprayerDashboardTab();

  @override
  State<_SprayerDashboardTab> createState() => _SprayerDashboardTabState();
}

class _SprayerDashboardTabState extends State<_SprayerDashboardTab> {
  String _piBaseUrl = '';
  bool _mappingActive = true;

  Future<void> _showSetPiDialog() async {
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
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save')),
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

  Widget _statusChip(String status) {
    final colour = _statusColor(status);
    return Chip(
      label: Text(status),
      side: BorderSide(color: colour),
      labelStyle: TextStyle(color: colour, fontWeight: FontWeight.w600),
      backgroundColor: colour.withValues(alpha: 0.12),
    );
  }

  @override
  Widget build(BuildContext context) {
    const location = 'Section B – Aisle 3';
    const batteryLevel = 0.85;
    const tankLevel = 0.60;
    const fieldStatuses = <String>[
      'Healthy',
      'Healthy',
      'Defected',
      'Healthy',
      'Defected',
      'Healthy'
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Raspberry Pi API'),
            subtitle: Text(_piBaseUrl.isEmpty ? 'Not set' : _piBaseUrl),
            trailing: FilledButton.tonal(
              onPressed: _showSetPiDialog,
              child: Text(_piBaseUrl.isEmpty ? 'Set' : 'Edit'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_piBaseUrl.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Live Data',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  DataWidget(baseUrl: _piBaseUrl),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Battery',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(value: batteryLevel),
                      const SizedBox(height: 6),
                      Text('${(batteryLevel * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tank',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(value: tankLevel),
                      const SizedBox(height: 6),
                      Text('${(tankLevel * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Sprayer Location'),
            subtitle: Text(location),
          ),
        ),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.map_outlined),
            title: const Text('Field Mapping'),
            subtitle: Text(_mappingActive ? 'Active' : 'Inactive'),
            value: _mappingActive,
            onChanged: (val) => setState(() => _mappingActive = val),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Field Health Status',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: fieldStatuses.map(_statusChip).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(user?.email == null
                    ? 'Signed in'
                    : 'Signed in as: ${user!.email}'),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed out')));
                    }
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FirestoreTab extends StatefulWidget {
  const _FirestoreTab();

  @override
  State<_FirestoreTab> createState() => _FirestoreTabState();
}

class _FirestoreTabState extends State<_FirestoreTab> {
  final DatabaseService _db = DatabaseService();
  final _newCtrl = TextEditingController();

  bool _adding = false;

  @override
  void dispose() {
    _newCtrl.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _add() async {
    final name = _newCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _adding = true);
    try {
      await _db.addData('demo_items', {
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _newCtrl.clear();
    } catch (e) {
      _snack('Add failed: $e');
    } finally {
      setState(() => _adding = false);
    }
  }

  Future<void> _edit(String docId, String currentName) async {
    final ctrl = TextEditingController(text: currentName);
    final updated = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit item'),
        content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );

    if (updated == null || updated.isEmpty || updated == currentName) return;
    try {
      await _db.updateData('demo_items', docId, {'name': updated});
    } catch (e) {
      _snack('Update failed: $e');
    }
  }

  Future<void> _delete(String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (ok != true) return;
    try {
      await _db.deleteData('demo_items', docId);
    } catch (e) {
      _snack('Delete failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('demo_items')
        .limit(50)
        .snapshots();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        final user = authSnap.data;
        final signedIn = user != null;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newCtrl,
                          decoration: InputDecoration(
                            labelText: 'New item',
                            helperText:
                                signedIn ? null : 'Sign in to use Firestore',
                          ),
                          enabled: signedIn && !_adding,
                          onSubmitted: (_) => signedIn ? _add() : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: (!signedIn || _adding) ? null : _add,
                        child: _adding
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: !signedIn
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child:
                            Text('Sign in first, then come back to Firestore.'),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: query,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          final msg = snapshot.error.toString();
                          final looksLikePerm =
                              msg.contains('PERMISSION_DENIED') ||
                                  msg.contains(
                                      'Missing or insufficient permissions');
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                looksLikePerm
                                    ? 'Firestore permission denied. Update Firestore Rules in Firebase Console.'
                                    : 'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) {
                          return const Center(
                              child: Text('No items yet. Add your first one.'));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: docs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data();
                            final name = (data['name'] ?? '').toString();
                            final createdAt = data['createdAt'];

                            return Card(
                              child: ListTile(
                                title: Text(name.isEmpty ? '(unnamed)' : name),
                                subtitle: createdAt is Timestamp
                                    ? Text('Created: ${createdAt.toDate()}')
                                    : null,
                                onTap: () => _edit(doc.id, name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _delete(doc.id),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StorageTab extends StatefulWidget {
  const _StorageTab();

  @override
  State<_StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<_StorageTab> {
  final StorageService _storage = StorageService();

  PlatformFile? _picked;
  bool _uploading = false;
  String _downloadUrl = '';

  final _remotePathCtrl = TextEditingController(text: 'uploads/demo.txt');

  @override
  void dispose() {
    _remotePathCtrl.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
      allowMultiple: false,
    );
    if (res == null || res.files.isEmpty) return;
    setState(() {
      _picked = res.files.first;
      _downloadUrl = '';
    });
  }

  Future<void> _upload() async {
    final file = _picked;
    if (file == null) {
      _snack('Pick a file first');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _snack('Sign in first (Auth tab) to upload to Storage');
      return;
    }

    final uid = user.uid;
    final safeName = (file.name.isEmpty) ? 'file' : file.name;
    final remotePath =
        'uploads/$uid/${DateTime.now().millisecondsSinceEpoch}_$safeName';

    setState(() => _uploading = true);
    try {
      String? url;
      if (file.bytes != null) {
        url = await _storage.uploadBytes(remotePath, file.bytes!);
      } else if (file.path != null) {
        url = await _storage.uploadFilePath(remotePath, file.path!);
      }

      if (url == null) {
        _snack('Upload failed');
      } else {
        setState(() => _downloadUrl = url!);
        _snack('Uploaded');
      }
    } catch (e) {
      _snack('Upload error: $e');
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _downloadToDevice() async {
    if (kIsWeb) {
      _snack('Download-to-device is not supported on web');
      return;
    }

    final remote = _remotePathCtrl.text.trim();
    if (remote.isEmpty) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = remote.split('/').isNotEmpty
          ? remote.split('/').last
          : 'download.bin';
      final localPath = '${dir.path}/$fileName';
      final saved = await _storage.downloadFile(remote, localPath);
      if (saved == null) {
        _snack('Download failed');
      } else {
        _snack('Saved to: $saved');
      }
    } catch (e) {
      _snack('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Upload',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(_picked == null
                    ? 'No file selected'
                    : 'Selected: ${_picked!.name} (${_picked!.size} bytes)'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _uploading ? null : _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Pick file'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _uploading ? null : _upload,
                      icon: _uploading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Upload'),
                    ),
                  ],
                ),
                if (_downloadUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('Download URL',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  SelectableText(_downloadUrl),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Download (device only)',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: _remotePathCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Remote path in Storage'),
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: _downloadToDevice,
                  child: const Text('Download to device'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ApiTab extends StatefulWidget {
  const _ApiTab();

  @override
  State<_ApiTab> createState() => _ApiTabState();
}

class _ApiTabState extends State<_ApiTab> {
  final ApiService _api = ApiService();

  final _urlCtrl = TextEditingController();
  final _jsonCtrl = TextEditingController(text: jsonEncode({'test': 'data'}));

  bool _busy = false;
  String _result = '';

  @override
  void dispose() {
    _urlCtrl.dispose();
    _jsonCtrl.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _get() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      _snack('Enter a URL');
      return;
    }

    setState(() => _busy = true);
    final res = await _api.getRequest(url);
    setState(() {
      _busy = false;
      _result = res == null
          ? 'GET failed'
          : 'Status: ${res.statusCode}\n\n${res.body}';
    });
  }

  Future<void> _post() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      _snack('Enter a URL');
      return;
    }

    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(_jsonCtrl.text);
      if (decoded is! Map<String, dynamic>) {
        _snack('JSON body must be an object');
        return;
      }
      data = decoded;
    } catch (_) {
      _snack('Invalid JSON');
      return;
    }

    setState(() => _busy = true);
    final res = await _api.postRequest(url, data);
    setState(() {
      _busy = false;
      _result = res == null
          ? 'POST failed'
          : 'Status: ${res.statusCode}\n\n${res.body}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('HTTP Client',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: _urlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://example.com/api',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _jsonCtrl,
                  minLines: 4,
                  maxLines: 10,
                  decoration:
                      const InputDecoration(labelText: 'POST JSON body'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton(
                        onPressed: _busy ? null : _get,
                        child: const Text('GET')),
                    const SizedBox(width: 12),
                    OutlinedButton(
                        onPressed: _busy ? null : _post,
                        child: const Text('POST')),
                    if (_busy) ...[
                      const SizedBox(width: 12),
                      const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_result.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Result',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SelectableText(_result),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
