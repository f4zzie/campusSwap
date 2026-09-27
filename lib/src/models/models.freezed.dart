// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get email; String get displayName; String get university; String? get photoUrl; String? get bio;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt; List<String> get fcmTokens; double get rating; int get ratingCount; String get role;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.university, _this.university) || other.university == _this.university)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.fcmTokens, _this.fcmTokens)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.email,_this.displayName,_this.university,_this.photoUrl,_this.bio,_this.createdAt,const DeepCollectionEquality().hash(_this.fcmTokens),_this.rating,_this.ratingCount,_this.role);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, email: ${_this.email}, displayName: ${_this.displayName}, university: ${_this.university}, photoUrl: ${_this.photoUrl}, bio: ${_this.bio}, createdAt: ${_this.createdAt}, fcmTokens: ${_this.fcmTokens}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String university, String? photoUrl, String? bio,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt, List<String> fcmTokens, double rating, int ratingCount, String role
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? university = null,Object? photoUrl = freezed,Object? bio = freezed,Object? createdAt = null,Object? fcmTokens = null,Object? rating = null,Object? ratingCount = null,Object? role = null,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String university,  String? photoUrl,  String? bio, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt,  List<String> fcmTokens,  double rating,  int ratingCount,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.university,_that.photoUrl,_that.bio,_that.createdAt,_that.fcmTokens,_that.rating,_that.ratingCount,_that.role);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String university,  String? photoUrl,  String? bio, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt,  List<String> fcmTokens,  double rating,  int ratingCount,  String role)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.email,_that.displayName,_that.university,_that.photoUrl,_that.bio,_that.createdAt,_that.fcmTokens,_that.rating,_that.ratingCount,_that.role);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String university,  String? photoUrl,  String? bio, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt,  List<String> fcmTokens,  double rating,  int ratingCount,  String role)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.university,_that.photoUrl,_that.bio,_that.createdAt,_that.fcmTokens,_that.rating,_that.ratingCount,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.email, required this.displayName, required this.university, this.photoUrl, this.bio, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt,  List<String> fcmTokens = const <String>[], this.rating = 0, this.ratingCount = 0, this.role = 'user'}): _fcmTokens = fcmTokens;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  String university;
@override final  String? photoUrl;
@override final  String? bio;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;
 final  List<String> _fcmTokens;
@override@JsonKey() List<String> get fcmTokens {
  if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fcmTokens);
}

@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  String role;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.university, university) || other.university == university)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.fcmTokens, _fcmTokens)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,displayName,university,photoUrl,bio,createdAt,const DeepCollectionEquality().hash(_fcmTokens),rating,ratingCount,role);
}

@override
String toString() {
    return 'UserProfile(id: $id, email: $email, displayName: $displayName, university: $university, photoUrl: $photoUrl, bio: $bio, createdAt: $createdAt, fcmTokens: $fcmTokens, rating: $rating, ratingCount: $ratingCount, role: $role)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String university, String? photoUrl, String? bio,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt, List<String> fcmTokens, double rating, int ratingCount, String role
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? university = null,Object? photoUrl = freezed,Object? bio = freezed,Object? createdAt = null,Object? fcmTokens = null,Object? rating = null,Object? ratingCount = null,Object? role = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Listing {

 String get id; String get sellerId; String get sellerName; String? get sellerPhoto; String get title; String get description; double get price; ListingCategory get category; ListingCondition get condition; ListingType get type; String get campus; String? get author; String? get courseCode; String? get isbn; int get favoriteCount; List<String> get imageUrls; ListingStatus get status;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get updatedAt; List<String> get searchKeywords; int get viewCount;
/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingCopyWith<Listing> get copyWith => _$ListingCopyWithImpl<Listing>(this as Listing, _$identity);

  /// Serializes this Listing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Listing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Listing&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sellerId, _this.sellerId) || other.sellerId == _this.sellerId)&&(identical(other.sellerName, _this.sellerName) || other.sellerName == _this.sellerName)&&(identical(other.sellerPhoto, _this.sellerPhoto) || other.sellerPhoto == _this.sellerPhoto)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.campus, _this.campus) || other.campus == _this.campus)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.courseCode, _this.courseCode) || other.courseCode == _this.courseCode)&&(identical(other.isbn, _this.isbn) || other.isbn == _this.isbn)&&(identical(other.favoriteCount, _this.favoriteCount) || other.favoriteCount == _this.favoriteCount)&&const DeepCollectionEquality().equals(other.imageUrls, _this.imageUrls)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _this.searchKeywords)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Listing;
  return Object.hashAll([runtimeType,_this.id,_this.sellerId,_this.sellerName,_this.sellerPhoto,_this.title,_this.description,_this.price,_this.category,_this.condition,_this.type,_this.campus,_this.author,_this.courseCode,_this.isbn,_this.favoriteCount,const DeepCollectionEquality().hash(_this.imageUrls),_this.status,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.searchKeywords),_this.viewCount]);
}

