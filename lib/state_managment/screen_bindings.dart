import 'package:get/get.dart';
import 'package:trucklink/state_managment/admincontroller/admin_controller.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';
import 'package:trucklink/state_managment/drivercontroller/trip_controller.dart';
import 'package:trucklink/state_managment/usercontroller/userauth_controller.dart';
import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';

class ScreenBindings extends Bindings {
  @override
  void dependencies() {
    //driver controllers
    Get.put(() => AuthController());
    Get.put(() => TripController());
    // other user controllers
    Get.put(() => UserAuthController());
    Get.put(() => UserTripController());
    //admin controller
    Get.put(() => AdiminAuthController());
  }
}
