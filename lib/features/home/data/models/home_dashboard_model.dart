import '../../domain/entities/home_dashboard_entity.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.promoMessage,
    required this.featuredRoute,
  });

  final String promoMessage;
  final String featuredRoute;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    return HomeDashboardModel(
      promoMessage: json['promoMessage'] as String? ?? '',
      featuredRoute: json['featuredRoute'] as String? ?? '',
    );
  }

  HomeDashboardEntity toEntity() {
    return HomeDashboardEntity(
      promoMessage: promoMessage,
      featuredRoute: featuredRoute,
    );
  }
}
