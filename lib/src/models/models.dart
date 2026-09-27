import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

DateTime _dateFromJson(Object value) => value is Timestamp
    ? value.toDate()
    : DateTime.tryParse(value.toString()) ?? DateTime.now();

Object _dateToJson(DateTime value) => Timestamp.fromDate(value);

enum ListingCategory { textbooks, electronics, dorm, clothing, supplies, other }

enum ListingCondition { newItem, likeNew, good, fair }

enum ListingType { sale, swap, free }

enum ListingStatus { active, reserved, sold, swapped }

enum SwapStatus { pending, accepted, declined, cancelled }

enum NotificationType {
  message,
  swapRequest,
  swapAccepted,
  swapDeclined,
  listingSold,
  listingSwapped,
  system,
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String displayName,
    required String university,
    String? photoUrl,
    String? bio,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @Default(<String>[]) List<String> fcmTokens,
    @Default(0) double rating,
    @Default(0) int ratingCount,
    @Default('user') String role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required String sellerId,
    required String sellerName,
    String? sellerPhoto,
    required String title,
    required String description,
    required double price,
    required ListingCategory category,
    required ListingCondition condition,
    required ListingType type,
    required String campus,
    String? author,
    String? courseCode,
    String? isbn,
    @Default(0) int favoriteCount,
    @Default(<String>[]) List<String> imageUrls,
    @Default(ListingStatus.active) ListingStatus status,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
    @Default(<String>[]) List<String> searchKeywords,
    @Default(0) int viewCount,
  }) = _Listing;

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);
}

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String listingId,
    required String listingTitle,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
    required List<String> participantIds,
    required String lastMessage,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime lastMessageAt,
    @Default(<String>[]) List<String> unreadBy,
    @Default(<String, int>{}) Map<String, int> unreadCounts,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String senderId,
    required String text,
    String? imageUrl,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime sentAt,
    @Default(<String>[]) List<String> readBy,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
abstract class SwapProposal with _$SwapProposal {
  const factory SwapProposal({
    required String id,
    required String listingId,
    required String listingTitle,
    required String offererId,
    required String ownerId,
    String? offeredListingId,
    String? offeredListingTitle,
    String? message,
    @Default(SwapStatus.pending) SwapStatus status,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _SwapProposal;

  factory SwapProposal.fromJson(Map<String, dynamic> json) =>
      _$SwapProposalFromJson(json);
}

@freezed
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required String reporterId,
    required String listingId,
    required String reason,
    String? details,
    @Default('open') String status,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedId,
    @Default(false) bool read,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
