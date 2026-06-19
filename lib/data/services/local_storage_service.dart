import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/leaderboard_entry.dart';

class LocalStorageService {
  static const String _leaderboardKey = 'leaderboard';
  static const String _settingsKey = 'settings';
  static const String _gameStateKey = 'game_state';

  // پاشەکەوتکردنی leaderboard
  Future<void> saveLeaderboard(List<LeaderboardEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_leaderboardKey, jsonEncode(jsonList));
  }

  // هێنانی leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_leaderboardKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => LeaderboardEntry.fromJson(json)).toList();
  }

  // پاشەکەوتکردنی دۆخی یاری
  Future<void> saveGameState(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameStateKey, jsonEncode(state));
  }

  // هێنانی دۆخی یاری
  Future<Map<String, dynamic>?> getGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gameStateKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // سڕینەوەی دۆخی یاری
  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameStateKey);
  }

  // پاشەکەوتکردنی ڕێکخستنەکان
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  // هێنانی ڕێکخستنەکان
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString == null) return {};
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
