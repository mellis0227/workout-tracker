class SongInfo {
  final String filename;
  final String displayName;
  final String imagePath;

  SongInfo(
      {required this.filename,
      required this.displayName,
      required this.imagePath});
}

class MusicModel {
  final List<SongInfo> songs = [
    SongInfo(
      filename: 'vlog_music.mp3',
      displayName: 'Yoga Music',
      imagePath: 'assets/images/yoga.png',
    ),
    SongInfo(
      filename: 'do_not_talk.mp3',
      displayName: 'Do Not Talk',
      imagePath: 'assets/images/stretchpng.png',
    ),
    SongInfo(
      filename: 'hip_hop.mp3',
      displayName: 'Hip Hop',
      imagePath: 'assets/images/bike.png',
    ),
    SongInfo(
      filename: 'upbeat.mp3',
      displayName: 'Upbeat',
      imagePath: 'assets/images/running.png',
    ),
  ];
}
