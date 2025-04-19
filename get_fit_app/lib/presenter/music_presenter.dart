import 'package:just_audio/just_audio.dart';
import '../viewmodel/music_model.dart';
import '../views/music_view_contract.dart';

class MusicPresenter {
  final AudioPlayer _player = AudioPlayer();
  final MusicModel _model = MusicModel();
  final MusicViewContract view;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  SongInfo? currentSong;

  MusicPresenter(this.view);

  List<SongInfo> get songs => _model.songs;

  void init() {
    currentSong = _model.songs[0];
    loadCurrentSong();

    _player.positionStream.listen((pos) {
      position = pos;
      view.updatePosition(pos);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        duration = dur;
        view.updateDuration(dur);
      }
    });
  }

  void loadCurrentSong() async {
    if (currentSong != null) {
      await _player.setAsset('assets/music/${currentSong!.filename}');
      await _player.load();
    }
  }

  void selectSong(SongInfo song) {
    currentSong = song;
    loadCurrentSong();
    view.onSongChanged();
  }

  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    view.updatePlaybackStatus(_player.playing);
  }

  void seek(double seconds) {
    _player.seek(Duration(seconds: seconds.toInt()));
  }

  void dispose() {
    _player.dispose();
  }
}
