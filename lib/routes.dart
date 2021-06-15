import 'package:flutter/material.dart';
import 'package:flutter_memory/main_screen.dart';
import 'package:flutter_memory/ui/auth/forget_password_screen.dart';
import 'package:flutter_memory/ui/auth/register_screen.dart';
import 'package:flutter_memory/ui/auth/sign_in_screen.dart';
import 'package:flutter_memory/ui/memories_ui/add_blog_screen.dart';
import 'package:flutter_memory/ui/memories_ui/add_nominee_screen.dart';
import 'package:flutter_memory/ui/memories_ui/add_quotes.dart';
import 'package:flutter_memory/ui/memories_ui/app_setting_manage.dart';
import 'package:flutter_memory/ui/memories_ui/cherishedMemories.dart';
import 'package:flutter_memory/ui/memories_ui/edit_blog_screen.dart';
import 'package:flutter_memory/ui/memories_ui/gallery_screen.dart';
import 'package:flutter_memory/ui/memories_ui/nominee_list_screen.dart';
import 'package:flutter_memory/ui/memories_ui/profile_screen_edit.dart';
import 'package:flutter_memory/ui/memories_ui/quotesScreen.dart';
import 'package:flutter_memory/ui/memories_ui/userListDisclosingDate.dart';
import 'package:flutter_memory/ui/memories_ui/user_list.dart';
import 'package:flutter_memory/ui/memories_ui/view_user_details_screen.dart';
import 'package:flutter_memory/ui/splash/splash_screen.dart';

import 'Utility/bottom_navigation_bar.dart';
import 'ui/setting/setting_screen.dart';
class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset_password';
  static const String home = '/home';
  static const String home1 = '/home1';
  static const String setting = '/setting';
  static const String create_edit_blog = '/create_edit_blog';
  static const String quoteList = '/quotelist';
  static const String create_edit_quote = '/create_edit_quote';
  static const String create_edit_nominee = '/create_edit_nominee';
  static const String nomineeList = '/nomineeList';
  static const String profile = '/profile';
  static const String cherishedMemories = '/cherishedMemories';
  static const String gallery = '/gallery';
  static const String bottomNavigation = '/bottomNavigation';
  static const String dashboard = '/dashboard';
  static const String adminSetting = '/adminSetting';
  static const String editBlog = '/editBlog';
  static const String userList = '/userList';
  static const String userDisclosureDateList = '/userDisclosureDateList';
  static const String viewUserDetails = '/viewUserDetails';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    register: (BuildContext context) => RegisterScreen(),
    home: (BuildContext context) => BottomNavigationBarWidget(pageIndex: 0),
    // dashboard: (BuildContext context) => BlogScreen(),
    setting: (BuildContext context) => SettingScreen(),
    create_edit_blog: (BuildContext context) => CreateEditBlogScreen(),
    quoteList: (BuildContext context) => QuotesScreen(),
    create_edit_quote: (BuildContext context) => AddQuoteScreen(quote: null,),
    nomineeList: (BuildContext context) => NomineeListScreen(),
    create_edit_nominee: (BuildContext context) => AddNomineeScreen(nominee: null),
    cherishedMemories: (BuildContext context) => CherishedScreen(),
    gallery: (BuildContext context) => GalleryScreen(),
    profile: (BuildContext context) => ProfilePage(),
    resetPassword: (BuildContext context) => ForgotPasswordScreen(),
    home1: (BuildContext context) => MainScreen(),
    adminSetting: (BuildContext context) => AppSettingsScreen(),
    editBlog: (BuildContext context) => EditBlogScreen(blog: null),
    userList: (BuildContext context) => UserListScreen(),
    userDisclosureDateList: (BuildContext context) => UserListDateScreen(),
    viewUserDetails: (BuildContext context) => ViewUserDetailsScreen(user: null,),
  };
}
