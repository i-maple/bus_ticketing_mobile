// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_results_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketResultsState {

 bool get isLoading; String? get errorMessage; List<TicketOption> get tickets;
/// Create a copy of TicketResultsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketResultsStateCopyWith<TicketResultsState> get copyWith => _$TicketResultsStateCopyWithImpl<TicketResultsState>(this as TicketResultsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketResultsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.tickets, tickets));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,const DeepCollectionEquality().hash(tickets));

@override
String toString() {
  return 'TicketResultsState(isLoading: $isLoading, errorMessage: $errorMessage, tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class $TicketResultsStateCopyWith<$Res>  {
  factory $TicketResultsStateCopyWith(TicketResultsState value, $Res Function(TicketResultsState) _then) = _$TicketResultsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, List<TicketOption> tickets
});




}
/// @nodoc
class _$TicketResultsStateCopyWithImpl<$Res>
    implements $TicketResultsStateCopyWith<$Res> {
  _$TicketResultsStateCopyWithImpl(this._self, this._then);

  final TicketResultsState _self;
  final $Res Function(TicketResultsState) _then;

/// Create a copy of TicketResultsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? tickets = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<TicketOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketResultsState].
extension TicketResultsStatePatterns on TicketResultsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketResultsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketResultsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketResultsState value)  $default,){
final _that = this;
switch (_that) {
case _TicketResultsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketResultsState value)?  $default,){
final _that = this;
switch (_that) {
case _TicketResultsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  List<TicketOption> tickets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketResultsState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.tickets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  List<TicketOption> tickets)  $default,) {final _that = this;
switch (_that) {
case _TicketResultsState():
return $default(_that.isLoading,_that.errorMessage,_that.tickets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorMessage,  List<TicketOption> tickets)?  $default,) {final _that = this;
switch (_that) {
case _TicketResultsState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.tickets);case _:
  return null;

}
}

}

/// @nodoc


class _TicketResultsState implements TicketResultsState {
  const _TicketResultsState({this.isLoading = false, this.errorMessage, final  List<TicketOption> tickets = const <TicketOption>[]}): _tickets = tickets;
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
 final  List<TicketOption> _tickets;
@override@JsonKey() List<TicketOption> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}


/// Create a copy of TicketResultsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketResultsStateCopyWith<_TicketResultsState> get copyWith => __$TicketResultsStateCopyWithImpl<_TicketResultsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketResultsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._tickets, _tickets));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,const DeepCollectionEquality().hash(_tickets));

@override
String toString() {
  return 'TicketResultsState(isLoading: $isLoading, errorMessage: $errorMessage, tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class _$TicketResultsStateCopyWith<$Res> implements $TicketResultsStateCopyWith<$Res> {
  factory _$TicketResultsStateCopyWith(_TicketResultsState value, $Res Function(_TicketResultsState) _then) = __$TicketResultsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, List<TicketOption> tickets
});




}
/// @nodoc
class __$TicketResultsStateCopyWithImpl<$Res>
    implements _$TicketResultsStateCopyWith<$Res> {
  __$TicketResultsStateCopyWithImpl(this._self, this._then);

  final _TicketResultsState _self;
  final $Res Function(_TicketResultsState) _then;

/// Create a copy of TicketResultsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? tickets = null,}) {
  return _then(_TicketResultsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<TicketOption>,
  ));
}


}

// dart format on