@override
String toString() {
  final _this = this as Listing;
  return 'Listing(id: ${_this.id}, sellerId: ${_this.sellerId}, sellerName: ${_this.sellerName}, sellerPhoto: ${_this.sellerPhoto}, title: ${_this.title}, description: ${_this.description}, price: ${_this.price}, category: ${_this.category}, condition: ${_this.condition}, type: ${_this.type}, campus: ${_this.campus}, author: ${_this.author}, courseCode: ${_this.courseCode}, isbn: ${_this.isbn}, favoriteCount: ${_this.favoriteCount}, imageUrls: ${_this.imageUrls}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, searchKeywords: ${_this.searchKeywords}, viewCount: ${_this.viewCount})';
}


}

/// @nodoc
abstract mixin class $ListingCopyWith<$Res>  {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) _then) = _$ListingCopyWithImpl;
@useResult
$Res call({
 String id, String sellerId, String sellerName, String? sellerPhoto, String title, String description, double price, ListingCategory category, ListingCondition condition, ListingType type, String campus, String? author, String? courseCode, String? isbn, int favoriteCount, List<String> imageUrls, ListingStatus status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime updatedAt, List<String> searchKeywords, int viewCount
});




}
/// @nodoc
class _$ListingCopyWithImpl<$Res>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._self, this._then);

  final Listing _self;
  final $Res Function(Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sellerId = null,Object? sellerName = null,Object? sellerPhoto = freezed,Object? title = null,Object? description = null,Object? price = null,Object? category = null,Object? condition = null,Object? type = null,Object? campus = null,Object? author = freezed,Object? courseCode = freezed,Object? isbn = freezed,Object? favoriteCount = null,Object? imageUrls = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? searchKeywords = null,Object? viewCount = null,}) {
  return _then(Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,sellerPhoto: freezed == sellerPhoto ? _self.sellerPhoto : sellerPhoto // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ListingCategory,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as ListingCondition,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ListingType,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,courseCode: freezed == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Listing].
extension ListingPatterns on Listing {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Listing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Listing value)  $default,){
final _that = this;
switch (_that) {
case _Listing():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Listing value)?  $default,){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sellerId,  String sellerName,  String? sellerPhoto,  String title,  String description,  double price,  ListingCategory category,  ListingCondition condition,  ListingType type,  String campus,  String? author,  String? courseCode,  String? isbn,  int favoriteCount,  List<String> imageUrls,  ListingStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt,  List<String> searchKeywords,  int viewCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.sellerId,_that.sellerName,_that.sellerPhoto,_that.title,_that.description,_that.price,_that.category,_that.condition,_that.type,_that.campus,_that.author,_that.courseCode,_that.isbn,_that.favoriteCount,_that.imageUrls,_that.status,_that.createdAt,_that.updatedAt,_that.searchKeywords,_that.viewCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sellerId,  String sellerName,  String? sellerPhoto,  String title,  String description,  double price,  ListingCategory category,  ListingCondition condition,  ListingType type,  String campus,  String? author,  String? courseCode,  String? isbn,  int favoriteCount,  List<String> imageUrls,  ListingStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt,  List<String> searchKeywords,  int viewCount)  $default,) {final _that = this;
switch (_that) {
case _Listing():
return $default(_that.id,_that.sellerId,_that.sellerName,_that.sellerPhoto,_that.title,_that.description,_that.price,_that.category,_that.condition,_that.type,_that.campus,_that.author,_that.courseCode,_that.isbn,_that.favoriteCount,_that.imageUrls,_that.status,_that.createdAt,_that.updatedAt,_that.searchKeywords,_that.viewCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sellerId,  String sellerName,  String? sellerPhoto,  String title,  String description,  double price,  ListingCategory category,  ListingCondition condition,  ListingType type,  String campus,  String? author,  String? courseCode,  String? isbn,  int favoriteCount,  List<String> imageUrls,  ListingStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt,  List<String> searchKeywords,  int viewCount)?  $default,) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.sellerId,_that.sellerName,_that.sellerPhoto,_that.title,_that.description,_that.price,_that.category,_that.condition,_that.type,_that.campus,_that.author,_that.courseCode,_that.isbn,_that.favoriteCount,_that.imageUrls,_that.status,_that.createdAt,_that.updatedAt,_that.searchKeywords,_that.viewCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Listing implements Listing {
  const _Listing({required this.id, required this.sellerId, required this.sellerName, this.sellerPhoto, required this.title, required this.description, required this.price, required this.category, required this.condition, required this.type, required this.campus, this.author, this.courseCode, this.isbn, this.favoriteCount = 0,  List<String> imageUrls = const <String>[], this.status = ListingStatus.active, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.updatedAt,  List<String> searchKeywords = const <String>[], this.viewCount = 0}): _imageUrls = imageUrls,_searchKeywords = searchKeywords;
  factory _Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);

@override final  String id;
@override final  String sellerId;
@override final  String sellerName;
@override final  String? sellerPhoto;
@override final  String title;
@override final  String description;
@override final  double price;
@override final  ListingCategory category;
@override final  ListingCondition condition;
@override final  ListingType type;
@override final  String campus;
@override final  String? author;
@override final  String? courseCode;
@override final  String? isbn;
@override@JsonKey() final  int favoriteCount;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  ListingStatus status;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime updatedAt;
 final  List<String> _searchKeywords;
@override@JsonKey() List<String> get searchKeywords {
  if (_searchKeywords is EqualUnmodifiableListView) return _searchKeywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchKeywords);
}

