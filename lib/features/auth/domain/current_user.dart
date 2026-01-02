import 'profile.dart';

class CurrentUserStore {
  static UserProfile? _profile;

  static UserProfile? get profile => _profile;

  static void set(UserProfile? profile) {
    _profile = profile;
  }
}
