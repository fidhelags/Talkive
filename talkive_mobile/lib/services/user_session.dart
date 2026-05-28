/// Singleton sederhana untuk menyimpan data user yang sedang login.
/// Tidak perlu state management library — cukup untuk skala project ini.
class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  int?    id;
  String? name;
  String? email;
  String? preferredLanguage;

  bool get isLoggedIn => id != null;

  void setUser({
    required int id,
    required String name,
    required String email,
    String? preferredLanguage,
  }) {
    this.id                = id;
    this.name              = name;
    this.email             = email;
    this.preferredLanguage = preferredLanguage;
  }

  void clear() {
    id                = null;
    name              = null;
    email             = null;
    preferredLanguage = null;
  }
}
