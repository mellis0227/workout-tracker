import 'dart:math';
import '../viewmodel/dashboard_model.dart';

class DashboardPresenter {
  final DashboardModel model;

  DashboardPresenter({required this.model});

  // Returns a random motivational quote from the model
  String getMotivationalQuote() {
    final quotes = model.quotes;
    final randomIndex = Random().nextInt(quotes.length);
    return quotes[randomIndex];
  }

  Future<String> getUsersName(String userID) async {
    return model.getUsersName(userID);
  }
}

