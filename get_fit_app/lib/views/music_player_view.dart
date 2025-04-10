import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";

// Music Player view widget
class MusicPlayerView extends StatefulWidget {
  const MusicPlayerView({super.key});

  @override
  State<MusicPlayerView> createState() => _MusicPlayerViewState();
}

class _MusicPlayerViewState extends State<MusicPlayerView> {
  final player = AudioPlayer(); // Audio player instance
  Duration position = Duration.zero; // Current position of the audio
  Duration duration = Duration.zero; // Total duration of the audio

  // Function to format the duration as "MM:SS"
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // Function to handle play/pause action
  void handlePlayPause() {
    if (player.playing) {
      player.pause(); // Pause if already playing
    } else {
      player.play(); // Play if paused
    }
  }

  // Function to handle seeking within the audio
  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt())); // Seek to the selected position
  }

  // Function to fetch and set the audio URL
  Future<void> fetchPlayerUrl(String link) async {
    try {
      await player.setUrl(link); // Set the audio URL
      final fetchedDuration = player.duration; // Get the duration of the audio
      if (fetchedDuration != null) {
        setState(() {
          duration = fetchedDuration; // Update the duration state
        });
      }
    } catch (e) {
      print("Error fetching audio URL: $e"); // Handle error if URL fetch fails
    }
  }

  // Initialize the player and fetch the audio
  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  // Setup the audio player with the given URL
  Future<void> _setupPlayer() async {
    // Call the fetchPlayerUrl function to load the audio URL
    await fetchPlayerUrl('https://discoveryprovider.audius.co/v1/tracks/D7KyD/stream');

    // Listen for changes in the position of the audio
    player.positionStream.listen((p) {
      setState(() {
        position = p; // Update the position of the audio
      });
    });
  }

  // Dispose of the player when the widget is disposed
  @override
  void dispose() {
    player.dispose(); // Dispose of the audio player to release resources
    super.dispose();
  }

  // Build the widget UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding to the body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // Slider for controlling the position of the audio
            Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds
                  .toDouble()
                  .clamp(0.0, duration.inSeconds.toDouble()), // Ensure slider value is within bounds
              onChanged: handleSeek, // Handle seeking when slider is moved
            ),
            // Display the formatted current position of the audio
            Text(formatDuration(position)),
            // Play/Pause button to toggle audio playback
            IconButton(
              icon: Icon(player.playing ? Icons.pause : Icons.play_arrow), // Change icon based on playback state
              onPressed: handlePlayPause, // Handle play/pause action
            )
          ],
        ),
      ),
    );
  }
}
