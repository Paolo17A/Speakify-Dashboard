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
  List<ActiveStudentEntry> _activeStudents = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final students =
        await ref.read(homeViewModelProvider.notifier).loadActiveStudents();
    if (!mounted) return;
    setState(() {
      _activeStudents = students;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _activeStudentHeader(),
            switchedLoadingContainer(
                _isLoading,
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: _activeStudents.isEmpty
                        ? _noActiveStudentsWidget()
                        : _activeStudentsDisplayWidget()))
          ],
        ));
  }

  Widget _activeStudentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const CircleAvatar(backgroundColor: Colors.green, radius: 5),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            child: AutoSizeText('ACTIVE STUDENTS',
                textAlign: TextAlign.center, style: wineBoldStyle(size: 25))),
      ],
    );
  }

  Widget _noActiveStudentsWidget() {
    return Center(
      child: Text('THERE ARE CURRENTLY NO ACTIVE STUDENTS',
          textAlign: TextAlign.center, style: wineBoldStyle(size: 25)),
    );
  }

  Widget _activeStudentsDisplayWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView.builder(
          shrinkWrap: false,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _profileImageWidget(student.profileImageURL),
                              _profileDataWidget(student)
                            ]))));
          }),
    );
  }

  Widget _profileImageWidget(String imageURL) {
    if (imageURL.isNotEmpty) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: NetworkImage(imageURL));
    } else {
      return CircleAvatar(
          backgroundColor: AppColors.orchid.withAlpha(128),
          radius: 20,
          child: const Icon(
            Icons.person,
            color: AppColors.love,
          ));
    }
  }

  Widget _profileDataWidget(ActiveStudentEntry student) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Center(
        child: Column(children: [
          AutoSizeText('${student.firstName} ${student.lastName}',
              textAlign: TextAlign.center,
              minFontSize: 6,
              style: wineBoldStyle(size: 14)),
          AutoSizeText('Last Login:',
              textAlign: TextAlign.center,
              minFontSize: 6,
              style: wineBoldStyle(size: 10)),
          AutoSizeText(
              DateFormat('dd MMM yyyy hh:mm:ss a').format(student.lastLoginTime),
              minFontSize: 6,
              textAlign: TextAlign.center,
              style: wineBoldStyle(size: 10)),
        ]),
      ),
    );
  }
}