@override@JsonKey() final  int viewCount;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingCopyWith<_Listing> get copyWith => __$ListingCopyWithImpl<_Listing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.sellerPhoto, sellerPhoto) || other.sellerPhoto == sellerPhoto)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.category, category) || other.category == category)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.type, type) || other.type == type)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.author, author) || other.author == author)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&const DeepCollectionEquality().equals(other.imageUrls, _imageUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _searchKeywords)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,sellerId,sellerName,sellerPhoto,title,description,price,category,condition,type,campus,author,courseCode,isbn,favoriteCount,const DeepCollectionEquality().hash(_imageUrls),status,createdAt,updatedAt,const DeepCollectionEquality().hash(_searchKeywords),viewCount]);
}

@override
String toString() {
    return 'Listing(id: $id, sellerId: $sellerId, sellerName: $sellerName, sellerPhoto: $sellerPhoto, title: $title, description: $description, price: $price, category: $category, condition: $condition, type: $type, campus: $campus, author: $author, courseCode: $courseCode, isbn: $isbn, favoriteCount: $favoriteCount, imageUrls: $imageUrls, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, searchKeywords: $searchKeywords, viewCount: $viewCount)';
}


}

/// @nodoc
abstract mixin class _$ListingCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$ListingCopyWith(_Listing value, $Res Function(_Listing) _then) = __$ListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String sellerId, String sellerName, String? sellerPhoto, String title, String description, double price, ListingCategory category, ListingCondition condition, ListingType type, String campus, String? author, String? courseCode, String? isbn, int favoriteCount, List<String> imageUrls, ListingStatus status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime updatedAt, List<String> searchKeywords, int viewCount
});




}
/// @nodoc
class __$ListingCopyWithImpl<$Res>
    implements _$ListingCopyWith<$Res> {
  __$ListingCopyWithImpl(this._self, this._then);

  final _Listing _self;
  final $Res Function(_Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sellerId = null,Object? sellerName = null,Object? sellerPhoto = freezed,Object? title = null,Object? description = null,Object? price = null,Object? category = null,Object? condition = null,Object? type = null,Object? campus = null,Object? author = freezed,Object? courseCode = freezed,Object? isbn = freezed,Object? favoriteCount = null,Object? imageUrls = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? searchKeywords = null,Object? viewCount = null,}) {
  return _then(_Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,sellerPhoto: freezed == sellerPhoto ? _self.sellerPhoto : sellerPhoto // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ListingCategory,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as ListingCondition,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ListingType,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,courseCode: freezed == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,searchKeywords: null == searchKeywords ? _self._searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Conversation {

 String get id; String get listingId; String get listingTitle; String get buyerId; String get buyerName; String get sellerId; String get sellerName; List<String> get participantIds; String get lastMessage;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get lastMessageAt; List<String> get unreadBy; Map<String, int> get unreadCounts;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Conversation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.listingId, _this.listingId) || other.listingId == _this.listingId)&&(identical(other.listingTitle, _this.listingTitle) || other.listingTitle == _this.listingTitle)&&(identical(other.buyerId, _this.buyerId) || other.buyerId == _this.buyerId)&&(identical(other.buyerName, _this.buyerName) || other.buyerName == _this.buyerName)&&(identical(other.sellerId, _this.sellerId) || other.sellerId == _this.sellerId)&&(identical(other.sellerName, _this.sellerName) || other.sellerName == _this.sellerName)&&const DeepCollectionEquality().equals(other.participantIds, _this.participantIds)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.lastMessageAt, _this.lastMessageAt) || other.lastMessageAt == _this.lastMessageAt)&&const DeepCollectionEquality().equals(other.unreadBy, _this.unreadBy)&&const DeepCollectionEquality().equals(other.unreadCounts, _this.unreadCounts)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Conversation;
  return Object.hash(runtimeType,_this.id,_this.listingId,_this.listingTitle,_this.buyerId,_this.buyerName,_this.sellerId,_this.sellerName,const DeepCollectionEquality().hash(_this.participantIds),_this.lastMessage,_this.lastMessageAt,const DeepCollectionEquality().hash(_this.unreadBy),const DeepCollectionEquality().hash(_this.unreadCounts),_this.createdAt);
}

