import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hq/cubit/cubit.dart';
import 'package:hq/screens/intro_screens/startup/splash_screen.dart';
import 'package:hq/shared/bloc_observer.dart';
import 'package:hq/shared/network/local/cache_helper.dart';
import 'package:hq/shared/network/local/const_shared.dart';
import 'package:hq/shared/network/remote/dio_helper.dart';
import 'package:hq/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:hq/translations/codegen_loader.g.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // If we're in debug mode, use the normal error widget which shows the error
    // message:
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    // In release builds, show a yellow-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator.adaptive(),
      // Text(
      //   'Error!\n${details.exception}',
      //   style: const TextStyle(color: Colors.yellow),
      //   textAlign: TextAlign.center,
      // ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DioHelper.init();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  deviceToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('deviceToken : $deviceToken ');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('onMessage message.data.toString() ${message.data.toString()}');
    }
    // showToast(msg: 'on Message', state: ToastState.success);
    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;

    if (message.data['message'] == 'ReservationScreen') {
      if (kDebugMode) {
        print('message Reservation Screen');
      }
    }
  });

  void permission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // headsup notification in IOS
        badge: true,
        sound: true,
      );
    } else {
      //close the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (kDebugMode) {
      print(
          'onMessageOpenedApp event.data.toString() ${event.data.toString()}');
    }
    if (event.data['message'] == 'ReservationScreen') {
      if (kDebugMode) {
        print('message Reservation Screen');
      }
    }
    // showToast(msg: 'on Message Opened App', state: ToastState.success);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // token = CacheHelper.getData(key: 'token');
  // verified = CacheHelper.getData(key: 'verified');
  // if(sharedLanguage != null) {
  //   sharedLanguage = CacheHelper.getData(key: "local");
  // }else{
  //   sharedLanguage = 'en';
  // }
  BlocOverrides.runZoned(
    () {
      if (Platform.isIOS || Platform.isAndroid) {
        /// IOS || Android check permission
        permission();
      }
      runApp(
        EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: const MyApp(
            startWidget: SplashScreen(),
          ),
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('on background message');
    print(message.data.toString());
  }
  // showToast(msg: 'on background message', state: ToastState.success);
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    super.key,
    required this.startWidget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()..getCarouselData()),
        BlocProvider(create: (BuildContext context) => AppTechCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates +
            [
              CountryLocalizations.delegate,
            ],
        home: startWidget,
      ),
    );
  }
}
