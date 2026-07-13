import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/home/domain/usecases/home_use_cases.dart';

class HomeViewmodel extends StateNotifier<GenericState> {
  final HomeUseCases homeUseCases;

  HomeViewmodel({required this.homeUseCases})
      : super(const GenericState.initial());

  /// Concurrent home widgets each call a different loader; do not flip a shared
  /// Loading flag or they starve each other / never finish local spinners.
  Future<List<SectionCount>> loadSectionCounts() async {
    final result = await homeUseCases.getAccessibleSectionCounts();
    if (!mounted) {
      return result.fold((_) => <SectionCount>[], (counts) => counts);
    }
    return result.fold((failure) {
      if (mounted) state = GenericState.error(failure.message);
      return <SectionCount>[];
    }, (counts) {
      if (mounted) state = GenericState.success(counts);
      return counts;
    });
  }

  Future<List<RecentActivityEntry>> loadRecentActivities() async {
    final result = await homeUseCases.getRecentActivities();
    if (!mounted) {
      return result.fold((_) => <RecentActivityEntry>[], (entries) => entries);
    }
    return result.fold((failure) {
      if (mounted) state = GenericState.error(failure.message);
      return <RecentActivityEntry>[];
    }, (entries) {
      if (mounted) state = GenericState.success(entries);
      return entries;
    });
  }

  Future<List<ActiveStudentEntry>> loadActiveStudents() async {
    final result = await homeUseCases.getActiveStudents();
    if (!mounted) {
      return result.fold((_) => <ActiveStudentEntry>[], (entries) => entries);
    }
    return result.fold((failure) {
      if (mounted) state = GenericState.error(failure.message);
      return <ActiveStudentEntry>[];
    }, (entries) {
      if (mounted) state = GenericState.success(entries);
      return entries;
    });
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewmodel, GenericState>(
  (ref) => HomeViewmodel(homeUseCases: getIt()),
);
