import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivigil/data/repositories/report_history_repository.dart';
import 'package:nutrivigil/domain/reporting/report_history_entry.dart';

class ReportHistoryRepositoryImpl implements ReportHistoryRepository {
  ReportHistoryRepositoryImpl(this._prefs);

  final Future<SharedPreferences> _prefs;

  static const _storageKey = 'report_history_entries';

  @override
  Future<List<ReportHistoryEntry>> fetchAll() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) =>
            ReportHistoryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(ReportHistoryEntry entry) async {
    final prefs = await _prefs;
    final entries = await fetchAll();
    final updated = [entry, ...entries];
    final encoded =
        jsonEncode(updated.map((item) => item.toJson()).toList(growable: false));
    await prefs.setString(_storageKey, encoded);
  }

  @override
  Future<void> delete(String id) async {
    final prefs = await _prefs;
    final entries = await fetchAll();
    final filtered = entries.where((entry) => entry.id != id).toList();
    final encoded =
        jsonEncode(filtered.map((item) => item.toJson()).toList(growable: false));
    await prefs.setString(_storageKey, encoded);
  }
}
