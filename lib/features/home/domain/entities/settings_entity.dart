class SettingsEntity {
  const SettingsEntity({
    required this.userName,
    required this.email,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  final String userName;
  final String email;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
}
