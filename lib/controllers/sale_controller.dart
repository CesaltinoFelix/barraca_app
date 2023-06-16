import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';

class SaleController extends GetxController {
  final UserController userController = Get.put(UserController());

  final uno = Uno();
  var sales;
  saveSales({data, context}) async {
    try {
      String userId = await userController.loadData('id');
      data['userId'] = userId;

      await uno
          .post('${baseUrl}/sales', data: data)
          .then((response) {})
          .catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }
}
