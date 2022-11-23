// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hq/cubit/cubit.dart';
import 'package:hq/cubit/states.dart';
import 'package:hq/screens/intro_screens/auth/login_screen.dart';
import 'package:hq/screens/intro_screens/reset_password/verification_screen.dart';
import 'package:hq/shared/components/general_components.dart';
import 'package:hq/shared/constants/colors.dart';
import 'package:hq/shared/constants/general_constants.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userNameController = TextEditingController();

  final mobileController = TextEditingController();

  final nationalCodeController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nationalIdController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final _focusNodes =
      Iterable<int>.generate(5).map((_) => FocusNode()).toList();

  FirebaseAuth auth = FirebaseAuth.instance;

  String? verificationId = "";

  Future<void> fetchOtp({required String number}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+2$number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((v) => {});
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    if (kDebugMode) {
      print('verificationId Sign In : $verificationId');
    }
  }

  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  double passwordStrength = 0;

  bool validatePassword(String pass) {
    String password = pass.trim();
    if (password.isEmpty) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (password.length < 6) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (password.length < 8) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(password)) {
        setState(() {
          passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  bool isPasswordTyping = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is AppRegisterSuccessState) {
          if (state.userResourceModel.status) {
            token = state.userResourceModel.extra!.token;
            fetchOtp(number: mobileController.text.toString());
            await Navigator.push(
              context,
              FadeRoute(
                page: VerificationScreen(
                  isRegister: true,
                  phoneCode: nationalCodeController.text,
                  mobileNumber: mobileController.text.toString(),
                ),
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(state.userResourceModel.message),
                    content: Text(LocaleKeys.txtLoginAgain.tr()),
                  );
                });
          }
        } else if (state is AppRegisterErrorState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(LocaleKeys.txtLoginAgain.tr()),
                );
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: GeneralAppBar(
            title: '',
          ),
          body: Form(
            key: formKey,
            child: KeyboardActions(
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              bottomAvoiderScrollPhysics: const BouncingScrollPhysics(),
              config: KeyboardActionsConfig(
                // Define ``defaultDoneWidget`` only once in the config
                defaultDoneWidget: doneKeyboard(),
                actions: _focusNodes
                    .map((focusNode) =>
                        KeyboardActionsItem(focusNode: focusNode))
                    .toList(),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        LocaleKeys.BtnSignUp.tr(),
                        style: titleStyle.copyWith(
                            fontSize: 35.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        LocaleKeys.registerTxtSecondary.tr(),
                        style: titleStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: greyLightColor),
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  if (isPasswordTyping == false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DefaultFormField(
                        height: 90,
                        focusNode: _focusNodes[0],
                        controller: userNameController,
                        type: TextInputType.text,
                        validatedText: LocaleKeys.txtFieldName.tr(),
                        label: LocaleKeys.txtFieldName.tr(),
                        onTap: () {},
                      ),
                    ),
                  if (isPasswordTyping == false) verticalMiniSpace,
                  if (isPasswordTyping == false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GeneralNationalityCode(
                              canSelect: true,
                              controller: nationalCodeController,
                            ),
                          ),
                          horizontalMiniSpace,
                          Expanded(
                            flex: 3,
                            child: DefaultFormField(
                              height: 90,
                              focusNode: _focusNodes[1],
                              controller: mobileController,
                              type: TextInputType.phone,
                              validatedText: LocaleKeys.txtFieldMobile.tr(),
                              label: LocaleKeys.txtFieldMobile.tr(),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isPasswordTyping == false) verticalMiniSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: whiteColor,
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 4),
                      child: TextFormField(
                        focusNode: _focusNodes[2],
                        onEditingComplete: () {
                          isPasswordTyping = false;
                        },
                        onTapOutside: (value) {
                          isPasswordTyping = false;
                        },
                        onFieldSubmitted: (value) {
                          isPasswordTyping = false;
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              AppCubit.get(context)
                                  .resetChangePasswordVisibility();
                            },
                            icon: Icon(AppCubit.get(context).resetSufIcon),
                            color: mainColor,
                          ),
                          label: Text(LocaleKeys.txtFieldPassword.tr()),
                          hintStyle: const TextStyle(
                              color: greyDarkColor, fontSize: 14),
                          labelStyle: const TextStyle(
                              // color: isClickable ? Colors.grey[400] : blueColor,
                              color: greyDarkColor,
                              fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          errorStyle: const TextStyle(color: redColor),
                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 10.0, bottom: 15.0, top: 15.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: greyExtraLightColor,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            color: mainLightColor,
                            fontSize: 18,
                            fontFamily: fontFamily),
                        obscureText: AppCubit.get(context).resetIsPassword,
                        obscuringCharacter: '*',
                        onChanged: (value) {
                          isPasswordTyping = true;
                          formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.txtFieldPassword.tr();
                          } else {
                            //call function to check password
                            bool result = validatePassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return LocaleKeys.passwordConditions.tr();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LinearProgressIndicator(
                      value: passwordStrength,
                      backgroundColor: Colors.grey[300],
                      minHeight: 5,
                      color: passwordStrength <= 1 / 4
                          ? Colors.red
                          : passwordStrength == 2 / 4
                              ? Colors.yellow
                              : passwordStrength == 3 / 4
                                  ? Colors.blue
                                  : Colors.green,
                    ),
                  ),
                  verticalMiniSpace,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: whiteColor,
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 10), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 4),
                      child: TextFormField(
                        focusNode: _focusNodes[3],
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              AppCubit.get(context)
                                  .resetConfirmChangePasswordVisibility();
                            },
                            icon:
                                Icon(AppCubit.get(context).resetConfirmSufIcon),
                            color: mainColor,
                          ),
                          label: Text(LocaleKeys.TxtFieldConfirmPassword.tr()),
                          hintStyle: const TextStyle(
                              color: greyDarkColor, fontSize: 14),
                          labelStyle: const TextStyle(
                              // color: isClickable ? Colors.grey[400] : blueColor,
                              color: greyDarkColor,
                              fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          errorStyle: const TextStyle(color: redColor),
                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 10.0, bottom: 15.0, top: 15.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: greyExtraLightColor,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            color: mainLightColor,
                            fontSize: 18,
                            fontFamily: fontFamily),
                        obscureText:
                            AppCubit.get(context).resetConfirmIsPassword,
                        obscuringCharacter: '*',
                        onChanged: (value) {
                          formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.TxtFieldConfirmPassword.tr();
                          } else if (value != passwordController.text) {
                            return LocaleKeys.txtPasswordsNotMatch.tr();
                          }
                        },
                      ),
                    ),
                  ),
                  verticalMiniSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DefaultFormField(
                      height: 90,
                      focusNode: _focusNodes[4],
                      controller: nationalIdController,
                      type: TextInputType.number,
                      label: LocaleKeys.txtFieldIdNumber.tr(),
                      onTap: () {},
                      validatedText: LocaleKeys.txtFieldIdNumber.tr(),
                    ),
                  ),
                  verticalMiniSpace,
                  Column(
                    children: [
                      Text(
                        LocaleKeys.txtAgree.tr(),
                        style: subTitleSmallStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              showPopUp(
                                context,
                                Container(
                                  height: 500,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalMediumSpace,
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              LocaleKeys
                                                  .txtTitleOfOurTermsOfService
                                                  .tr(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: fontFamily,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            verticalMiniSpace,
                                            SizedBox(
                                              height: 350.0,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Text(
                                                  LocaleKeys.onboardingBody
                                                      .tr(),
                                                  textAlign: TextAlign.center,
                                                  style: subTitleSmallStyle,
                                                ),
                                              ),
                                            ),
                                            verticalMiniSpace,
                                            GeneralButton(
                                              title: LocaleKeys.BtnOk.tr(),
                                              onPress: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.txtTitleOfOurTermsOfService.tr(),
                              style: const TextStyle(color: mainColor),
                            ),
                          ),
                          // const Text(
                          //   'And',
                          //   style: subTitleSmallStyle,
                          // ),
                          TextButton(
                            onPressed: () {
                              showPopUp(
                                context,
                                Container(
                                  height: 500,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalMediumSpace,
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              LocaleKeys
                                                  .txtTitleOfOurPrivacyPolicy
                                                  .tr(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: fontFamily,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            verticalMiniSpace,
                                            SizedBox(
                                              height: 350.0,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Text(
                                                  LocaleKeys.onboardingBody
                                                      .tr(),
                                                  textAlign: TextAlign.center,
                                                  style: subTitleSmallStyle,
                                                ),
                                              ),
                                            ),
                                            verticalMiniSpace,
                                            GeneralButton(
                                              title: LocaleKeys.BtnOk.tr(),
                                              onPress: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.txtTitleOfOurPrivacyPolicy.tr(),
                              style: const TextStyle(color: mainColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  horizontalMiniSpace,
                  ConditionalBuilder(
                    condition: state is! AppRegisterLoadingState,
                    builder: (context) => GeneralButton(
                      title: LocaleKeys.BtnSignUp.tr(),
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          cubit.register(
                            name: userNameController.text,
                            nationalID: nationalIdController.text,
                            password: passwordController.text,
                            mobile: mobileController.text,
                            phoneCode: nationalCodeController.text,
                            deviceTokenLogin: deviceToken!,
                          );
                        }
                        cubit.isVisitor = false;
                      },
                    ),
                    fallback: (context) => const Center(
                        child: CircularProgressIndicator.adaptive()),
                  ),
                  verticalMediumSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.registerTxtHaveAccount.tr(),
                        style: subTitleSmallStyle,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.BtnSignIn.tr(),
                          style: titleSmallStyle.copyWith(color: mainColor),
                        ),
                      ),
                    ],
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
