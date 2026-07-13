import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/home/presentation/viewmodels/home_viewmodel.dart';

class SectionStudentsCountWidget extends ConsumerStatefulWidget {
  const SectionStudentsCountWidget({super.key});

  @override
  ConsumerState<SectionStudentsCountWidget> createState() =>
      _SectionStudentsCountWidgetState();
}

class _SectionStudentsCountWidgetState
    extends ConsumerState<SectionStudentsCountWidget> {
  bool _isLoading = true;
  bool _didLoad = false;
  List<SectionCount> _sectionCounts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _load();
  }

  Future<void> _load() async {
    try {
      final counts =
          await ref.read(homeViewModelProvider.notifier).loadSectionCounts();
      if (!mounted) return;
      setState(() {
        _sectionCounts = counts;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switchedLoadingContainer(
        _isLoading,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: loveWineContainer(
              all8Pix(_sectionCounts.isNotEmpty
                  ? SfCartesianChart(
                      isTransposed: true,
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          interval: 5,
                          title: AxisTitle(
                              text: 'Enrolled Students',
                              textStyle: wineBoldStyle())),
                      title: ChartTitle(
                          text: 'Available Sections',
                          textStyle: wineBoldStyle(size: 25)),
                      series: <ColumnSeries<SectionCount, String>>[
                          ColumnSeries<SectionCount, String>(
                              color: AppColors.orchid,
                              dataSource: _sectionCounts,
                              xValueMapper: (SectionCount section, _) =>
                                  section.section,
                              yValueMapper: (SectionCount section, _) =>
                                  section.students)
                        ])
                  : Center(
                      child: Text(
                        'You have no assigned sections',
                        style: blackBoldStyle(size: 30),
                      ),
                    )),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25),
        ));
  }
}
