import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_go/controller/search_result_controller.dart';
import 'package:univ_go/main.dart';
import 'package:univ_go/screens/auth/login.dart';
import 'package:univ_go/screens/auth/register.dart';
import 'package:univ_go/screens/search/search_result_page.dart';
import 'package:univ_go/screens/search/search_entry.dart';
import 'package:univ_go/screens/splashscreen/splashscreen.dart';

const String loginRoute = "/login";
const String searchRoute = "/search";
const String homeRoute = "/home";
const String searchResultRoute = "/search_result";

final TextEditingController searchController = TextEditingController();

var routes = [
  // GetPage(name: loginRoute, page: () => const LoginScreen()),
  GetPage(
    name: searchRoute,
    page: () => SearchEntry(searchController: searchController),
  ),
  GetPage(name: homeRoute, page: () => MainPage(), transition: Transition.fade),
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
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterScreen(), // Sesuaikan dengan nama class register Anda
  ),
  GetPage(
    name: '/splashscreen',
    page: () => const SplashScreen(), // Sesuaikan dengan nama class register Anda
  ),
];
