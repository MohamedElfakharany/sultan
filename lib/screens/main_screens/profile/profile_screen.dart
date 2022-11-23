import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hq/cubit/cubit.dart';
import 'package:hq/cubit/states.dart';
import 'package:hq/screens/main_screens/profile/address_screen/address_screen.dart';
import 'package:hq/screens/main_screens/profile/edit_profile/edit_profile.dart';
import 'package:hq/screens/main_screens/profile/family/family_screen.dart';
import 'package:hq/screens/main_screens/profile/medical_inquiries/medical_inquiries_screen.dart';
import 'package:hq/screens/main_screens/profile/privacy_screen.dart';
import 'package:hq/screens/main_screens/profile/region_settings/region_settings.dart';
import 'package:hq/screens/main_screens/profile/terms_conditions_screen.dart';
import 'package:hq/screens/main_screens/tech_support_screens/technical_support_screen.dart';
import 'package:hq/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:hq/shared/components/general_components.dart';
import 'package:hq/shared/constants/colors.dart';
import 'package:hq/shared/constants/general_constants.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/translations/locale_keys.g.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool later = true;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 0),
      () async {
        if (AppCubit.get(context).isVisitor == false) {
          AppCubit.get(context).getTerms();
          AppCubit.get(context).getMedicalInquiries();
          AppCubit.get(context).getProfile();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: ConditionalBuilder(
            condition: state is! AppGetProfileLoadingState &&
                state is! AppGetMedicalInquiriesLoadingState,
            builder: (context) => Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(profileBG),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (AppCubit.get(context).isVisitor == true)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70.0),
                            child: CachedNetworkImage(
                              imageUrl: AppCubit.get(context)
                                      .userResourceModel
                                      ?.data
                                      ?.profile ??
                                  imageTest,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: mainColor,
                                )),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: whiteColor),
                                child: const Icon(
                                  Icons.perm_identity,
                                  size: 100,
                                  color: mainColor,
                                ),
                              ),
                              width: 120,
                              height: 120,
                            ),
                          ),
                        if (AppCubit.get(context).isVisitor == true)
                          horizontalSmallSpace,
                        if (AppCubit.get(context).isVisitor == false)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70.0),
                            child: CachedNetworkImage(
                              imageUrl: AppCubit.get(context)
                                      .userResourceModel
                                      ?.data
                                      ?.profile ??
                                  imageTest,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: mainColor,
                                )),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: whiteColor),
                                child: const Icon(
                                  Icons.perm_identity,
                                  size: 100,
                                  color: mainColor,
                                ),
                              ),
                              width: 120,
                              height: 120,
                            ),
                          ),
                        horizontalSmallSpace,
                        if (AppCubit.get(context).isVisitor == false)
                          Text(
                            AppCubit.get(context)
                                    .userResourceModel
                                    ?.data
                                    ?.name ??
                                '',
                            style: titleStyle.copyWith(color: whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        verticalMiniSpace,
                        if (AppCubit.get(context).isVisitor == false)
                          Text(
                            AppCubit.get(context)
                                    .userResourceModel
                                    ?.data
                                    ?.phone ??
                                '',
                            style: titleSmallStyle.copyWith(color: whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
                verticalMediumSpace,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, left: 20.0, bottom: 20.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (AppCubit.get(context).isVisitor == true &&
                              later == true)
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(radius + 5),
                                border: Border.all(
                                  width: 1.0,
                                  color: greyLightColor,
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.txtCompleteProfile.tr(),
                                    style: titleStyle,
                                  ),
                                  Text(
                                    LocaleKeys.txtCompleteProfileSecond.tr(),
                                    style: subTitleSmallStyle,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: LinearProgressIndicator(
                                            minHeight: 5,
                                            color: greenColor,
                                            value: 0.5,
                                            backgroundColor:
                                                greyLightColor.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                      horizontalSmallSpace,
                                      const Text(
                                        '50 %',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          showPopUp(
                                            context,
                                            const VisitorHoldingPopUp(),
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(radius),
                                          ),
                                          child: Center(
                                              child: Text(
                                            LocaleKeys.txtCompleteProfileNow
                                                .tr(),
                                            style: titleStyle.copyWith(
                                                fontSize: 16.0,
                                                color: whiteColor,
                                                fontWeight: FontWeight.normal),
                                          )),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            later = false;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: greyExtraLightColor,
                                            borderRadius:
                                                BorderRadius.circular(radius),
                                          ),
                                          child: Center(
                                            child: Text(
                                              LocaleKeys.BtnLater.tr(),
                                              style: subTitleSmallStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          verticalSmallSpace,
                          InkWell(
                            onTap: () {
                              if (AppCubit.get(context).isVisitor == true) {
                                showPopUp(
                                  context,
                                  const VisitorHoldingPopUp(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const MedicalInquiriesScreen(),
                                  ),
                                );
                              }
                            },
                            child: Badge(
                              position: BadgePosition.topEnd(end: 40.0),
                              alignment: AlignmentDirectional.centerEnd,
                              animationType: BadgeAnimationType.fade,
                              badgeContent: Text(
                                '${AppCubit.get(context).medicalInquiriesModel?.data?.length ?? ''}',
                                style: titleSmallStyle2.copyWith(
                                    color: whiteColor),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/inquiries.jpg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  horizontalSmallSpace,
                                  Text(
                                    LocaleKeys.txtMedicalInquiries.tr(),
                                    style: titleSmallStyle.copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const Spacer(),
                                  horizontalSmallSpace,
                                  const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: greyLightColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              if (AppCubit.get(context).isVisitor == true) {
                                showPopUp(
                                  context,
                                  const VisitorHoldingPopUp(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const TechnicalSupportScreen(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/reservedSelected.png',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.TxtReservationScreenTitle.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                horizontalSmallSpace,
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              if (AppCubit.get(context).isVisitor == true) {
                                showPopUp(
                                  context,
                                  const VisitorHoldingPopUp(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const EditProfileScreen(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/edit.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtEditProfile.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              if (AppCubit.get(context).isVisitor == true) {
                                showPopUp(
                                  context,
                                  const VisitorHoldingPopUp(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const FamilyScreen(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/family.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtFamily.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              if (AppCubit.get(context).isVisitor == true) {
                                showPopUp(
                                  context,
                                  const VisitorHoldingPopUp(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: const AddressScreen(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/location.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtAddress.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const RegionSettingsScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/setting.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtRegionSettings.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: myHorizontalDivider(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const TermsConditionsScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/terms.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtTitleOfOurTermsOfService.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: const PrivacyScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/terms.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.txtTitleOfOurPrivacyPolicy.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                          InkWell(
                            onTap: () {
                              showPopUp(
                                context,
                                Container(
                                  height: 320,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      verticalSmallSpace,
                                      Image.asset(
                                        'assets/images/warning-2.jpg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      verticalMediumSpace,
                                      Text(
                                        LocaleKeys.drawerLogOutMain.tr(),
                                        textAlign: TextAlign.center,
                                        style: titleStyle.copyWith(
                                          color: redColor,
                                        ),
                                      ),
                                      verticalMediumSpace,
                                      GeneralButton(
                                        radius: radius,
                                        btnBackgroundColor: redColor,
                                        title: LocaleKeys.drawerLogout.tr(),
                                        onPress: () {
                                          AppCubit.get(context).currentIndex =
                                              0;
                                          AppCubit.get(context)
                                              .signOut(context);
                                        },
                                      ),
                                      verticalSmallSpace,
                                      GeneralButton(
                                        radius: radius,
                                        btnBackgroundColor: greyExtraLightColor,
                                        txtColor: greyDarkColor,
                                        title: LocaleKeys.BtnCancel.tr(),
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/signOut.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                horizontalSmallSpace,
                                Text(
                                  LocaleKeys.drawerLogout.tr(),
                                  style: titleSmallStyle.copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: greyLightColor,
                                ),
                              ],
                            ),
                          ),
                          verticalMediumSpace,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
    );
  }
}
