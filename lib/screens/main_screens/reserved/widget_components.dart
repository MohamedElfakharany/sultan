// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hq/cubit/cubit.dart';
import 'package:hq/cubit/states.dart';
import 'package:hq/models/patient_models/home_appointments_model/home_reservation_model.dart';
import 'package:hq/models/patient_models/lab_appointments_model/lab_reservation_model.dart';
import 'package:hq/shared/constants/colors.dart';
import 'package:hq/shared/constants/general_constants.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/translations/locale_keys.g.dart';

class ReservedCard extends StatelessWidget {
  ReservedCard(
      {Key? key, this.labReservationsDataModel, this.homeReservationsDataModel})
      : super(key: key);
  LabReservationsDateModel? labReservationsDataModel;
  HomeReservationsDataModel? homeReservationsDataModel;
  @override
  Widget build(BuildContext context) {
    String title;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Color stateColor;
        if (labReservationsDataModel?.statusEn == 'Pending' || homeReservationsDataModel?.statusEn == 'Pending') {
          stateColor = pendingColor;
        } else if (labReservationsDataModel?.statusEn == 'Accepted' || homeReservationsDataModel?.statusEn == 'Accepted') {
          stateColor = acceptedColor;
        } else if (labReservationsDataModel?.statusEn == 'Sampling' || homeReservationsDataModel?.statusEn == 'Sampling') {
          stateColor = samplingColor;
        } else if (labReservationsDataModel?.statusEn == 'Finished' || homeReservationsDataModel?.statusEn == 'Finished') {
          stateColor = finishedColor;
        } else {
          stateColor = canceledColor;
        }
        if (labReservationsDataModel?.tests?.isEmpty ??
            homeReservationsDataModel!.tests!.isEmpty) {
          title = labReservationsDataModel?.offers?.first.title ??
              homeReservationsDataModel!.offers?.first.title;
        } else if (labReservationsDataModel?.offers?.isEmpty ??
            homeReservationsDataModel!.offers!.isEmpty) {
          title = labReservationsDataModel?.tests?.first.title ??
              homeReservationsDataModel!.tests?.first.title;
        } else {
          title = '';
        }
        if (homeReservationsDataModel != null) {
          if (homeReservationsDataModel!.tests!.isEmpty) {
            title = homeReservationsDataModel?.offers?.first.title;
          } else if (homeReservationsDataModel!.offers!.isEmpty) {
            title = homeReservationsDataModel?.tests?.first.title;
          } else {
            title = '';
          }
        } else if (labReservationsDataModel != null) {
          if (labReservationsDataModel!.tests!.isEmpty) {
            title = labReservationsDataModel?.offers?.first.title;
          } else if (labReservationsDataModel!.offers!.isEmpty) {
            title = labReservationsDataModel?.tests?.first.title;
          } else {
            title = '';
          }
        } else {
          title = '';
        }
        return ConditionalBuilder(
          condition: state is! AppGetHomeReservationsLoadingState ||
              state is! AppGetLabReservationsLoadingState,
          builder: (context) => SizedBox(
            height: 150,
            child: Container(
              height: 110.0,
              width: 110.0,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  width: 1,
                  color: greyLightColor,
                ),
              ),
              alignment: AlignmentDirectional.center,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          '# ${labReservationsDataModel?.id ?? homeReservationsDataModel?.id}',
                          style: titleSmallStyle.copyWith(fontSize: 15.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${labReservationsDataModel?.price ?? homeReservationsDataModel?.price} ${LocaleKeys.salary.tr()}',
                          style: titleStyle.copyWith(fontSize: 18.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: titleSmallStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${labReservationsDataModel?.date ?? homeReservationsDataModel?.date} - ${labReservationsDataModel?.time ?? homeReservationsDataModel?.time}',
                      style: titleSmallStyle2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      height: 36,
                      width: 130,
                      decoration: BoxDecoration(
                        color: stateColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                          child: Text(
                        labReservationsDataModel?.status ??
                            homeReservationsDataModel?.status,
                        style: titleStyle.copyWith(
                            fontSize: 15.0,
                            color: stateColor,
                            fontWeight: FontWeight.normal),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}
