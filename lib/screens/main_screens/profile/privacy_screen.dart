import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sultan/cubit/cubit.dart';
import 'package:sultan/cubit/states.dart';
import 'package:sultan/shared/components/general_components.dart';
import 'package:sultan/shared/constants/colors.dart';
import 'package:sultan/shared/constants/general_constants.dart';
import 'package:sultan/translations/locale_keys.g.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtTitleOfOurPrivacyPolicy.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              AppCubit.get(context).termsModel?.data?.privacy ?? '',
              style: titleSmallStyle,
            ),
          ),
        );
      },
    );
  }
}
