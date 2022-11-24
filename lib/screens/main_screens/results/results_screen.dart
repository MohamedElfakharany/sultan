import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sultan/cubit/cubit.dart';
import 'package:sultan/cubit/states.dart';
import 'package:sultan/screens/main_screens/profile/region_settings/change_language.dart';
import 'package:sultan/screens/main_screens/results/result_details.dart';
import 'package:sultan/screens/main_screens/results/widget_components.dart';
import 'package:sultan/shared/components/general_components.dart';
import 'package:sultan/shared/constants/colors.dart';
import 'package:sultan/shared/constants/general_constants.dart';
import 'package:sultan/translations/locale_keys.g.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getLabResults();
    AppCubit.get(context).getHomeResults();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: greyExtraLightColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  // the tab bar with two items
                  if (AppCubit.get(context).isVisitor == true)
                    const Expanded(
                      child: VisitorHolderScreen(),
                    ),
                  if (AppCubit.get(context).isVisitor == false)
                    SizedBox(
                      height: 60,
                      child: AppBar(
                        backgroundColor: greyExtraLightColor,
                        elevation: 0.0,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        bottom: TabBar(
                          indicatorColor: mainColor,
                          tabs: [
                            Tab(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: mainLightColor, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        color: whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/atLabIcon.png',
                                            width: 25,
                                            height: 25,
                                            color: mainColor,
                                          ),
                                          horizontalMiniSpace,
                                          Text(
                                            LocaleKeys.BtnAtLab.tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: darkColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  verticalMicroSpace,
                                ],
                              ),
                            ),
                            Tab(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: mainLightColor, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        color: whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/atHomeIcon.png',
                                            width: 25,
                                            height: 25,
                                            color: mainColor,
                                          ),
                                          horizontalMiniSpace,
                                          Text(
                                            LocaleKeys.BtnAtHome.tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: darkColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  verticalMicroSpace,
                                ],
                              ),
                            ),
                            // Tab(
                            //   child: Column(
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           height: 60,
                            //           width: double.infinity,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(8),
                            //             border: Border.all(
                            //                 color: blueLightColor, width: 2),
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color:
                            //                     Colors.grey.withOpacity(0.15),
                            //                 spreadRadius: 2,
                            //                 blurRadius: 2,
                            //                 offset: const Offset(0, 2),
                            //               ),
                            //             ],
                            //             color: whiteColor,
                            //           ),
                            //           child: Center(
                            //             child: Text(
                            //               LocaleKeys.txtCanceled.tr(),
                            //               textAlign: TextAlign.start,
                            //               style: const TextStyle(
                            //                 fontSize: 14,
                            //                 color: darkColor,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       verticalMicroSpace,
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  // create widgets for each tab bar here
                  if (AppCubit.get(context).isVisitor == false)
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // first tab bar view widget
                          ConditionalBuilder(
                            condition: AppCubit.get(context).labResultsModel!.data!.isEmpty,
                            builder: (context)=> Column(
                              children: [
                                verticalSmallSpace,
                                ConditionalBuilder(
                                  condition:
                                  state is! AppGetLabResultsLoadingState || state is! AppGetHomeResultsLoadingState,
                                  builder: (context) => Expanded(
                                    child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              page: ResultDetailsScreen(labResultsDataModel: AppCubit.get(context)
                                                  .labResultsModel!.data![index], index: index,),
                                            ),
                                          );
                                        },
                                        child: ResultsScreenCard(
                                          labResultsModel: AppCubit.get(context)
                                              .labResultsModel!,
                                          index: index,
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                      verticalMiniSpace,
                                      itemCount: AppCubit.get(context)
                                          .labResultsModel
                                          ?.data
                                          ?.length ??
                                          0,
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                              ],
                            ),
                            fallback: (context)=> ScreenHolder(
                                msg:
                                '${LocaleKeys.txtNoResults.tr()} ${LocaleKeys.BtnAtHome.tr()}'),
                          ),
                          // second tab bar view widget
                          ConditionalBuilder(
                            condition:
                            AppCubit.get(context).homeResultsModel?.data?.isEmpty ==
                                false,
                            builder: (context)=> Column(
                              children: [
                                verticalSmallSpace,
                                ConditionalBuilder(
                                  condition:
                                  state is! AppGetLabResultsLoadingState || state is! AppGetHomeResultsLoadingState,
                                  builder: (context) => Expanded(
                                    child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              page: ResultDetailsScreen(homeResultsDataModel: AppCubit.get(context)
                                                  .homeResultsModel!.data![index], index: index,),
                                            ),
                                          );
                                        },
                                        child: ResultsScreenCard(
                                          homeResultsModel: AppCubit.get(context)
                                              .homeResultsModel!,
                                          index: index,
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                      verticalMiniSpace,
                                      itemCount: AppCubit.get(context)
                                          .homeResultsModel
                                          ?.data
                                          ?.length ??
                                          0,
                                    ),
                                  ),
                                  fallback: (context) => const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                              ],
                            ),
                            fallback: (context)=> ScreenHolder(
                                msg:
                                '${LocaleKeys.txtNoResults.tr()} ${LocaleKeys.BtnAtHome.tr()}'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
