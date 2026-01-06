import 'dart:convert';
import 'package:flutter/services.dart';

class Cie10Entry {
  final String code;
  final String name;

  Cie10Entry({required this.code, required this.name});

  factory Cie10Entry.fromJson(Map<String, dynamic> json) {
    return Cie10Entry(
      code: json['code'] as String,
      name: json['description'] as String,
    );
  }

  @override
  String toString() => '$code - $name';
}

class Cie10Service {
  List<Cie10Entry> _entries = [];

  Future<void> loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/cie10_data.json');
      final List<dynamic> data = json.decode(response);
      _entries = data.map((json) => Cie10Entry.fromJson(json)).toList();
    } catch (e) {
      print('Error loading CIE-10 data: $e');
    }
  }

  List<Cie10Entry> search(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _entries.where((entry) {
      return entry.code.toLowerCase().contains(lowerQuery) || 
             entry.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
