import 'package:flutter/material.dart';
import '../../../../features/dashboard/data/cie10_service.dart';

class AdmissionDxForm extends StatefulWidget {
  final TextEditingController dxController;
  final Cie10Service? cie10Service;

  const AdmissionDxForm({
    super.key,
    required this.dxController,
    this.cie10Service,
  });

  @override
  State<AdmissionDxForm> createState() => _AdmissionDxFormState();
}

class _AdmissionDxFormState extends State<AdmissionDxForm> {
  // 10 controllers for the 10 diagnostic slots
  late List<TextEditingController> _controllers;
  bool _isUpdatingFromParent = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(10, (_) => TextEditingController());
    widget.dxController.addListener(_onParentChanged);
    _loadFromParent();
  }

  @override
  void didUpdateWidget(covariant AdmissionDxForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dxController != widget.dxController) {
      oldWidget.dxController.removeListener(_onParentChanged);
      widget.dxController.addListener(_onParentChanged);
      _loadFromParent();
    }
  }

  // Parse existing concatenated string back into fields
  void _loadFromParent() {
    _isUpdatingFromParent = true;
    final text = widget.dxController.text;
    final lines = text.isNotEmpty ? text.split('\n') : const <String>[];
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].text = i < lines.length ? lines[i].trim() : '';
    }
    _isUpdatingFromParent = false;
  }

  // Sync all fields back to the parent controller
  void _syncToParent() {
    if (_isUpdatingFromParent) return;
    final validLines = _controllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    widget.dxController.text = validLines.join('\n');
  }

  @override
  void dispose() {
    widget.dxController.removeListener(_onParentChanged);
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             _buildSectionTitle(Icons.sick, 'VI. Impresión Diagnóstica'),
             const SizedBox(height: 20),
             
             // 5 fields Left, 5 fields Right
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                   child: Column(
                     children: List.generate(5, (index) => _buildDxField(index)),
                   ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     children: List.generate(5, (index) => _buildDxField(index + 5)),
                   ),
                 ),
               ],
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
      ],
    );
  }

  Widget _buildDxField(int index) {
    // If no service, just text field
    if (widget.cie10Service == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: TextField(
          controller: _controllers[index],
          decoration: InputDecoration(
            labelText: 'Dx ${index + 1}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            isDense: true,
          ),
          onChanged: (_) => _syncToParent(),
        ),
      );
    }

    // Autocomplete con búsqueda automática al escribir (sin tocar la lupa)
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Autocomplete<Cie10Entry>(
            optionsBuilder: (TextEditingValue v) {
              return widget.cie10Service!.search(v.text);
            },
            displayStringForOption: (Cie10Entry o) => '${o.code} - ${o.name}',
            onSelected: (entry) {
              _controllers[index].text = '${entry.code} - ${entry.name}';
              _syncToParent();
            },
            fieldViewBuilder: (context, controller, focus, onSubmitted) {
              // Mantener sincronizado con el controller base
              if (controller.text != _controllers[index].text) {
                controller.text = _controllers[index].text;
              }

              return TextField(
                controller: controller,
                focusNode: focus,
                decoration: InputDecoration(
                  labelText: 'Dx ${index + 1}',
                  suffixIcon: const Icon(Icons.search, size: 16, color: Colors.indigo),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  isDense: true,
                ),
                onChanged: (val) {
                   _controllers[index].text = val;
                   _syncToParent();
                },
                onEditingComplete: () {
                  _syncToParent();
                  FocusScope.of(context).unfocus();
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: Container(
                    width: constraints.maxWidth,
                    constraints: const BoxConstraints(maxHeight: 200),
                    color: Colors.white,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, idx) {
                        final option = options.elementAt(idx);
                        return ListTile(
                          title: Text(option.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(option.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onParentChanged() {
    if (mounted) {
      setState(_loadFromParent);
    } else {
      _loadFromParent();
    }
  }
}
