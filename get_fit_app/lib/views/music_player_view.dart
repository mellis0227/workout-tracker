import "package:flutter/material.dart";
import 'package:audioplayers/audioplayers.dart';

// Music Player view widget
class MusicPlayerView extends StatefulWidget {
  const MusicPlayerView({super.key});

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> playlist = [
    'sounds/northern_lights.mp3',
    'sounds/lazy_sunday.mp3',
  ];
  int currentIndex = 0;
  String currentSong = 'northern_lights.mp3';

  void playSong() async {
    await _audioPlayer.play(AssetSource(playlist[currentIndex]));
  }

  void pauseSong() async {
    await _audioPlayer.pause();
  }

  void stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      currentSong = 'None';
    });
  }

  void nextSong() {
    if (currentIndex < playlist.length - 1) {
      setState(() {
        currentIndex++;
      });
      playSong();
    }
  }

  void previousSong() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      playSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Current Song: $currentSong',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(playlist[index].split('/').last),
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                        playSong();
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 40,
                    onPressed: previousSong,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    iconSize: 40,
                    onPressed: playSong,
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    iconSize: 40,
                    onPressed: pauseSong,
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    iconSize: 40,
                    onPressed: stopSong,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 40,
                    onPressed: nextSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
