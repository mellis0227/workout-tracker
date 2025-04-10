import 'package:flutter/material.dart';
import '../presenter/dashboard_presenter.dart';
import '../viewmodel/dashboard_model.dart';

class DashboardView extends StatelessWidget {
  final DashboardPresenter _presenter; // Presenter to handle logic
  final void Function(int index)? onTabSelected; // Callback for tab selection

  // Constructor initializes the presenter with a model
  DashboardView({super.key, this.onTabSelected})
      : _presenter = DashboardPresenter(model: DashboardModel());

  @override
  Widget build(BuildContext context) {
    final String welcomeMessage = _presenter.getWelcomeMessage(); // Get welcome message
    final String quote = _presenter.getMotivationalQuote(); // Get motivational quote

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the welcome message
            Text(
              welcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 24),

            // Display workout summary card (No workout scheduled)
            _buildCard(
              title: "Today's Workout",
              content: "No workout scheduled. Let's get moving!",
            ),
            const SizedBox(height: 16),

            // Display motivational quote card
            _buildCard(
              title: "Motivation",
              content: '"$quote"',
              isItalic: true, // Quote is italicized
            ),
            const SizedBox(height: 24),

            // Quick Access section header
            Text(
              "Quick Access",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 12),

            // Quick access tiles for different functionalities
            _buildTile(context, Icons.alarm, 'Fitness Alarm', 1),
            _buildTile(context, Icons.timeline, 'Activity Log', 2),
            _buildTile(context, Icons.api, 'Workouts', 3),
            _buildTile(context, Icons.music_note_rounded, 'Music Player', 4),
          ],
        ),
      ),
    );
  }

  // Helper method to build a card with title and content
  Widget _buildCard({
    required String title,
    required String content,
    bool isItalic = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display card title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          // Display card content, optionally italicized
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF6E6E73),
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a clickable tile with an icon and title
  Widget _buildTile(
      BuildContext context, IconData icon, String title, int tabIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => onTabSelected?.call(tabIndex), // Calls callback on tap
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary), // Icon
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1C1C1E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
