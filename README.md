# GetFit - Workout Tracker

A cross-platform mobile fitness app built in **Dart** and **Flutter** by a six-person Agile/Scrum team for the Software Engineering course at the University of Minnesota Duluth (Spring 2025).

GetFit lets users sign in, log runs and lifts, review their activity history, look up exercises, schedule workouts, set fitness alarms and play workout music, all from one dashboard.

## Features

- **Accounts:** email and password sign-up and login with Firebase Authentication
- **Dashboard:** a home screen showing the user's data, with navigation to every feature
- **Running log:** log runs with time and optional distance, with automatic MPH calculation
- **Lifting log:** record sets, reps and weight
- **Activity log:** view past workouts stored in Cloud Firestore
- **Exercise lookup:** search exercises by muscle, type or difficulty using the [API Ninjas Exercises API](https://www.api-ninjas.com/api/exercises)
- **Workout scheduling** and **fitness alarms**
- **Music player** with playlists for workouts
- **Profile** with a photo and personal stats

## Tech stack

| Area | Tools |
|------|-------|
| Language and UI | Dart, Flutter |
| Backend | Firebase Auth, Cloud Firestore, Firebase Realtime Database |
| State and navigation | flutter_bloc, provider, go_router |
| Other | http (REST API calls), audioplayers / just_audio, image_picker |

The code follows a **Model-View-Presenter** structure: `lib/views` holds the screens, `lib/presenter` the presentation logic, and `lib/viewmodel` the data and service layer.

## The team

| Name | GitHub |
|------|--------|
| Aidan Clark | |
| Bridgette Hingeveld | |
| Caleb Tinsley | |
| Mitchell Ellis | [@mellis0227](https://github.com/mellis0227) |
| Sam Gamez | |
| Seth Noren | |

The team worked in sprints with sprint planning, daily standups and sprint reviews, using feature branches and pull requests on GitHub. The full commit history is preserved here.

### My contributions (Mitchell Ellis)

- Built the **running log**, including logging runs without a distance and calculating MPH
- Built the **activity log** screen, which reads each user's workouts from Firestore
- Built the first **activity choice** screen and tied the running log to the signed-in user
- Fixed navigation on the **home screen** and **dashboard**

## Running it locally

This repository has had its API keys removed. To run the app you need your own:

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Create a Firebase project with Authentication (email/password) and Firestore enabled, then run `flutterfire configure` inside `get_fit_app/` to generate your own config files.
3. Get a free API key from [API Ninjas](https://api-ninjas.com/) and put it in place of `YOUR_API_NINJAS_KEY` in `get_fit_app/lib/viewmodel/api_model.dart`.
4. From `get_fit_app/`, run:

   ```bash
   flutter pub get
   flutter run
   ```

## About this repository

This is a copy of the original course repository, hosted on the University of Minnesota's GitHub Enterprise, shared with the team's permission.
