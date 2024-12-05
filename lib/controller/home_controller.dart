import 'package:get/get.dart';
import 'package:univ_go/services/home/top_campus_provider.dart'; // Ganti dengan path yang benar

class HomeController extends GetxController {
  var ptnList = <Ptn>[].obs; // List of PTN yang akan dikelola
  var politeknikList = <Ptn>[].obs; // List of Politeknik
  var swastaList = <Ptn>[].obs; // List of Swasta

  @override
  void onInit() {
    super.onInit();
    getPtnData(); // Memanggil fungsi getPtn() saat controller diinisialisasi
    getPoliteknikData(); // Memanggil fungsi getPoliteknik() saat controller diinisialisasi
    getSwastaData(); // Memanggil fungsi getSwasta() saat controller diinisialisasi
  }

  // Fungsi untuk mengambil data PTN
  void getPtnData() async {
    try {
      var result = await TopCampusProvider().getPtn();
      ptnList.value = result; // Mengupdate nilai ptnList
    } catch (e) {
      print('Error fetching PTN data: $e');
    }
  }

  // Fungsi untuk mengambil data Politeknik
  void getPoliteknikData() async {
    try {
      var result = await TopCampusProvider().getPoliteknik();
      politeknikList.value = result; // Mengupdate nilai politeknikList
    } catch (e) {
      print('Error fetching Politeknik data: $e');
    }
  }

  // Fungsi untuk mengambil data Swasta
  void getSwastaData() async {
    try {
      var result = await TopCampusProvider().getSwasta();
      swastaList.value = result; // Mengupdate nilai swastaList
    } catch (e) {
      print('Error fetching Swasta data: $e');
    }
  }
}
