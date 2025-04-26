import 'package:flutter/material.dart';
import '../viewmodel/music_model.dart';
import '../presenter/music_presenter.dart';
import 'music_view_contract.dart';

class MusicPlayerView extends StatefulWidget {
  const MusicPlayerView({super.key});

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView>
    implements MusicViewContract {
  late final MusicPresenter _presenter;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _presenter = MusicPresenter(this);
    _presenter.init();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = _presenter.currentSong;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (song != null)
                  Image.asset(
                    song.imagePath,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 24),
                DropdownButton<SongInfo>(
                  value: song,
                  onChanged: (newSong) {
                    if (newSong != null) _presenter.selectSong(newSong);
                  },
                  items: _presenter.songs.map((song) {
                    return DropdownMenuItem<SongInfo>(
                      value: song,
                      child: Text(song.displayName),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAEC3B0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF124559),
                          inactiveTrackColor: Colors.black26,
                          thumbColor: const Color(0xFF124559),
                          overlayColor:
                              const Color(0xFF124559).withOpacity(0.2),
                        ),
                        child: Slider(
                          min: 0.0,
                          max: _duration.inSeconds.toDouble(),
                          value: _position.inSeconds
                              .toDouble()
                              .clamp(0.0, _duration.inSeconds.toDouble()),
                          onChanged: _presenter.seek,
                        ),
                      ),
                      Text(
                        _formatDuration(_position),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF01161E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        iconSize: 48,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: const Color(0xFF124559),
                        ),
                        onPressed: _presenter.togglePlayPause,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void updatePosition(Duration position) {
    setState(() => _position = position);
  }

  @override
  void updateDuration(Duration duration) {
    setState(() => _duration = duration);
  }

  @override
  void updatePlaybackStatus(bool isPlaying) {
    setState(() => _isPlaying = isPlaying);
  }

  @override
  void onSongChanged() {
    setState(() {
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
    });
  }
}
