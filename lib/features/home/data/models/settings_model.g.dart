// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      userName: json['userName'] as String,
      email: json['email'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      darkModeEnabled: json['darkModeEnabled'] as bool,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'email': instance.email,
      'notificationsEnabled': instance.notificationsEnabled,
      'darkModeEnabled': instance.darkModeEnabled,
    };