@override
String toString() {
  final _this = this as Conversation;
  return 'Conversation(id: ${_this.id}, listingId: ${_this.listingId}, listingTitle: ${_this.listingTitle}, buyerId: ${_this.buyerId}, buyerName: ${_this.buyerName}, sellerId: ${_this.sellerId}, sellerName: ${_this.sellerName}, participantIds: ${_this.participantIds}, lastMessage: ${_this.lastMessage}, lastMessageAt: ${_this.lastMessageAt}, unreadBy: ${_this.unreadBy}, unreadCounts: ${_this.unreadCounts}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, String listingId, String listingTitle, String buyerId, String buyerName, String sellerId, String sellerName, List<String> participantIds, String lastMessage,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime lastMessageAt, List<String> unreadBy, Map<String, int> unreadCounts,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listingId = null,Object? listingTitle = null,Object? buyerId = null,Object? buyerName = null,Object? sellerId = null,Object? sellerName = null,Object? participantIds = null,Object? lastMessage = null,Object? lastMessageAt = null,Object? unreadBy = null,Object? unreadCounts = null,Object? createdAt = null,}) {
  return _then(Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,listingTitle: null == listingTitle ? _self.listingTitle : listingTitle // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,unreadBy: null == unreadBy ? _self.unreadBy : unreadBy // ignore: cast_nullable_to_non_nullable
as List<String>,unreadCounts: null == unreadCounts ? _self.unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listingId,  String listingTitle,  String buyerId,  String buyerName,  String sellerId,  String sellerName,  List<String> participantIds,  String lastMessage, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime lastMessageAt,  List<String> unreadBy,  Map<String, int> unreadCounts, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.listingId,_that.listingTitle,_that.buyerId,_that.buyerName,_that.sellerId,_that.sellerName,_that.participantIds,_that.lastMessage,_that.lastMessageAt,_that.unreadBy,_that.unreadCounts,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listingId,  String listingTitle,  String buyerId,  String buyerName,  String sellerId,  String sellerName,  List<String> participantIds,  String lastMessage, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime lastMessageAt,  List<String> unreadBy,  Map<String, int> unreadCounts, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.listingId,_that.listingTitle,_that.buyerId,_that.buyerName,_that.sellerId,_that.sellerName,_that.participantIds,_that.lastMessage,_that.lastMessageAt,_that.unreadBy,_that.unreadCounts,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listingId,  String listingTitle,  String buyerId,  String buyerName,  String sellerId,  String sellerName,  List<String> participantIds,  String lastMessage, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime lastMessageAt,  List<String> unreadBy,  Map<String, int> unreadCounts, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.listingId,_that.listingTitle,_that.buyerId,_that.buyerName,_that.sellerId,_that.sellerName,_that.participantIds,_that.lastMessage,_that.lastMessageAt,_that.unreadBy,_that.unreadCounts,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation implements Conversation {
  const _Conversation({required this.id, required this.listingId, required this.listingTitle, required this.buyerId, required this.buyerName, required this.sellerId, required this.sellerName, required  List<String> participantIds, required this.lastMessage, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.lastMessageAt,  List<String> unreadBy = const <String>[],  Map<String, int> unreadCounts = const <String, int>{}, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt}): _participantIds = participantIds,_unreadBy = unreadBy,_unreadCounts = unreadCounts;
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override final  String id;
@override final  String listingId;
@override final  String listingTitle;
@override final  String buyerId;
@override final  String buyerName;
@override final  String sellerId;
@override final  String sellerName;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override final  String lastMessage;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime lastMessageAt;
 final  List<String> _unreadBy;
@override@JsonKey() List<String> get unreadBy {
  if (_unreadBy is EqualUnmodifiableListView) return _unreadBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unreadBy);
}

 final  Map<String, int> _unreadCounts;
@override@JsonKey() Map<String, int> get unreadCounts {
  if (_unreadCounts is EqualUnmodifiableMapView) return _unreadCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unreadCounts);
}

@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.listingId, listingId) || other.listingId == listingId)&&(identical(other.listingTitle, listingTitle) || other.listingTitle == listingTitle)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&const DeepCollectionEquality().equals(other.participantIds, _participantIds)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&const DeepCollectionEquality().equals(other.unreadBy, _unreadBy)&&const DeepCollectionEquality().equals(other.unreadCounts, _unreadCounts)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,listingId,listingTitle,buyerId,buyerName,sellerId,sellerName,const DeepCollectionEquality().hash(_participantIds),lastMessage,lastMessageAt,const DeepCollectionEquality().hash(_unreadBy),const DeepCollectionEquality().hash(_unreadCounts),createdAt);
}

