import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";

class MusicPlayerView extends StatefulWidget {
  const MusicPlayerView({super.key});

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  final player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  Future<void> fetchPlayerUrl(String link) async {
    try {
      await player.setUrl(link);
      final fetchedDuration = player.duration;
      if (fetchedDuration != null) {
        setState(() {
          duration = fetchedDuration;
        });
      }
    } catch (e) {
      print("Error fetching audio URL: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    await fetchPlayerUrl('https://discoveryprovider.audius.co/v1/tracks/D7KyD/stream');
    player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0), // Beige background
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFAEC3B0), // Ash gray container
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
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
                  overlayColor: const Color(0xFF124559).withOpacity(0.2),
                ),
                child: Slider(
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds
                      .toDouble()
                      .clamp(0.0, duration.inSeconds.toDouble()),
                  onChanged: handleSeek,
                ),
              ),
              Text(
                formatDuration(position),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF01161E), // Rich black
                ),
              ),
              const SizedBox(height: 16),
              IconButton(
                iconSize: 48,
                icon: Icon(
                  player.playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: const Color(0xFF124559), // Midnight green
                ),
                onPressed: handlePlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}