import '../../domain/entities/settings_entity.dart';

class SettingsModel {
  const SettingsModel({
    required this.userName,
    required this.email,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  final String userName;
  final String email;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      userName: userName,
      email: email,
      notificationsEnabled: notificationsEnabled,
      darkModeEnabled: darkModeEnabled,
    );
  }
}
