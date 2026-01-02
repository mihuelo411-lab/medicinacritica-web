import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/database.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../main.dart';

class ProcedureManagementScreen extends StatefulWidget {
  const ProcedureManagementScreen({super.key});

  @override
  State<ProcedureManagementScreen> createState() => _ProcedureManagementScreenState();
}

class _ProcedureManagementScreenState extends State<ProcedureManagementScreen> {
  final _searchController = TextEditingController();
  List<Procedure> _procedures = [];
  bool _loading = true;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _refreshCatalog();
  }

  Future<void> _refreshCatalog() async {
    setState(() => _loading = true);
    await _syncProceduresFromCloud();
    await _loadProcedures();
  }

  Future<void> _loadProcedures() async {
    final query = appDatabase.select(appDatabase.procedures)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]);
    
    if (_searchController.text.isNotEmpty) {
      query.where((t) => t.name.contains(_searchController.text));
    }

    final data = await query.get();
    if (mounted) {
      setState(() {
        _procedures = data;
        _loading = false;
      });
    }
  }

  Future<void> _syncProceduresFromCloud() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    try {
      final remote = await SupabaseService().fetchProcedureCatalog();
      if (remote.isEmpty) return;
      await appDatabase.transaction(() async {
        for (final row in remote) {
          await appDatabase.into(appDatabase.procedures).insertOnConflictUpdate(
                ProceduresCompanion(
                  id: drift.Value(row['id'] as int),
                  name: drift.Value(row['name'] as String),
                  code: drift.Value(row['code'] as String?),
                  description:
                      drift.Value(row['description_template'] as String?),
                  createdAt: drift.Value(
                    DateTime.tryParse(row['created_at']?.toString() ?? '') ??
                        DateTime.now(),
                  ),
                  isSynced: const drift.Value(true),
                ),
              );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo sincronizar catálogo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _showEditDialog({Procedure? procedure}) async {
    final nameCtl = TextEditingController(text: procedure?.name);
    final codeCtl = TextEditingController(text: procedure?.code);
    final descCtl = TextEditingController(text: procedure?.description);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(procedure == null ? 'Nuevo Procedimiento' : 'Editar Procedimiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtl,
              decoration: const InputDecoration(labelText: 'Nombre *'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: codeCtl,
              decoration: const InputDecoration(labelText: 'Código (CIE/CPT)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtl.text.isEmpty) return;
             
              try {
                final response = await SupabaseService().upsertProcedureCatalogEntry(
                  id: procedure?.id,
                  name: nameCtl.text.trim(),
                  code: codeCtl.text.trim().isEmpty ? null : codeCtl.text.trim(),
                  description:
                      descCtl.text.trim().isEmpty ? null : descCtl.text.trim(),
                );
                final companion = ProceduresCompanion(
                  id: drift.Value(response['id'] as int),
                  name: drift.Value(response['name'] as String),
                  code: drift.Value(response['code'] as String?),
                  description: drift.Value(
                      response['description_template'] as String?),
                  createdAt: drift.Value(
                    DateTime.tryParse(response['created_at']?.toString() ?? '') ??
                        DateTime.now(),
                  ),
                  isSynced: const drift.Value(true),
                );
                await appDatabase
                    .into(appDatabase.procedures)
                    .insertOnConflictUpdate(companion);
                if (context.mounted) Navigator.pop(context);
                _refreshCatalog();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo guardar: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProcedure(Procedure procedure) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Procedimiento'),
        content: Text('¿Seguro que desea eliminar "${procedure.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SupabaseService().deleteProcedureCatalogEntry(procedure.id);
        await (appDatabase.delete(appDatabase.procedures)
              ..where((t) => t.id.equals(procedure.id)))
            .go();
        _refreshCatalog();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo eliminar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Procedimientos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar procedimiento...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadProcedures();
                  },
                ),
              ),
              onChanged: (_) => _loadProcedures(),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshCatalog,
                    child: _procedures.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 200, child: Center(child: Text('No hay procedimientos registrados'))),
                            ],
                          )
                        : ListView.builder(
                            itemCount: _procedures.length,
                            itemBuilder: (context, index) {
                              final p = _procedures[index];
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.medical_services_outlined)),
                                title: Text(p.name),
                                subtitle: Text(p.code ?? '-'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEditDialog(procedure: p),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteProcedure(p),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
