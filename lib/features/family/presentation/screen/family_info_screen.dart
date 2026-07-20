import 'package:flutter/material.dart';

import '../../../../app/ui_kit/app_bar.dart';

class FamilyInfoScreen extends StatelessWidget {
  const FamilyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar.profile(actions: []));
  }
}
