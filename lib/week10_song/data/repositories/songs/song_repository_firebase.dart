import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String baseUrl =
      'https://week-10-firebase-531f0-default-rtdb.asia-southeast1.firebasedatabase.app';

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (_cachedSongs != null && !forceFetch) {
      return _cachedSongs!;
    }

    final Uri songsUri = Uri.parse('$baseUrl/songs.json');
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);
      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _cachedSongs = result;
      return _cachedSongs!;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song> likeSong(String songId, int currentLikes) async {
    final Uri songUri = Uri.parse('$baseUrl/songs/$songId.json');
    final int newLikes = currentLikes + 1;

    final http.Response response = await http.patch(
      songUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'likes': newLikes}),
    );

    if (response.statusCode == 200) {
      final http.Response getResponse = await http.get(songUri);
      final Map<String, dynamic> updatedJson = json.decode(getResponse.body);
      return SongDto.fromJson(songId, updatedJson);
    } else {
      throw Exception('Failed to like song');
    }
  }
}
