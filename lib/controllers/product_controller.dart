import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/services/image_uploader.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';

class ProductController extends GetxController {
  final uno = Uno();
  var products;
  saveProduct({data, context, pickedImage}) async {
    final product = {
      'id': '',
      'name': data['name'].toString(),
      'description': data['description'].toString(),
      'price': data['price'],
      'img': data['img'].toString(),
    };
    try {
      await uno.post('${baseUrl}/product', data: product).then((response) {
        var res = ImageUploader().patchImage(
            '$baseUrl/upload-img/${response.data['id']}', pickedImage!.path);
        productList();
        const SnackbarMenssage().nasckProductSuccess(context);
      }).catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  productList() async {
    products = await uno.get('${baseUrl}/products');
    return products;
  }

  productDelete(id) async {
    var response = await uno.delete('${baseUrl}/products/${id}');
    return response;
  }
}
