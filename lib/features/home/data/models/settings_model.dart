import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/settings_entity.dart';

part 'settings_model.g.dart';

@JsonSerializable()
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

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  SettingsEntity toEntity() {
    return SettingsEntity(
      userName: userName,
      email: email,
      notificationsEnabled: notificationsEnabled,
      darkModeEnabled: darkModeEnabled,
    );
  }
}
