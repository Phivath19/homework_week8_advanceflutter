import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  List<Song>? _songs;
  bool isLoading = false;
  String? errorMessage;

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  List<Song> get songs => _songs == null ? [] : _songs!;

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    // 1 - Fetch songs
    try {
      _songs = await songRepository.fetchSongs();
    } catch (e) {
      errorMessage = e.toString();
    }

    // 2 - notify listeners
    isLoading = false;
    notifyListeners();
  }

  void retry() => _init();

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
