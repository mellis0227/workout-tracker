abstract class MusicViewContract {
  void updatePosition(Duration position);
  void updateDuration(Duration duration);
  void updatePlaybackStatus(bool isPlaying);
  void onSongChanged();
}
