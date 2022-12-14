import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sultan/cubit/cubit.dart';
import 'package:sultan/cubit/states.dart';
import 'package:sultan/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:sultan/shared/components/general_components.dart';
import 'package:sultan/shared/constants/colors.dart';
import 'package:sultan/shared/constants/general_constants.dart';
import 'package:sultan/shared/network/local/const_shared.dart';
import 'package:sultan/translations/locale_keys.g.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.homeTxtNotifications.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 20.0, bottom: 20.0, left: 20.0),
            child: ListView.separated(
              itemBuilder: (context, index) => NotificationsCard(notificationsDataModel: AppCubit.get(context).notificationsModel!.data![index],),
              separatorBuilder: (context, index) => verticalSmallSpace,
              itemCount: AppCubit.get(context).notificationsModel?.data?.length ?? 0,
            ),
          ),
        );
      },
    );
  }
}
