import 'package:bot_toast/bot_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ufarming/controllers/weather_controller.dart';
import 'package:ufarming/models/myplant_model.dart';
import 'package:ufarming/services/plant_service.dart';
import 'package:ufarming/utils/const.dart';
import 'package:ufarming/utils/custom_bot_toast.dart';
import 'package:ufarming/utils/formatting.dart';
import 'package:ufarming/utils/logger.dart';
import 'package:ufarming/utils/shared_preferences.dart';

class HomeController extends GetxController {
  final RxList<MyPlant> myPlants = <MyPlant>[].obs;

  RxString address = ''.obs;
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  RxBool isLoading = true.obs;

  void updateLocation() async {
    BotToast.showLoading();
    Position position = await Geolocator.getCurrentPosition();
    setPosition(position.latitude, position.longitude);
    updateLatLong(position.latitude, position.longitude);
    address.value = await printLocation(position.latitude, position.longitude);

    logger.v(position);
    BotToast.closeAllLoading();
  }

  void initLocation() async {
    Map positions = await getPosition();
    logger.i(positions);
    if (positions['latitude'] != null && positions['longitude'] != null) {
      address.value =
          await printLocation(positions['latitude'], positions['longitude']);
      updateLatLong(positions['latitude'], positions['longitude']);
      address.refresh();
    } else {
      updateLocation();
    }
  }

  void updateLatLong(double latitude, double longitude) {
    Get.find<WeatherController>()
        .fetchData(latitude.toString(), longitude.toString());

    lat.value = latitude;
    long.value = longitude;
  }

  void fetchData() async {
    try {
      await getMyPlants().then((res) {
        if (res is List<MyPlant>) {
          List<MyPlant> sortedRes = res;
          sortedRes
              .sort((a, b) => (a.isDone ? 1 : 0).compareTo(b.isDone ? 1 : 0));
          myPlants.clear();
          myPlants.addAll(sortedRes);
        } else {
          customBotToastText(res);
        }
      });
    } catch (e) {
      customBotToastText(ErrorMessage.general);
    } finally {
      if (isLoading.value) isLoading.toggle();
    }
  }

  void updateFinishTask(String id, int count) {
    MyPlant temp = myPlants[myPlants.indexWhere((v) => v.id == id)]
      ..finishTask = count;
    myPlants[myPlants.indexWhere((v) => v.id == id)] = temp;
  }

  void updatePlantData(String id, MyPlant data) {
    myPlants[myPlants.indexWhere((v) => v.id == id)] = data;
  }

  @override
  void onInit() {
    initLocation();
    fetchData();
    super.onInit();
  }
}
