import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/home/domain/usecases/home_use_cases.dart';

class HomeViewmodel extends StateNotifier<GenericState> {
  final HomeUseCases homeUseCases;

  HomeViewmodel({required this.homeUseCases})
      : super(const GenericState.initial());

  Future<List<SectionCount>> loadSectionCounts() async {
    state = const GenericState.loading();
    final result = await homeUseCases.getAccessibleSectionCounts();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <SectionCount>[];
    }, (counts) {
      state = GenericState.success(counts);
      return counts;
    });
  }

  Future<List<RecentActivityEntry>> loadRecentActivities() async {
    state = const GenericState.loading();
    final result = await homeUseCases.getRecentActivities();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <RecentActivityEntry>[];
    }, (entries) {
      state = GenericState.success(entries);
      return entries;
    });
  }

  Future<List<ActiveStudentEntry>> loadActiveStudents() async {
    state = const GenericState.loading();
    final result = await homeUseCases.getActiveStudents();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <ActiveStudentEntry>[];
    }, (entries) {
      state = GenericState.success(entries);
      return entries;
    });
  }
}

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewmodel, GenericState>(
  (ref) => HomeViewmodel(homeUseCases: getIt()),
);
