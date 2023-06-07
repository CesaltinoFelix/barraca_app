import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/services/image_uploader.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';

class SaleController extends GetxController {
  final uno = Uno();
  var sales;
  saveSales({data, context}) async {
    try {
      await uno.post('${baseUrl}/sales', data: data).then((response) {
        const SnackbarMenssage().nasckSalesSuccess(context);
      }).catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }
}
