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
    //use this logic on the api
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
              onChanged: handleSeek,
            ),
            Text("${formatDuration(position)}"),
            IconButton(
              icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
              onPressed: handlePlayPause,
            )
          ],
        ),
      ),
    );
  }
}
