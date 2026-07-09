import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:flutter/material.dart';

class ProfileEditorScreen extends StatelessWidget {
  const ProfileEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar.profile(actions: []));
  }
}
