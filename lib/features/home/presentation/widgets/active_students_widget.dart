import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/home/presentation/viewmodels/home_viewmodel.dart';

class ActiveStudentsWidget extends ConsumerStatefulWidget {
  const ActiveStudentsWidget({super.key});

  @override
  ConsumerState<ActiveStudentsWidget> createState() =>
      _ActiveStudentsWidgetState();
}

class _ActiveStudentsWidgetState extends ConsumerState<ActiveStudentsWidget> {
  bool _isLoading = true;
  bool _didLoad = false;
  List<ActiveStudentEntry> _activeStudents = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _load();
  }

  Future<void> _load() async {
    try {
      final students =
          await ref.read(homeViewModelProvider.notifier).loadActiveStudents();
      if (!mounted) return;
      setState(() {
        _activeStudents = students;
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _activeStudentHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: switchedLoadingContainer(
              _isLoading,
              _activeStudents.isEmpty
                  ? _noActiveStudentsWidget()
                  : _activeStudentsDisplayWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeStudentHeader() {
    return Row(
      children: [
        const CircleAvatar(backgroundColor: Colors.green, radius: 5),
        const SizedBox(width: 8),
        Expanded(
          child: AutoSizeText(
            'ACTIVE STUDENTS',
            textAlign: TextAlign.center,
            maxLines: 1,
            minFontSize: 10,
            style: wineBoldStyle(size: 25),
          ),
        ),
      ],
    );
  }

  Widget _noActiveStudentsWidget() {
    return Center(
      child: Text(
        'THERE ARE CURRENTLY NO ACTIVE STUDENTS',
        textAlign: TextAlign.center,
        style: wineBoldStyle(size: 25),
      ),
    );
  }

  Widget _activeStudentsDisplayWidget() {
    return ListView.builder(
      itemCount: _activeStudents.length,
      itemBuilder: (context, index) {
        final student = _activeStudents[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: roundedContainer(
            color: AppColors.mercury.withAlpha(77),
            borderColor: AppColors.orchid,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _profileImageWidget(student.profileImageURL),
                  const SizedBox(width: 10),
                  Expanded(child: _profileDataWidget(student)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileImageWidget(String imageURL) {
    if (imageURL.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        backgroundImage: NetworkImage(imageURL),
      );
    } else {
      return CircleAvatar(
        backgroundColor: AppColors.orchid.withAlpha(128),
        radius: 20,
        child: const Icon(
          Icons.person,
          color: AppColors.love,
        ),
      );
    }
  }

  Widget _profileDataWidget(ActiveStudentEntry student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AutoSizeText(
          '${student.firstName} ${student.lastName}',
          textAlign: TextAlign.center,
          maxLines: 2,
          minFontSize: 6,
          style: wineBoldStyle(size: 14),
        ),
        AutoSizeText(
          'Last Login:',
          textAlign: TextAlign.center,
          maxLines: 1,
          minFontSize: 6,
          style: wineBoldStyle(size: 10),
        ),
        AutoSizeText(
          DateFormat('dd MMM yyyy hh:mm:ss a').format(student.lastLoginTime),
          maxLines: 2,
          minFontSize: 6,
          textAlign: TextAlign.center,
          style: wineBoldStyle(size: 10),
        ),
      ],
    );
  }
}
