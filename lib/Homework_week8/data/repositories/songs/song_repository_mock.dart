// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  int _fetchSongsCallCount = 0;
  int _fetchSongByIdCallCount = 0;
  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 2, seconds: 50),
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
  ];

  @override
  Future<List<Song>> fetchSongs() async {
    await Future.delayed(const Duration(minutes: 3), () {});

    return _songs;
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    // - Simulate a delay of 3 seconds.
    await Future.delayed(Duration(seconds: 3));

    _fetchSongByIdCallCount++;
    if (_fetchSongByIdCallCount % 2 == 0) {
      throw Exception('Failed to fetch song');
    }
    // - After the delay : Find the song of given id in the list of songs and return it
    final song = _songs.where((s) => s.id == id).firstOrNull;

    // - If not found : Throw an error with the message “no song found for id 25 in the database"
     if (song == null) {
      throw Exception('No song found for id $id in the database.');
    }

    return song; // TO CHANGE !
  }
}
