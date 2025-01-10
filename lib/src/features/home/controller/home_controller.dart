import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/src/features/home/models/nearest_campus_response.dart';
import 'package:univ_go/src/features/news/models/news.dart';
import 'package:univ_go/src/features/news/models/news_detail.dart';
import 'package:univ_go/src/features/news/screens/news_detail.dart';
import 'package:univ_go/src/features/home/services/nearest_campus_provider.dart';
import 'package:univ_go/src/features/home/services/top_campus_provider.dart';
import 'package:univ_go/src/features/home/services/news_latest_provider.dart';
import 'package:univ_go/src/services/location_service.dart';
import 'package:univ_go/src/features/news/services/news_provider.dart';

class HomeController extends GetxController {
  var ptnList = <Ptn>[].obs;
  var politeknikList = <Ptn>[].obs;
  var swastaList = <Ptn>[].obs;
  var latestNews = <Berita>[].obs;
  final RxList<NearestCampusResponse> recommendedCampuses =
      <NearestCampusResponse>[].obs;
  final locationService = LocationService(Get.context!);
  final RxBool isLocationReady = false.obs;
  final RxBool isLocationDenied = false.obs;

  // Cache duration constants
  static const campusCacheDuration = Duration(minutes: 1);
  static const newsCacheDuration = Duration(minutes: 1);
  static const locationThreshold = 0.01; // Roughly 1km difference

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    await loadCachedData();
    await refreshDataIfNeeded();
  }

  Future<void> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load recommended campuses
    final recommendedTime = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('recommendedTimestamp') ?? 0);
    if (DateTime.now().difference(recommendedTime) < campusCacheDuration) {
      final cachedRecommended = prefs.getString('recommendedCampuses');
      if (cachedRecommended != null) {
        List<dynamic> jsonList = jsonDecode(cachedRecommended);
        recommendedCampuses.value = jsonList
            .map((json) => NearestCampusResponse.fromJson(json))
            .toList();
      }
    }

    // Load campus data
    final campusDataTime = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('campusDataTimestamp') ?? 0);

    if (DateTime.now().difference(campusDataTime) < campusCacheDuration) {
      final cachedTopCampus = prefs.getString('topCampusData');
      if (cachedTopCampus != null) {
        final topCampusData =
            TopCampusList.fromJson(jsonDecode(cachedTopCampus));
        ptnList.value = topCampusData.ptn;
        politeknikList.value = topCampusData.politeknik;
        swastaList.value = topCampusData.swasta;
      }
    }

    // Load news
    final newsTime =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('newsTimestamp') ?? 0);
    if (DateTime.now().difference(newsTime) < newsCacheDuration) {
      final cachedNews = prefs.getString('latestNews');
      if (cachedNews != null) {
        List<dynamic> jsonList = jsonDecode(cachedNews);
        latestNews.value =
            jsonList.map((json) => Berita.fromJson(json)).toList();
      }
    }
  }

  Future<void> refreshDataIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    // Initialize location and recommended campuses
    await initializeLocation();

    // Check campus data cache
    final lastCampusRefresh = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('campusDataTimestamp') ?? 0);
    if (DateTime.now().difference(lastCampusRefresh) > campusCacheDuration) {
      await getAllCampusData();
    }

    // Check news cache
    final lastNewsRefresh =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('newsTimestamp') ?? 0);
    if (DateTime.now().difference(lastNewsRefresh) > newsCacheDuration) {
      await getLatestNews();
    }
  }

  Future<bool> shouldUpdateLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final oldLat = prefs.getDouble('lastLatitude');
    final oldLng = prefs.getDouble('lastLongitude');
    final currentLat = prefs.getDouble('userLatitude');
    final currentLng = prefs.getDouble('userLongitude');

    if (oldLat == null || oldLng == null) return true;
    if (currentLat == null || currentLng == null) return true;

    return (oldLat - currentLat).abs() > locationThreshold ||
        (oldLng - currentLng).abs() > locationThreshold;
  }

  Future<void> initializeLocation() async {
    try {
      await locationService.loadUserLocation();
      final hasPermission = await locationService.hasLocationPermission();

      if (hasPermission) {
        await locationService.updateLocation();
        isLocationReady.value = true;

        if (true) {
          await fetchRecommendedCampuses();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble(
              'lastLatitude', prefs.getDouble('userLatitude') ?? 0);
          await prefs.setDouble(
              'lastLongitude', prefs.getDouble('userLongitude') ?? 0);
        }
      } else {
        isLocationDenied.value = true;
        await fetchDefaultRecommendations();
      }
    } catch (e) {
      print('Error initializing location: $e');
      isLocationDenied.value = true;
      await fetchDefaultRecommendations();
    }
  }

  Future<void> getAllCampusData() async {
    try {
      final result = await TopCampusProvider().getAllCampuses();
      ptnList.value = result.ptn;
      politeknikList.value = result.politeknik;
      swastaList.value = result.swasta;

      // Cache the results
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('topCampusData', jsonEncode(result.toJson()));
      await prefs.setInt(
          'campusDataTimestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error fetching campus data: $e');
    }
  }

  Future<void> getLatestNews() async {
    try {
      var result = await NewsLatest().getBerita();
      latestNews.value = result;

      // Cache the results
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'latestNews', jsonEncode(result.map((e) => e.toJson()).toList()));
      await prefs.setInt(
          'newsTimestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error fetching latest news: $e');
    }
  }

  Future<void> fetchRecommendedCampuses() async {
    if (!isLocationReady.value) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      double? userLatitude = prefs.getDouble('userLatitude');
      double? userLongitude = prefs.getDouble('userLongitude');

      if (userLatitude == null || userLongitude == null) {
        await fetchDefaultRecommendations();
        return;
      }

      var campusService = NearestCampusProvider();
      var campuses = await campusService.getCampusesNearby(
          latitude: userLatitude, longitude: userLongitude);

      recommendedCampuses.value = campuses.take(4).toList();

      // Cache the results
      await prefs.setString('recommendedCampuses',
          jsonEncode(recommendedCampuses.map((e) => e.toJson()).toList()));
      await prefs.setInt(
          'recommendedTimestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error fetching recommended campuses: $e');
      await fetchDefaultRecommendations();
    }
  }

  Future<void> fetchDefaultRecommendations() async {
    try {
      double userLatitude = -7.051834727886331;
      double userLongitude = 110.4410954478625;
      var campusService = NearestCampusProvider();
      var campuses = await campusService.getCampusesNearby(
          latitude: userLatitude, longitude: userLongitude);

      recommendedCampuses.value = campuses.take(4).toList();

      // Cache the results
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('recommendedCampuses',
          jsonEncode(recommendedCampuses.map((e) => e.toJson()).toList()));
      await prefs.setInt(
          'recommendedTimestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error fetching default recommendations: $e');
      recommendedCampuses.value = [];
    }
  }

  // Force refresh all data
  Future<void> refreshAll() async {
    await getAllCampusData();
    await getLatestNews();
    await initializeLocation();
  }

  RxBool isNavigating = false.obs;

  Future<void> navigateToDetail(int beritaId) async {
    if (!isNavigating.value) {
      isNavigating.value = true;
      try {
        final NewsProvider apiDataProvider = NewsProvider();
        DetailBerita detailBerita =
            await apiDataProvider.getDetailBerita(beritaId);

        Get.to(() => NewsDetail(berita: detailBerita));
      } catch (e) {
        print('Error fetching detail: $e');
      } finally {
        isNavigating.value = false;
      }
    }
  }
}
