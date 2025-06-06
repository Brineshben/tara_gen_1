import 'package:get/get.dart';
import 'package:ihub/Controller/AddEmployeeController.dart';
import 'package:ihub/Controller/AddEmployeeDetailController.dart';
import 'package:ihub/Controller/CustomerDetails_Controller.dart';
import 'package:ihub/Controller/charge_screen_controller.dart';
import 'package:ihub/Controller/description_controller.dart';
import 'package:ihub/Controller/language_controller.dart';
import 'package:ihub/Controller/no_internet_controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/speed/controller/speed_controller.dart';

import '../Controller/Backgroud_controller.dart';
import '../Controller/EnquiryListController.dart';
import '../Controller/EnquirySubListModel.dart';
import '../Controller/FulltourController.dart';
import '../Controller/Ipcontroller.dart';
import '../Controller/Login_api_controller.dart';
import '../Controller/Nav_description_controller.dart';
import '../Controller/Navigate_Controller.dart';
import '../Controller/PasswordController.dart';
import '../Controller/Response_Nav_Controller.dart';
import '../Controller/RobotresponseApi_controller.dart';
import '../Controller/SessionId_controller.dart';
import '../Controller/Session_Controller.dart';
import '../Controller/Volume_Controller.dart';
import '../Controller/batteryOfflineController.dart';
import '../Controller/battery_Controller.dart';
import '../Controller/update_status_controller.dart';

class HandleControllers {
  static createGetControllers() {
    Get.put(UserAuthController());
    Get.put(RobotresponseapiController());
    Get.put(BackgroudController());
    Get.put(SessionController());
    Get.put(CustomerdetailsController());
    Get.put(UpdateStatusController());
    Get.put(SessionIDController());
    Get.put(BatteryController());
    Get.put(Enquirylistcontroller());
    Get.put(NavigateController());
    Get.put(AddEmployeeController());
    Get.put(AddEmployeeDetailsController());
    Get.put(EnquirySubListController());
    Get.put(Passwordcontroller());
    Get.put(VolumeController());
    Get.put(ResponseNavController());
    Get.put(IpController());
    Get.put(FullTourControllerNew());
    Get.put(NavigateDescriptionController());
    Get.put(BatteryOfflineController());
    Get.put(ChargeScreenController());
    Get.put(DescriptionController());
    Get.put(PromptController());
    Get.put(SpeedController());
    Get.put(ConnectivityController());
    Get.put(LanguageController());
  }

  static deleteAllGetControllers() async {
    await Get.delete<UserAuthController>();
    await Get.delete<RobotresponseapiController>();
    await Get.delete<BackgroudController>();
    await Get.delete<SessionController>();
    await Get.delete<CustomerdetailsController>();
    await Get.delete<UpdateStatusController>();
    await Get.delete<SessionIDController>();
    await Get.delete<BatteryController>();
    await Get.delete<Enquirylistcontroller>();
    await Get.delete<NavigateController>();
    await Get.delete<AddEmployeeController>();
    await Get.delete<AddEmployeeDetailsController>();
    await Get.delete<EnquirySubListController>();
    await Get.delete<VolumeController>();
    await Get.delete<ResponseNavController>();
    await Get.delete<IpController>();
    await Get.delete<FullTourControllerNew>();
    await Get.delete<NavigateDescriptionController>();
    await Get.delete<BatteryOfflineController>();
    await Get.delete<ChargeScreenController>();
    await Get.delete<DescriptionController>();
    await Get.delete<PromptController>();
    await Get.delete<SpeedController>();
    await Get.delete<LanguageController>();
    await Get.delete<ConnectivityController>();
  }
}
