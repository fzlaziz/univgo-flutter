import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/src/app.dart';
import 'package:univ_go/src/features/home/controller/home_controller.dart';
import 'package:univ_go/src/features/search/controller/search_result_controller.dart';
import 'package:univ_go/src/features/auth/screens/login.dart';
import 'package:univ_go/src/features/auth/screens/register.dart';
import 'package:univ_go/src/features/news/screens/news_list.dart';
import 'package:univ_go/src/features/search/screens/search_result_page.dart';
import 'package:univ_go/src/features/search/screens/search_entry.dart';
import 'package:univ_go/src/features/splashscreen/splashscreen.dart';

const String loginRoute = "/login";
const String searchRoute = "/search";
const String homeRoute = "/home";
const String searchResultRoute = "/search_result";

final TextEditingController searchController = TextEditingController();

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final prefs = Get.find<SharedPreferences>();
    final token = prefs.get("token");
    if (token != null) {
      return const RouteSettings(name: homeRoute);
    }
    return null;
  }
}

final routes = [
  GetPage(
    name: searchRoute,
    page: () => SearchEntry(searchController: searchController),
  ),
  GetPage(
      name: homeRoute,
      page: () => const MainPage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
      transition: Transition.fade),
  GetPage(
    name: '/search-result',
    page: () => const SearchResultPage(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => SearchResultController());
    }),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.noTransition,
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterScreen(),
    middlewares: [AuthMiddleware()],
    transition: Transition.noTransition,
  ),
  GetPage(
    name: '/splashscreen',
    page: () => const SplashScreen(),
  ),
  GetPage(name: '/news_list', page: () => const NewsList()),
];
