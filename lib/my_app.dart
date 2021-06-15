import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_memory/auth_widget_builder.dart';
import 'package:flutter_memory/models/user_model.dart';
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:flutter_memory/providers/language_provider.dart';
import 'package:flutter_memory/providers/theme_provider.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/services/firestore_database.dart';
import 'package:flutter_memory/ui/auth/sign_in_screen.dart';
import 'package:flutter_memory/ui/home/home.dart';
import 'package:provider/provider.dart';

import 'Utility/ConnectivityService.dart';
import 'Utility/network_aware_widget.dart';
import 'app_localizations.dart';
import 'constants/app_themes.dart';


class MyApp extends StatelessWidget {

  const MyApp({Key key, this.databaseBuilder}) : super(key: key);

  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        //{context, data, child}
        return Consumer<LanguageProvider>(
          builder: (_, languageProviderRef, __) {
            return AuthWidgetBuilder(
              databaseBuilder: databaseBuilder,
              builder: (BuildContext context,
                  AsyncSnapshot<UserModel> userSnapshot) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  locale: languageProviderRef.appLocale,
                  //List of all supported locales
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('zh', 'CN'),
                  ],
                  //These delegates make sure that the localization data for the proper language is loaded
                  localizationsDelegates: [
                    //A class which loads the translations from JSON files
                    AppLocalizations.delegate,
                    //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                    GlobalMaterialLocalizations.delegate,
                    //Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  //return a locale which will be used by the app
                  localeResolutionCallback: (locale, supportedLocales) {
                    //check if the current device locale is supported or not
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode ||
                          supportedLocale.countryCode == locale?.countryCode) {
                        return supportedLocale;
                      }
                    }
                    //if the locale from the mobile device is not supported yet,
                    //user the first one from the list (in our case, that will be English)
                    return supportedLocales.first;
                  },
                  title: "PreMoApp",
                  // title: Provider.of<Flavor>(context).toString(),
                  routes: Routes.routes,
                  theme: AppThemes.lightTheme,
                  darkTheme: AppThemes.darkTheme,
                  themeMode: themeProviderRef.isDarkModeOn
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  home: StreamProvider<NetworkStatus>(
                    create: (context) =>
                    NetworkStatusService().networkStatusController.stream,

                    child: NetworkAwareWidget(

                      onlineChild: Container(
                        child: Consumer<AuthProvider>(
                          builder: (_, authProviderRef, __) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.active) {

                              return userSnapshot.hasData
                                  ? HomeScreen()
                                  : SignInScreen();
                            }

                            return Material(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                              ),
                            );
                          },
                        ),
                      ),

                      offlineChild:  Scaffold(

                          body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[

                                  Icon(Icons.signal_wifi_off,color: Colors.deepOrange,size: 100,),
                                  Text(
                                    "No internet connection!",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),

                                ],
                              ))
                      ),

                    ),
                  ),


                );
              },
            );
          },
        );
      },
    );
  }
}
// class MyApp extends StatefulWidget {
//   const MyApp({Key key, this.databaseBuilder}) : super(key: key);
//
//   // Expose builders for 3rd party services at the root of the widget tree
//   // This is useful when mocking services while testing
//   final FirestoreDatabase Function(BuildContext context, String uid)
//   databaseBuilder;
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Future<void> _initializeFlutterFireFuture;
//
//   Future<void> _testAsyncErrorOnInit() async {
//     Future<void>.delayed(const Duration(seconds: 2), () {
//       final List<int> list = <int>[];
//       print(list[100]);
//     });
//   }
//
//   // Define an async function to initialize FlutterFire
//   Future<void> _initializeFlutterFire() async {
//     // Wait for Firebase to initialize
//     await Firebase.initializeApp();
//
//     if (_kTestingCrashlytics) {
//       // Force enable crashlytics collection enabled if we're testing it.
//       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//     } else {
//       // Else only enable it in non-debug builds.
//       // You could additionally extend this to allow users to opt-in.
//       await FirebaseCrashlytics.instance
//           .setCrashlyticsCollectionEnabled(!kDebugMode);
//     }
//
//     // Pass all uncaught errors to Crashlytics.
//     Function originalOnError = FlutterError.onError;
//     FlutterError.onError = (FlutterErrorDetails errorDetails) async {
//       await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
//       // Forward to original handler.
//       originalOnError(errorDetails);
//     };
//
//     if (_kShouldTestAsyncErrorOnInit) {
//       await _testAsyncErrorOnInit();
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     _initializeFlutterFireFuture = _initializeFlutterFire();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (_, themeProviderRef, __) {
//         //{context, data, child}
//         return Consumer<LanguageProvider>(
//           builder: (_, languageProviderRef, __) {
//             return AuthWidgetBuilder(
//               databaseBuilder: widget.databaseBuilder,
//               builder: (BuildContext context,
//                   AsyncSnapshot<UserModel> userSnapshot) {
//                 return MaterialApp(
//                   debugShowCheckedModeBanner: false,
//                   locale: languageProviderRef.appLocale,
//                   //List of all supported locales
//                   supportedLocales: [
//                     Locale('en', 'US'),
//                     Locale('zh', 'CN'),
//                   ],
//                   //These delegates make sure that the localization data for the proper language is loaded
//                   localizationsDelegates: [
//                     //A class which loads the translations from JSON files
//                     AppLocalizations.delegate,
//                     //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
//                     GlobalMaterialLocalizations.delegate,
//                     //Built-in localization for text direction LTR/RTL
//                     GlobalWidgetsLocalizations.delegate,
//                   ],
//                   //return a locale which will be used by the app
//                   localeResolutionCallback: (locale, supportedLocales) {
//                     //check if the current device locale is supported or not
//                     for (var supportedLocale in supportedLocales) {
//                       if (supportedLocale.languageCode ==
//                           locale?.languageCode ||
//                           supportedLocale.countryCode == locale?.countryCode) {
//                         return supportedLocale;
//                       }
//                     }
//                     //if the locale from the mobile device is not supported yet,
//                     //user the first one from the list (in our case, that will be English)
//                     return supportedLocales.first;
//                   },
//                   title: Provider.of<Flavor>(context).toString(),
//                   routes: Routes.routes,
//                   theme: AppThemes.lightTheme,
//                   darkTheme: AppThemes.darkTheme,
//                   themeMode: themeProviderRef.isDarkModeOn
//                       ? ThemeMode.dark
//                       : ThemeMode.light,
//                   home: StreamProvider<NetworkStatus>(
//                     create: (context) =>
//                     NetworkStatusService().networkStatusController.stream,
//
//                     child: NetworkAwareWidget(
//
//                       onlineChild: Container(
//                         child: Consumer<AuthProvider>(
//                           builder: (_, authProviderRef, __) {
//                             if (userSnapshot.connectionState ==
//                                 ConnectionState.active) {
//
//                               return userSnapshot.hasData
//                                   ? HomeScreen()
//                                   : SignInScreen();
//                             }
//
//                             return Material(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       offlineChild:  Scaffold(
//
//                           body: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//
//                                 children: <Widget>[
//
//                                   Icon(Icons.signal_wifi_off,color: Colors.deepOrange,size: 100,),
//                                   Text(
//                                     "No internet connection!",
//                                     style: TextStyle(
//                                         color: Colors.blueGrey,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20.0),
//                                   ),
//
//                                 ],
//                               ))
//                       ),
//
//                     ),
//                   ),
//
//
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }






