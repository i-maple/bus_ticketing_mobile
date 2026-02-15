import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_dashboard_entity.dart';

part 'home_dashboard_model.g.dart';

@JsonSerializable()
class HomeDashboardModel {
  const HomeDashboardModel({
    required this.promoMessage,
    required this.featuredRoute,
  });

  final String promoMessage;
  final String featuredRoute;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDashboardModelToJson(this);

  HomeDashboardEntity toEntity() {
    return HomeDashboardEntity(
      promoMessage: promoMessage,
      featuredRoute: featuredRoute,
    );
  }
}
