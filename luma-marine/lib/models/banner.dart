import 'l10n_text.dart';

class SiteBanner {
  final String id;
  final L10nText message;
  final String? startDate;
  final String? endDate;
  final bool active;

  const SiteBanner({
    required this.id,
    required this.message,
    required this.startDate,
    required this.endDate,
    required this.active,
  });

  factory SiteBanner.fromJson(Map<String, dynamic> json) => SiteBanner(
        id: json['id'] as String,
        message: L10nText.fromJson(json['message'] as Map<String, dynamic>),
        startDate: json['startDate'] as String?,
        endDate: json['endDate'] as String?,
        active: json['active'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message.toJson(),
        'startDate': startDate,
        'endDate': endDate,
        'active': active,
      };

  SiteBanner copyWith({
    L10nText? message,
    String? startDate,
    bool clearStartDate = false,
    String? endDate,
    bool clearEndDate = false,
    bool? active,
  }) {
    return SiteBanner(
      id: id,
      message: message ?? this.message,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      active: active ?? this.active,
    );
  }
}
