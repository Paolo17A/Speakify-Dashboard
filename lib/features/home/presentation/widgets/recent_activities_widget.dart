import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/home/presentation/viewmodels/home_viewmodel.dart';

class RecentActiviesWidget extends ConsumerStatefulWidget {
  const RecentActiviesWidget({super.key});

  @override
  ConsumerState<RecentActiviesWidget> createState() =>
      _RecentActiviesWidgetState();
}

class _RecentActiviesWidgetState extends ConsumerState<RecentActiviesWidget> {
  bool _isLoading = true;
  bool _didLoad = false;
  List<RecentActivityEntry> _recentActivities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _load();
  }

  Future<void> _load() async {
    try {
      final activities =
          await ref.read(homeViewModelProvider.notifier).loadRecentActivities();
      if (!mounted) return;
      setState(() {
        _recentActivities = activities;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: switchedLoadingContainer(
            _isLoading,
            loveWineContainer(
                Column(children: [
                  _recentActiviesHeader(),
                  _recentActivitiesContainer()
                ]),
                height: MediaQuery.of(context).size.height * 0.4)));
  }

  Widget _recentActiviesHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Row(
          children: [headerText(text: 'RECENT ACTIVITIES')],
        ),
      ),
    );
  }

  Widget _recentActivitiesContainer() {
    return _recentActivities.isEmpty
        ? const Center(child: Text('NO RECENT ACTIVIES AVAILABLE'))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.33,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recentActivities.length,
                  itemBuilder: (context, index) {
                    return _recentActivityEntry(index);
                  }),
            ),
          );
  }

  Widget _recentActivityEntry(int index) {
    final activity = _recentActivities[index];
    String formattedDateTime =
        DateFormat('dd MMM yyyy hh:mm:ss a').format(activity.dateAdded);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
          height: 70,
          decoration: BoxDecoration(
              color: AppColors.orchid.withAlpha(77),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDateTime, style: whiteBoldStyle(size: 15)),
                const SizedBox(height: 5),
                Text(activity.activityMessage, style: whiteBoldStyle(size: 12))
              ],
            ),
          )),
    );
  }
}
