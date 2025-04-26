import 'dart:math';
import '../viewmodel/dashboard_model.dart';

class DashboardPresenter {
  final DashboardModel model;

  DashboardPresenter({required this.model});

  Map<int, String> weekDayMap = {
    1 : "Monday",
    2 : "Tuesday",
    3 : "Wednesday",
    4 : "Thursday",
    5 : "Friday",
    6 : "Saturday",
    7 : "Sunday",
  };

  String? getWeekdayString(DateTime currentDate) {
    return weekDayMap[currentDate.weekday];
  }

  // Returns a random motivational quote from the model
  String getMotivationalQuote() {
    final quotes = model.quotes;
    final randomIndex = Random().nextInt(quotes.length);
    return quotes[randomIndex];
  }

  Future<String> getUsersFullName(String userID) async {
    return model.getUsersFullName(userID);
  }

}
