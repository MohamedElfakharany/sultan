// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:hq/shared/components/cached_network_image.dart';
import 'package:hq/shared/components/general_components.dart';
import 'package:hq/shared/constants/colors.dart';
import 'package:hq/shared/constants/general_constants.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:hq/tech_lib/tech_cubit/tech_states.dart';
import 'package:hq/tech_lib/tech_models/reservation_model.dart';
import 'package:hq/tech_lib/tech_screens/tech_map_screen.dart';
import 'package:hq/translations/locale_keys.g.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class TechReservationsDetailsScreen extends StatefulWidget {
  const TechReservationsDetailsScreen({
    Key? key,
    required this.index,
    required this.techReservationsDataModel,
  }) : super(key: key);
  final TechReservationsDataModel? techReservationsDataModel;
  final int index;

  @override
  State<TechReservationsDetailsScreen> createState() =>
      _TechReservationsDetailsScreenState();
}

class _TechReservationsDetailsScreenState
    extends State<TechReservationsDetailsScreen> {
  var couponController = TextEditingController();
  bool isFinished = false;
  var swipeColor = mainColor;
  var swipeText = LocaleKeys.BtnSwapToSample.tr();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppTechCubit, AppTechStates>(
      listener: (context, state) {
        if (state is AppSamplingRequestsLoadingState) {
          isFinished = true;
        }
        if (state is AppSamplingRequestsSuccessState) {
          if (state.successModel.status) {
            setState(() {
              isFinished = false;
            });
          } else {
            setState(() {
              isFinished = false;
            });
          }
        }
      },
      builder: (context, state) {
        var techReservations = widget.techReservationsDataModel;
        Color stateColor;
        if (techReservations?.statusEn == 'Pending') {
          stateColor = pendingColor;
        } else if (techReservations?.statusEn == 'Accepted') {
          stateColor = acceptedColor;
        } else if (techReservations?.statusEn == 'Sampling') {
          stateColor = samplingColor;
        } else if (techReservations?.statusEn == 'Finished') {
          stateColor = finishedColor;
        } else {
          stateColor = canceledColor;
        }
        if (techReservations?.statusEn == 'Accepted') {
          swipeColor = mainColor;
          swipeText = LocaleKeys.BtnSwapToSample.tr();
        } else if (techReservations?.statusEn == 'Sampling') {
          swipeColor = yellowColor;
          swipeText = LocaleKeys.txtSampling.tr();
        }
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtReservationDetails.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(width: 1, color: greyLightColor),
                  ),
                  alignment: AlignmentDirectional.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '# ${techReservations?.id}',
                          style: titleStyle,
                        ),
                        const Spacer(),
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: stateColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: Text(
                              '${techReservations?.status}',
                              style: titleStyle.copyWith(
                                  fontSize: 15.0,
                                  color: stateColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              verticalMediumSpace,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 120.0 *
                            (techReservations?.tests?.length ??
                                0 + (techReservations?.offers?.length ?? 0)),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => SwipeActionCell(
                            // key: ValueKey(AppCubit.get(context)
                            //     .medicalInquiriesModel!
                            //     .data![index]),
                            key: const ValueKey(1),
                            trailingActions: [
                              SwipeAction(
                                nestedAction: SwipeNestedAction(
                                  /// customize your nested action content
                                  content: ConditionalBuilder(
                                    condition: true,
                                    builder: (context) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.red,
                                      ),
                                      width: 130,
                                      height: 60,
                                      child: OverflowBox(
                                        maxWidth: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            Text(LocaleKeys.BtnDelete.tr(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator.adaptive()),
                                  ),
                                ),

                                /// you should set the default  bg color to transparent
                                color: Colors.transparent,

                                /// set content instead of title of icon
                                content:
                                    _getIconButton(Colors.red, Icons.delete),
                                onTap: (handler) async {
                                  // AppCubit.get(context).deleteInquiry(
                                  //   inquiryId: AppCubit.get(context)
                                  //       .medicalInquiriesModel!
                                  //       .data![index]
                                  //       .id,
                                  // );
                                },
                              ),
                            ],
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 4),
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Row(
                                    children: [
                                      horizontalMicroSpace,
                                      CachedNetworkImageNormal(
                                        imageUrl: techReservations
                                                ?.tests?[index].image ??
                                            techReservations
                                                ?.offers?[index].image,
                                        width: 80,
                                        height: 80,
                                      ),
                                      horizontalSmallSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              techReservations
                                                      ?.tests?[index].title ??
                                                  techReservations
                                                      ?.offers?[index].title,
                                              style: titleSmallStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              techReservations?.tests?[index]
                                                      .category ??
                                                  '',
                                              style: subTitleSmallStyle2,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${techReservations?.tests?[index].price ?? techReservations?.offers?[index].price} ${LocaleKeys.salary.tr()}',
                                              style: titleSmallStyle2,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              verticalMiniSpace,
                          itemCount: (techReservations?.tests?.length ?? 0) +
                              (techReservations?.offers?.length ?? 0),
                        ),
                      ),
                      Text(
                        LocaleKeys.txtReservationDetails.tr(),
                        style: titleStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                      verticalMiniSpace,
                      Container(
                        height: 236.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  horizontalSmallSpace,
                                  Image.asset(
                                    'assets/images/profile.png',
                                    width: 25,
                                    height: 35,
                                    color: mainColor,
                                  ),
                                  myVerticalDivider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocaleKeys.txtPatient.tr(),
                                        style: titleStyle.copyWith(
                                            color: greyLightColor),
                                      ),
                                      Text(
                                        techReservations?.patient?.name,
                                        textAlign: TextAlign.start,
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            myHorizontalDivider(),
                            Expanded(
                              child: Row(
                                children: [
                                  horizontalSmallSpace,
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: mainColor,
                                  ),
                                  myVerticalDivider(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          LocaleKeys.txtAddress.tr(),
                                          style: titleStyle.copyWith(
                                              color: greyLightColor),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${techReservations?.address?.address}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  FadeRoute(
                                                    page: TechMapScreen(
                                                      lat: techReservations
                                                          ?.address?.latitude,
                                                      long: techReservations
                                                          ?.address?.longitude,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                LocaleKeys.txtShowMap.tr(),
                                                style:
                                                    titleSmallStyle2.copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: mainColor),
                                              ),
                                            ),
                                            horizontalSmallSpace,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            myHorizontalDivider(),
                            Expanded(
                              child: Row(
                                children: [
                                  horizontalSmallSpace,
                                  Image.asset(
                                    'assets/images/reservedSelected.png',
                                    width: 25,
                                    height: 35,
                                    color: mainColor,
                                  ),
                                  myVerticalDivider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocaleKeys.AppointmentScreenTxtTitle
                                            .tr(),
                                        style: titleStyle.copyWith(
                                            color: greyLightColor),
                                      ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${techReservations?.createdAt?.date} - ${techReservations?.createdAt?.time}',
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalMiniSpace,
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSmallSpace,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                LocaleKeys.txtSummary.tr(),
                                style: titleSmallStyle.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            myHorizontalDivider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtItems.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${techReservations?.tests?.length ?? 0 + (techReservations?.offers?.length ?? 0)}',
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  verticalMicroSpace,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtPrice.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${techReservations?.price} ${LocaleKeys.salary.tr()}',
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  verticalMicroSpace,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtVAT.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${techReservations?.tax} %',
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  verticalMicroSpace,
                                  const MySeparator(),
                                  verticalMicroSpace,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.txtTotal.tr(),
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        textAlign: TextAlign.start,
                                        '${techReservations?.total} ${LocaleKeys.salary.tr()}',
                                        style: titleSmallStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        LocaleKeys.txtAddedTax.tr(),
                                        textAlign: TextAlign.start,
                                        style: titleSmallStyle.copyWith(
                                            color: greyDarkColor,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: whiteColor,
                padding: const EdgeInsets.only(
                    bottom: 40.0, left: 20.0, right: 20.0, top: 20.0),
                child: Row(
                  children: [
                    if (techReservations?.statusEn == 'Accepted')
                      Expanded(
                        child: SwipeableButtonView(
                          buttonColor: swipeColor,
                          buttonText: swipeText,
                          buttontextstyle: titleSmallStyle,
                          buttonWidget: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: whiteColor,
                          ),
                          activeColor: swipeColor.withOpacity(0.2),
                          isFinished: isFinished,
                          onWaitingProcess: () {
                            if (kDebugMode) {
                              print('onWaitingProcess');
                            }
                            AppTechCubit.get(context)
                                .sampling(requestId: techReservations?.id);
                            // Future.delayed(const Duration(seconds: 1), () {
                            //   setState(() {
                            //     isFinished = true;
                            //   });
                            // });
                          },
                          onFinish: () {
                            // if (kDebugMode) {
                            //   print('onFinish');
                            // }
                            // setState(() {
                            //   isFinished = false;
                            // });
                          },
                        ),
                      ),
                    horizontalSmallSpace,
                    CircleAvatar(
                      backgroundColor: greenColor,
                      radius: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: whiteColor,
                        ),
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                              '${techReservations?.patient?.phoneCode}${techReservations?.patient?.phone}');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        /// set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
