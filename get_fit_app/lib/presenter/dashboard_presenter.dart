import 'dart:math';
import '../viewmodel/dashboard_model.dart';

class DashboardPresenter {
  final DashboardModel model;

  DashboardPresenter({required this.model});

  String getWelcomeMessage() {
    return "Welcome back, User!";
  }

  String getMotivationalQuote() {
    final quotes = model.quotes;
    final randomIndex = Random().nextInt(quotes.length);
    return quotes[randomIndex];
  }
}
