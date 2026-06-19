import '../../models/leaderboard_entry.dart';
import '../services/local_storage_service.dart';

class GameRepository {
  final LocalStorageService _storageService;

  GameRepository(this._storageService);

  // Leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    return await _storageService.getLeaderboard();
  }

  Future<void> addLeaderboardEntry(LeaderboardEntry entry) async {
    final leaderboard = await getLeaderboard();
    leaderboard.add(entry);
    leaderboard.sort((a, b) => b.wins.compareTo(a.wins));
    await _storageService.saveLeaderboard(leaderboard);
  }

  // Game State
  Future<void> saveGameState(Map<String, dynamic> state) async {
    await _storageService.saveGameState(state);
  }

  Future<Map<String, dynamic>?> loadGameState() async {
    return await _storageService.getGameState();
  }

  Future<void> clearGameState() async {
    await _storageService.clearGameState();
  }

  // Settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _storageService.saveSettings(settings);
  }

  Future<Map<String, dynamic>> getSettings() async {
    return await _storageService.getSettings();
  }
}
