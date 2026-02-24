import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/semester.dart';

class GpaLocalDataSource {
  static const _key = 'gpa_data';

  final SharedPreferences _prefs;

  GpaLocalDataSource(this._prefs);

  Future<void> save({
    required List<Semester> semesters,
    double? priorGpa,
    int? priorCredits,
    required int semesterCounter,
  }) async {
    final data = {
      'semesters': semesters.map((s) => s.toJson()).toList(),
      'priorGpa': priorGpa,
      'priorCredits': priorCredits,
      'semesterCounter': semesterCounter,
    };
    await _prefs.setString(_key, jsonEncode(data));
  }

  Map<String, dynamic>? load() {
    final json = _prefs.getString(_key);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