@override
String toString() {
    return 'Conversation(id: $id, listingId: $listingId, listingTitle: $listingTitle, buyerId: $buyerId, buyerName: $buyerName, sellerId: $sellerId, sellerName: $sellerName, participantIds: $participantIds, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadBy: $unreadBy, unreadCounts: $unreadCounts, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String listingId, String listingTitle, String buyerId, String buyerName, String sellerId, String sellerName, List<String> participantIds, String lastMessage,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime lastMessageAt, List<String> unreadBy, Map<String, int> unreadCounts,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listingId = null,Object? listingTitle = null,Object? buyerId = null,Object? buyerName = null,Object? sellerId = null,Object? sellerName = null,Object? participantIds = null,Object? lastMessage = null,Object? lastMessageAt = null,Object? unreadBy = null,Object? unreadCounts = null,Object? createdAt = null,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,listingTitle: null == listingTitle ? _self.listingTitle : listingTitle // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,unreadBy: null == unreadBy ? _self._unreadBy : unreadBy // ignore: cast_nullable_to_non_nullable
as List<String>,unreadCounts: null == unreadCounts ? _self._unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Message {

 String get id; String get senderId; String get text; String? get imageUrl;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get sentAt; List<String> get readBy;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&const DeepCollectionEquality().equals(other.readBy, _this.readBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.senderId,_this.text,_this.imageUrl,_this.sentAt,const DeepCollectionEquality().hash(_this.readBy));
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, senderId: ${_this.senderId}, text: ${_this.text}, imageUrl: ${_this.imageUrl}, sentAt: ${_this.sentAt}, readBy: ${_this.readBy})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id, String senderId, String text, String? imageUrl,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime sentAt, List<String> readBy
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderId = null,Object? text = null,Object? imageUrl = freezed,Object? sentAt = null,Object? readBy = null,}) {
  return _then(Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,readBy: null == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderId,  String text,  String? imageUrl, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime sentAt,  List<String> readBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.senderId,_that.text,_that.imageUrl,_that.sentAt,_that.readBy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderId,  String text,  String? imageUrl, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime sentAt,  List<String> readBy)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.senderId,_that.text,_that.imageUrl,_that.sentAt,_that.readBy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderId,  String text,  String? imageUrl, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime sentAt,  List<String> readBy)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.senderId,_that.text,_that.imageUrl,_that.sentAt,_that.readBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({required this.id, required this.senderId, required this.text, this.imageUrl, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.sentAt,  List<String> readBy = const <String>[]}): _readBy = readBy;
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String id;
@override final  String senderId;
@override final  String text;
@override final  String? imageUrl;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime sentAt;
 final  List<String> _readBy;
@override@JsonKey() List<String> get readBy {
  if (_readBy is EqualUnmodifiableListView) return _readBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readBy);
}


