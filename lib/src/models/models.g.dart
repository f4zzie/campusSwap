// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  university: json['university'] as String,
  photoUrl: json['photoUrl'] as String?,
  bio: json['bio'] as String?,
  createdAt: _dateFromJson(json['createdAt'] as Object),
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  role: json['role'] as String? ?? 'user',
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'university': instance.university,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'createdAt': _dateToJson(instance.createdAt),
      'fcmTokens': instance.fcmTokens,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'role': instance.role,
    };

_Listing _$ListingFromJson(Map<String, dynamic> json) => _Listing(
  id: json['id'] as String,
  sellerId: json['sellerId'] as String,
  sellerName: json['sellerName'] as String,
  sellerPhoto: json['sellerPhoto'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  category: $enumDecode(_$ListingCategoryEnumMap, json['category']),
  condition: $enumDecode(_$ListingConditionEnumMap, json['condition']),
  type: $enumDecode(_$ListingTypeEnumMap, json['type']),
  campus: json['campus'] as String,
  author: json['author'] as String?,
  courseCode: json['courseCode'] as String?,
  isbn: json['isbn'] as String?,
  favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
      ListingStatus.active,
  createdAt: _dateFromJson(json['createdAt'] as Object),
  updatedAt: _dateFromJson(json['updatedAt'] as Object),
  searchKeywords:
      (json['searchKeywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ListingToJson(_Listing instance) => <String, dynamic>{
  'id': instance.id,
  'sellerId': instance.sellerId,
  'sellerName': instance.sellerName,
  'sellerPhoto': instance.sellerPhoto,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'category': _$ListingCategoryEnumMap[instance.category]!,
  'condition': _$ListingConditionEnumMap[instance.condition]!,
  'type': _$ListingTypeEnumMap[instance.type]!,
  'campus': instance.campus,
  'author': instance.author,
  'courseCode': instance.courseCode,
  'isbn': instance.isbn,
  'favoriteCount': instance.favoriteCount,
  'imageUrls': instance.imageUrls,
  'status': _$ListingStatusEnumMap[instance.status]!,
  'createdAt': _dateToJson(instance.createdAt),
  'updatedAt': _dateToJson(instance.updatedAt),
  'searchKeywords': instance.searchKeywords,
  'viewCount': instance.viewCount,
};

const _$ListingCategoryEnumMap = {
  ListingCategory.textbooks: 'textbooks',
  ListingCategory.electronics: 'electronics',
  ListingCategory.dorm: 'dorm',
  ListingCategory.clothing: 'clothing',
  ListingCategory.supplies: 'supplies',
  ListingCategory.other: 'other',
};

const _$ListingConditionEnumMap = {
  ListingCondition.newItem: 'newItem',
  ListingCondition.likeNew: 'likeNew',
  ListingCondition.good: 'good',
  ListingCondition.fair: 'fair',
};

const _$ListingTypeEnumMap = {
  ListingType.sale: 'sale',
  ListingType.swap: 'swap',
  ListingType.free: 'free',
};

const _$ListingStatusEnumMap = {
  ListingStatus.active: 'active',
  ListingStatus.reserved: 'reserved',
  ListingStatus.sold: 'sold',
  ListingStatus.swapped: 'swapped',
};

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageAt: _dateFromJson(json['lastMessageAt'] as Object),
      unreadBy:
          (json['unreadBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      unreadCounts:
          (json['unreadCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      createdAt: _dateFromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'listingTitle': instance.listingTitle,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'participantIds': instance.participantIds,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': _dateToJson(instance.lastMessageAt),
      'unreadBy': instance.unreadBy,
      'unreadCounts': instance.unreadCounts,
      'createdAt': _dateToJson(instance.createdAt),
    };

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  text: json['text'] as String,
  imageUrl: json['imageUrl'] as String?,
  sentAt: _dateFromJson(json['sentAt'] as Object),
  readBy:
      (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'senderId': instance.senderId,
  'text': instance.text,
  'imageUrl': instance.imageUrl,
  'sentAt': _dateToJson(instance.sentAt),
  'readBy': instance.readBy,
};

_SwapProposal _$SwapProposalFromJson(Map<String, dynamic> json) =>
    _SwapProposal(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String,
      offererId: json['offererId'] as String,
      ownerId: json['ownerId'] as String,
      offeredListingId: json['offeredListingId'] as String?,
      offeredListingTitle: json['offeredListingTitle'] as String?,
      message: json['message'] as String?,
      status:
          $enumDecodeNullable(_$SwapStatusEnumMap, json['status']) ??
          SwapStatus.pending,
      createdAt: _dateFromJson(json['createdAt'] as Object),
      updatedAt: _dateFromJson(json['updatedAt'] as Object),
    );

Map<String, dynamic> _$SwapProposalToJson(_SwapProposal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'listingTitle': instance.listingTitle,
      'offererId': instance.offererId,
      'ownerId': instance.ownerId,
      'offeredListingId': instance.offeredListingId,
      'offeredListingTitle': instance.offeredListingTitle,
      'message': instance.message,
      'status': _$SwapStatusEnumMap[instance.status]!,
      'createdAt': _dateToJson(instance.createdAt),
      'updatedAt': _dateToJson(instance.updatedAt),
    };

const _$SwapStatusEnumMap = {
  SwapStatus.pending: 'pending',
  SwapStatus.accepted: 'accepted',
  SwapStatus.declined: 'declined',
  SwapStatus.cancelled: 'cancelled',
};

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: json['id'] as String,
  reporterId: json['reporterId'] as String,
  listingId: json['listingId'] as String,
  reason: json['reason'] as String,
  details: json['details'] as String?,
  status: json['status'] as String? ?? 'open',
  createdAt: _dateFromJson(json['createdAt'] as Object),
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'reporterId': instance.reporterId,
  'listingId': instance.listingId,
  'reason': instance.reason,
  'details': instance.details,
  'status': instance.status,
  'createdAt': _dateToJson(instance.createdAt),
};

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      relatedId: json['relatedId'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: _dateFromJson(json['createdAt'] as Object),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'relatedId': instance.relatedId,
      'read': instance.read,
      'createdAt': _dateToJson(instance.createdAt),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.message: 'message',
  NotificationType.swapRequest: 'swapRequest',
  NotificationType.swapAccepted: 'swapAccepted',
  NotificationType.swapDeclined: 'swapDeclined',
  NotificationType.listingSold: 'listingSold',
  NotificationType.listingSwapped: 'listingSwapped',
  NotificationType.system: 'system',
};
