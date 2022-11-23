import 'package:flutter/material.dart';
import 'package:hq/shared/constants/colors.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: greyExtraLightColor,
      body: Center(child: CircularProgressIndicator.adaptive(),),
    );
  }
}
