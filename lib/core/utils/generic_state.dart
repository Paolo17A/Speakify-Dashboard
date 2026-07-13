import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_state.freezed.dart';

@freezed
class GenericState with _$GenericState {
  const factory GenericState.initial() = Initial;
  const factory GenericState.loading() = Loading;
  const factory GenericState.error(String message) = Error;
  const factory GenericState.success([Object? data]) = Success;
}
