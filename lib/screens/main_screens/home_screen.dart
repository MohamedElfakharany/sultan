import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hq/cubit/cubit.dart';
import 'package:hq/cubit/states.dart';
import 'package:hq/screens/main_screens/tech_support_screens/create_tech_support_screen.dart';
import 'package:hq/screens/main_screens/test_items_screen/test_details_screen.dart';
import 'package:hq/screens/main_screens/test_items_screen/test_items_screen.dart';
import 'package:hq/screens/main_screens/widgets_components/widgets_components.dart';
import 'package:hq/shared/components/general_components.dart';
import 'package:hq/shared/constants/colors.dart';
import 'package:hq/shared/constants/general_constants.dart';
import 'package:hq/shared/network/local/cache_helper.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/translations/locale_keys.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (AppCubit.get(context).isVisitor == false) {
      AppCubit.get(context).getCarouselData();
      AppCubit.get(context).getTerms();
      AppCubit.get(context).getProfile();
      AppCubit.get(context).getNotifications();
    }
    if (AppCubit.get(context).isVisitor == true) {
      Timer(
        const Duration(microseconds: 0),
        () async {
          extraBranchTitle = await CacheHelper.getData(key: 'extraBranchTitle');
          extraCityId = await CacheHelper.getData(key: 'extraCityId');
          extraBranchId = await CacheHelper.getData(key: 'extraBranchId');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    String? locationValue;
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getCountry()
        ..getTerms()
        ..getCity(countryId: extraCountryId!)
        ..getBranch(cityID: extraCityId!)
        ..getCategories()
        ..getOffers()
        ..getNotifications(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // AppCubit.get(context).getProfile();
          // AppCubit.get(context).userResourceModel?.data?.branch?.title;
          return Scaffold(
            backgroundColor: greyExtraLightColor,
            body: ConditionalBuilder(
              condition: state is! AppGetBranchesLoadingState &&
                  state is! AppGetCarouselLoadingState &&
                  state is! AppGetCitiesLoadingState &&
                  state is! AppGetCountriesLoadingState &&
                  state is! AppGetRelationsLoadingState &&
                  state is! AppGetCategoriesLoadingState &&
                  state is! AppGetOffersLoadingState &&
                  state is! AppGetTestsLoadingState &&
                  state is! AppGetProfileLoadingState &&
                  cubit.branchNames != null,
              builder: (context) {
                locationValue = AppCubit.get(context).branchName[extraBranchIndex ?? 0];
                return Container(
                  color: greyExtraLightColor,
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: greyDarkColor,
                          ),
                          horizontalMiniSpace,
                          Text(
                            '${LocaleKeys.txtBranch.tr()} : ',
                            style: titleSmallStyle,
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ConditionalBuilder(
                                condition:
                                    state is! AppGetBranchesLoadingState ||
                                        state is! AppGetCitiesLoadingState ||
                                        state is! AppGetCountriesLoadingState ||
                                        cubit.branchNames != null,
                                builder: (context) {
                                  if (kDebugMode) {
                                    print('ghany 2 ${AppCubit.get(context).branchName}');
                                    print('ghany 2 $locationValue');
                                    print('ghany 2 $extraBranchTitle');
                                  }
                                  return DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      fillColor: greyExtraLightColor,
                                      filled: true,
                                      errorStyle:
                                          TextStyle(color: Color(0xFF4F4F4F)),
                                      border: InputBorder.none,
                                    ),
                                    value: locationValue,
                                    isExpanded: true,
                                    iconSize: 30,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: greyDarkColor,
                                    ),
                                    items: AppCubit.get(context)
                                        .branchName
                                        .map(buildLocationItem)
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        locationValue = value;
                                      });
                                      // AppCubit.get(context).selectBranch(name: locationValue!);
                                    },
                                    onSaved: (v) {
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                                fallback: (context) => const Center(
                                    child: LinearProgressIndicator()),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalMiniSpace,
                      ConditionalBuilder(
                        condition: cubit.carouselModel?.data != null,
                        builder: (context) => CarouselSlider(
                          items: cubit.carouselModel?.data!
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      color: whiteColor,
                                      border: Border.all(color: greyLightColor),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            e.image,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 15.0, end: 15.0),
                                      // decoration: BoxDecoration(
                                      //   color: greyExtraLightColor.withOpacity(0.7),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          verticalMiniSpace,
                                          Text(
                                            e.title ?? '',
                                            style: titleSmallStyleRed.copyWith(
                                                fontSize: 20),
                                          ),
                                          verticalMiniSpace,
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              e.text ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: titleSmallStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            height: 150.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 1.0,
                            onPageChanged: (int index, reason) {
                              AppCubit.get(context).changeCarouselState(index);
                            },
                          ),
                        ),
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      verticalMiniSpace,
                      Row(
                        children: [
                          Text(LocaleKeys.txtTestCategories.tr(),
                              style: titleStyle),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                cubit.changeBottomScreen(1);
                              });
                            },
                            child: Text(
                              LocaleKeys.BtnSeeAll.tr(),
                              style: subTitleSmallStyle,
                            ),
                          ),
                        ],
                      ),
                      verticalMiniSpace,
                      SizedBox(
                        height: 110.0,
                        width: double.infinity,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: TestItemsScreen(
                                    categoryId: AppCubit.get(context)
                                        .categoriesModel!
                                        .data![index]
                                        .id,
                                  ),
                                ),
                              );
                            },
                            child: CategoriesCard(
                              categoriesDataModel: AppCubit.get(context)
                                  .categoriesModel!
                                  .data![index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              horizontalMiniSpace,
                          itemCount: AppCubit.get(context)
                                  .categoriesModel
                                  ?.data
                                  ?.length ??
                              0,
                        ),
                      ),
                      verticalMiniSpace,
                      Container(
                        // height: 170.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          color: whiteColor,
                          border: Border.all(color: greyLightColor),
                          // image: DecorationImage(
                          //     image: AssetImage('assets/images/homeImageReserv.png'),
                          //     fit: BoxFit.contain),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalMicroSpace,
                                  Text(
                                    LocaleKeys.txtHomeReservation.tr(),
                                    style: titleSmallStyle.copyWith(
                                        color: mainColor, fontSize: 20),
                                  ),
                                  verticalMicroSpace,
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      LocaleKeys.onboardingBody.tr(),
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: titleSmallStyle2,
                                    ),
                                  ),
                                  GeneralButton(
                                    title:
                                        '${LocaleKeys.TxtReservationScreenTitle.tr()} ${LocaleKeys.txtNow.tr()}',
                                    onPress: () {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: const CreateTechSupportScreen(),
                                        ),
                                      );
                                    },
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: 10.0,
                                start: 10.0,
                                bottom: 10.0,
                              ),
                              child: Image.asset(
                                  'assets/images/homeImageReserv.png'),
                            )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(LocaleKeys.homeTxtOffers.tr(),
                              style: titleStyle),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              cubit.fromHome = true;
                              cubit.changeBottomScreen(1);
                            },
                            child: Text(
                              LocaleKeys.BtnSeeAll.tr(),
                              style: subTitleSmallStyle,
                            ),
                          ),
                        ],
                      ),
                      ConditionalBuilder(
                        condition: cubit.offersModel?.data != null ||
                            state is! AppGetOffersLoadingState,
                        builder: (context) => SizedBox(
                          height: 235.0,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: TestDetailsScreen(
                                      offersDataModel: AppCubit.get(context)
                                          .offersModel!
                                          .data![index],
                                    ),
                                  ),
                                );
                              },
                              child: OffersCard(
                                offersDataModel: AppCubit.get(context)
                                    .offersModel!
                                    .data![index],
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                horizontalMiniSpace,
                            itemCount: AppCubit.get(context)
                                    .offersModel
                                    ?.data
                                    ?.length ??
                                0,
                          ),
                        ),
                        fallback: (context) => const Center(
                            child: CircularProgressIndicator.adaptive()),
                      ),
                      verticalMiniSpace,
                    ],
                  ),
                );
              },
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        },
      ),
    );
  }

  DropdownMenuItem<String> buildLocationItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );
}
