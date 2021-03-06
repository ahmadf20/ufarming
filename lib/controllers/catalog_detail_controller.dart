import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ufarming/controllers/home_controller.dart';
import 'package:ufarming/models/activity_model.dart';
import 'package:ufarming/models/myplant_model.dart';
import 'package:ufarming/models/plant_detail_model.dart';
import 'package:ufarming/services/plant_service.dart';
import 'package:ufarming/utils/const.dart';
import 'package:ufarming/utils/custom_bot_toast.dart';

class CatalogDetailController extends GetxController {
  final Rx<PlantDetail> plant = PlantDetail().obs;
  String id;
  RxBool isLoading = true.obs;

  TextEditingController controller = TextEditingController();

  CatalogDetailController(this.id);

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    try {
      await getPlant(id).then((res) {
        if (res is PlantDetail) {
          updateData(res);
        } else {
          customBotToastText(res);
        }
      });
    } catch (e) {
      customBotToastText(ErrorMessage.general);
    } finally {
      isLoading.toggle();
    }
  }

  void addMyPlantHandler() async {
    try {
      BotToast.showLoading();
      await addMyPlant(id, controller.text).then((res) async {
        if (res is MyPlant) {
          await postDefaultChecklist(res.id).then((v) {
            if (v is List<Activity>) {
              Get.find<HomeController>().fetchData();
              Get.back();
              Get.back();
            }
          });
        }
      });
    } catch (e) {
      customBotToastText(ErrorMessage.general);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  updateData(PlantDetail newPlant) {
    plant.update((val) {
      val.article = newPlant.article;
      val.plant = newPlant.plant;
      val.statistic = newPlant.statistic;
    });
  }
}