/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&const DeepCollectionEquality().equals(other.readBy, _readBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,senderId,text,imageUrl,sentAt,const DeepCollectionEquality().hash(_readBy));
}

@override
String toString() {
    return 'Message(id: $id, senderId: $senderId, text: $text, imageUrl: $imageUrl, sentAt: $sentAt, readBy: $readBy)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderId, String text, String? imageUrl,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime sentAt, List<String> readBy
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderId = null,Object? text = null,Object? imageUrl = freezed,Object? sentAt = null,Object? readBy = null,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,readBy: null == readBy ? _self._readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SwapProposal {

 String get id; String get listingId; String get listingTitle; String get offererId; String get ownerId; String? get offeredListingId; String? get offeredListingTitle; String? get message; SwapStatus get status;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get updatedAt;
/// Create a copy of SwapProposal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwapProposalCopyWith<SwapProposal> get copyWith => _$SwapProposalCopyWithImpl<SwapProposal>(this as SwapProposal, _$identity);

  /// Serializes this SwapProposal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SwapProposal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapProposal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.listingId, _this.listingId) || other.listingId == _this.listingId)&&(identical(other.listingTitle, _this.listingTitle) || other.listingTitle == _this.listingTitle)&&(identical(other.offererId, _this.offererId) || other.offererId == _this.offererId)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.offeredListingId, _this.offeredListingId) || other.offeredListingId == _this.offeredListingId)&&(identical(other.offeredListingTitle, _this.offeredListingTitle) || other.offeredListingTitle == _this.offeredListingTitle)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SwapProposal;
  return Object.hash(runtimeType,_this.id,_this.listingId,_this.listingTitle,_this.offererId,_this.ownerId,_this.offeredListingId,_this.offeredListingTitle,_this.message,_this.status,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SwapProposal;
  return 'SwapProposal(id: ${_this.id}, listingId: ${_this.listingId}, listingTitle: ${_this.listingTitle}, offererId: ${_this.offererId}, ownerId: ${_this.ownerId}, offeredListingId: ${_this.offeredListingId}, offeredListingTitle: ${_this.offeredListingTitle}, message: ${_this.message}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SwapProposalCopyWith<$Res>  {
  factory $SwapProposalCopyWith(SwapProposal value, $Res Function(SwapProposal) _then) = _$SwapProposalCopyWithImpl;
@useResult
$Res call({
 String id, String listingId, String listingTitle, String offererId, String ownerId, String? offeredListingId, String? offeredListingTitle, String? message, SwapStatus status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime updatedAt
});




}
/// @nodoc
class _$SwapProposalCopyWithImpl<$Res>
    implements $SwapProposalCopyWith<$Res> {
  _$SwapProposalCopyWithImpl(this._self, this._then);

  final SwapProposal _self;
  final $Res Function(SwapProposal) _then;

/// Create a copy of SwapProposal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listingId = null,Object? listingTitle = null,Object? offererId = null,Object? ownerId = null,Object? offeredListingId = freezed,Object? offeredListingTitle = freezed,Object? message = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(SwapProposal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,listingTitle: null == listingTitle ? _self.listingTitle : listingTitle // ignore: cast_nullable_to_non_nullable
as String,offererId: null == offererId ? _self.offererId : offererId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,offeredListingId: freezed == offeredListingId ? _self.offeredListingId : offeredListingId // ignore: cast_nullable_to_non_nullable
as String?,offeredListingTitle: freezed == offeredListingTitle ? _self.offeredListingTitle : offeredListingTitle // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SwapStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SwapProposal].
extension SwapProposalPatterns on SwapProposal {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwapProposal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwapProposal() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwapProposal value)  $default,){
final _that = this;
switch (_that) {
case _SwapProposal():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwapProposal value)?  $default,){
final _that = this;
switch (_that) {
case _SwapProposal() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listingId,  String listingTitle,  String offererId,  String ownerId,  String? offeredListingId,  String? offeredListingTitle,  String? message,  SwapStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwapProposal() when $default != null:
return $default(_that.id,_that.listingId,_that.listingTitle,_that.offererId,_that.ownerId,_that.offeredListingId,_that.offeredListingTitle,_that.message,_that.status,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listingId,  String listingTitle,  String offererId,  String ownerId,  String? offeredListingId,  String? offeredListingTitle,  String? message,  SwapStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SwapProposal():
return $default(_that.id,_that.listingId,_that.listingTitle,_that.offererId,_that.ownerId,_that.offeredListingId,_that.offeredListingTitle,_that.message,_that.status,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listingId,  String listingTitle,  String offererId,  String ownerId,  String? offeredListingId,  String? offeredListingTitle,  String? message,  SwapStatus status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SwapProposal() when $default != null:
return $default(_that.id,_that.listingId,_that.listingTitle,_that.offererId,_that.ownerId,_that.offeredListingId,_that.offeredListingTitle,_that.message,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwapProposal implements SwapProposal {
  const _SwapProposal({required this.id, required this.listingId, required this.listingTitle, required this.offererId, required this.ownerId, this.offeredListingId, this.offeredListingTitle, this.message, this.status = SwapStatus.pending, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.updatedAt});
  factory _SwapProposal.fromJson(Map<String, dynamic> json) => _$SwapProposalFromJson(json);

@override final  String id;
@override final  String listingId;
@override final  String listingTitle;
@override final  String offererId;
@override final  String ownerId;
@override final  String? offeredListingId;
@override final  String? offeredListingTitle;
@override final  String? message;
@override@JsonKey() final  SwapStatus status;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime updatedAt;

/// Create a copy of SwapProposal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwapProposalCopyWith<_SwapProposal> get copyWith => __$SwapProposalCopyWithImpl<_SwapProposal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwapProposalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwapProposal&&(identical(other.id, id) || other.id == id)&&(identical(other.listingId, listingId) || other.listingId == listingId)&&(identical(other.listingTitle, listingTitle) || other.listingTitle == listingTitle)&&(identical(other.offererId, offererId) || other.offererId == offererId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.offeredListingId, offeredListingId) || other.offeredListingId == offeredListingId)&&(identical(other.offeredListingTitle, offeredListingTitle) || other.offeredListingTitle == offeredListingTitle)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,listingId,listingTitle,offererId,ownerId,offeredListingId,offeredListingTitle,message,status,createdAt,updatedAt);
}

@override
String toString() {
    return 'SwapProposal(id: $id, listingId: $listingId, listingTitle: $listingTitle, offererId: $offererId, ownerId: $ownerId, offeredListingId: $offeredListingId, offeredListingTitle: $offeredListingTitle, message: $message, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SwapProposalCopyWith<$Res> implements $SwapProposalCopyWith<$Res> {
  factory _$SwapProposalCopyWith(_SwapProposal value, $Res Function(_SwapProposal) _then) = __$SwapProposalCopyWithImpl;
@override @useResult
$Res call({
 String id, String listingId, String listingTitle, String offererId, String ownerId, String? offeredListingId, String? offeredListingTitle, String? message, SwapStatus status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime updatedAt
});




}
/// @nodoc
class __$SwapProposalCopyWithImpl<$Res>
    implements _$SwapProposalCopyWith<$Res> {
  __$SwapProposalCopyWithImpl(this._self, this._then);

  final _SwapProposal _self;
  final $Res Function(_SwapProposal) _then;

/// Create a copy of SwapProposal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listingId = null,Object? listingTitle = null,Object? offererId = null,Object? ownerId = null,Object? offeredListingId = freezed,Object? offeredListingTitle = freezed,Object? message = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SwapProposal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,listingTitle: null == listingTitle ? _self.listingTitle : listingTitle // ignore: cast_nullable_to_non_nullable
as String,offererId: null == offererId ? _self.offererId : offererId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,offeredListingId: freezed == offeredListingId ? _self.offeredListingId : offeredListingId // ignore: cast_nullable_to_non_nullable
as String?,offeredListingTitle: freezed == offeredListingTitle ? _self.offeredListingTitle : offeredListingTitle // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SwapStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Report {

 String get id; String get reporterId; String get listingId; String get reason; String? get details; String get status;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt;
/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCopyWith<Report> get copyWith => _$ReportCopyWithImpl<Report>(this as Report, _$identity);

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Report;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Report&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.reporterId, _this.reporterId) || other.reporterId == _this.reporterId)&&(identical(other.listingId, _this.listingId) || other.listingId == _this.listingId)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Report;
  return Object.hash(runtimeType,_this.id,_this.reporterId,_this.listingId,_this.reason,_this.details,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as Report;
  return 'Report(id: ${_this.id}, reporterId: ${_this.reporterId}, listingId: ${_this.listingId}, reason: ${_this.reason}, details: ${_this.details}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ReportCopyWith<$Res>  {
  factory $ReportCopyWith(Report value, $Res Function(Report) _then) = _$ReportCopyWithImpl;
@useResult
$Res call({
 String id, String reporterId, String listingId, String reason, String? details, String status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class _$ReportCopyWithImpl<$Res>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._self, this._then);

  final Report _self;
  final $Res Function(Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reporterId = null,Object? listingId = null,Object? reason = null,Object? details = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(Report(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Report].
extension ReportPatterns on Report {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Report value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Report value)  $default,){
final _that = this;
switch (_that) {
case _Report():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Report value)?  $default,){
final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reporterId,  String listingId,  String reason,  String? details,  String status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.id,_that.reporterId,_that.listingId,_that.reason,_that.details,_that.status,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reporterId,  String listingId,  String reason,  String? details,  String status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Report():
return $default(_that.id,_that.reporterId,_that.listingId,_that.reason,_that.details,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reporterId,  String listingId,  String reason,  String? details,  String status, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.id,_that.reporterId,_that.listingId,_that.reason,_that.details,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Report implements Report {
  const _Report({required this.id, required this.reporterId, required this.listingId, required this.reason, this.details, this.status = 'open', @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt});
  factory _Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

@override final  String id;
@override final  String reporterId;
@override final  String listingId;
@override final  String reason;
@override final  String? details;
@override@JsonKey() final  String status;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCopyWith<_Report> get copyWith => __$ReportCopyWithImpl<_Report>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Report&&(identical(other.id, id) || other.id == id)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.listingId, listingId) || other.listingId == listingId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,reporterId,listingId,reason,details,status,createdAt);
}

@override
String toString() {
    return 'Report(id: $id, reporterId: $reporterId, listingId: $listingId, reason: $reason, details: $details, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$ReportCopyWith(_Report value, $Res Function(_Report) _then) = __$ReportCopyWithImpl;
@override @useResult
$Res call({
 String id, String reporterId, String listingId, String reason, String? details, String status,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class __$ReportCopyWithImpl<$Res>
    implements _$ReportCopyWith<$Res> {
  __$ReportCopyWithImpl(this._self, this._then);

  final _Report _self;
  final $Res Function(_Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reporterId = null,Object? listingId = null,Object? reason = null,Object? details = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_Report(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reporterId: null == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AppNotification {

 String get id; String get title; String get body; NotificationType get type; String? get relatedId; bool get read;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get createdAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.relatedId, _this.relatedId) || other.relatedId == _this.relatedId)&&(identical(other.read, _this.read) || other.read == _this.read)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppNotification;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,_this.type,_this.relatedId,_this.read,_this.createdAt);
}

@override
String toString() {
  final _this = this as AppNotification;
  return 'AppNotification(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, type: ${_this.type}, relatedId: ${_this.relatedId}, read: ${_this.read}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String title, String body, NotificationType type, String? relatedId, bool read,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? type = null,Object? relatedId = freezed,Object? read = null,Object? createdAt = null,}) {
  return _then(AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,relatedId: freezed == relatedId ? _self.relatedId : relatedId // ignore: cast_nullable_to_non_nullable
as String?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String body,  NotificationType type,  String? relatedId,  bool read, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.type,_that.relatedId,_that.read,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String body,  NotificationType type,  String? relatedId,  bool read, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.title,_that.body,_that.type,_that.relatedId,_that.read,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String body,  NotificationType type,  String? relatedId,  bool read, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.type,_that.relatedId,_that.read,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification implements AppNotification {
  const _AppNotification({required this.id, required this.title, required this.body, required this.type, this.relatedId, this.read = false, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.createdAt});
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override final  String title;
@override final  String body;
@override final  NotificationType type;
@override final  String? relatedId;
@override@JsonKey() final  bool read;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime createdAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.type, type) || other.type == type)&&(identical(other.relatedId, relatedId) || other.relatedId == relatedId)&&(identical(other.read, read) || other.read == read)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,type,relatedId,read,createdAt);
}

@override
String toString() {
    return 'AppNotification(id: $id, title: $title, body: $body, type: $type, relatedId: $relatedId, read: $read, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String body, NotificationType type, String? relatedId, bool read,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? type = null,Object? relatedId = freezed,Object? read = null,Object? createdAt = null,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,relatedId: freezed == relatedId ? _self.relatedId : relatedId // ignore: cast_nullable_to_non_nullable
as String?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
