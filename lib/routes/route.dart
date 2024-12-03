import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univ_go/main.dart';
import 'package:univ_go/screens/search/search_result_page.dart';
import 'package:univ_go/screens/search/search_entry.dart';
import 'package:univ_go/screens/auth/login.dart';

const String loginRoute = "/login";
const String searchRoute = "/search";
const String homeRoute = "/home";
const String searchResultRoute = "/search_result";

final TextEditingController searchController = TextEditingController();

var routes = [
  GetPage(name: loginRoute, page: () => const LoginScreen()),
  GetPage(
    name: searchRoute,
    page: () => SearchEntry(searchController: searchController),
  ),
  GetPage(name: homeRoute, page: () => MainPage(), transition: Transition.fade),
  GetPage(
    name: searchResultRoute,
    page: () => SearchResultPage(
      value: (Get.arguments?['value'] as String?) ?? '',
    ),
  ),
];
