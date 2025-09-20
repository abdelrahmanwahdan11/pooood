class UserPref {
  const UserPref({
    this.languageCode = 'en',
    this.notificationsEnabled = true,
    this.darkMode = false,
  });

  final String languageCode;
  final bool notificationsEnabled;
  final bool darkMode;

  UserPref copyWith({
    String? languageCode,
    bool? notificationsEnabled,
    bool? darkMode,
  }) {
    return UserPref(
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
