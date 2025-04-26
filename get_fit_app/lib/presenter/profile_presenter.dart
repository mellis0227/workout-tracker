import '../viewmodel/profile_model.dart';

class ProfilePresenter {
  final ProfileModel model = ProfileModel();

  Future<void> saveProfileData(String userID, ProfileData profileData) async {
    await model.saveProfileData(
        userID: userID,
        height: profileData.height,
        weight: profileData.weight,
        date: profileData.date,
    );
  }
}