import 'package:get/get.dart';
import 'package:univ_go/screens/news/news_detail.dart';
import 'package:univ_go/services/home/top_campus_provider.dart';
import 'package:univ_go/services/home/news_latest.dart';
import 'package:univ_go/services/news/news_provider.dart';

class HomeController extends GetxController {
  var ptnList = <Ptn>[].obs; 
  var politeknikList = <Ptn>[].obs; 
  var swastaList = <Ptn>[].obs; 
  var latestNews = <Berita>[].obs; 

  @override
  void onInit() {
    super.onInit();
    getPtnData(); 
    getPoliteknikData(); 
    getSwastaData(); 
    getLatestNews(); 
  }

  
  void getPtnData() async {
    try {
      var result = await TopCampusProvider().getPtn();
      ptnList.value = result; 
    } catch (e) {
      print('Error fetching PTN data: $e');
    }
  }

  
  void getPoliteknikData() async {
    try {
      var result = await TopCampusProvider().getPoliteknik();
      politeknikList.value = result; 
    } catch (e) {
      print('Error fetching Politeknik data: $e');
    }
  }

  
  void getSwastaData() async {
    try {
      var result = await TopCampusProvider().getSwasta();
      swastaList.value = result; 
    } catch (e) {
      print('Error fetching Swasta data: $e');
    }
  }

  
  void getLatestNews() async {
    try {
      var result = await NewsLatest().getBerita();
      latestNews.value = result; 
    } catch (e) {
      print('Error fetching latest news: $e');
    }
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
