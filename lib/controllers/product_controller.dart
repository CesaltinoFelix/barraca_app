import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/services/image_uploader.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';

class ProductController extends GetxController {
  final UserController userController = Get.put(UserController());
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
      String userId = await userController.loadData('id');
      await uno
          .post('${baseUrl}/product/${userId}', data: product)
          .then((response) {
        if (pickedImage!.path != null) {
          var res = ImageUploader().patchImage(
              '$baseUrl/upload-img/${response.data['id']}', pickedImage!.path);
          productList();
        }
      }).catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  updateProduct({data, id, context, pickedImage}) async {
    print(id);
    final product = {
      'name': data['name'].toString(),
      'description': data['description'].toString(),
      'price': data['price'],
      'img': data['img'].toString(),
    };
    try {
      await uno
          .post('${baseUrl}/product-update/$id', data: product)
          .then((response) {
        if (pickedImage!.path != null) {
          var res = ImageUploader()
              .patchImage('$baseUrl/upload-img/$id', pickedImage!.path);
          productList();
        }
      }).catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  productList() async {
    String userId = await userController.loadData('id');
    products = await uno.get('${baseUrl}/products-user/${userId}');
    return products;
  }

  productDelete(id) async {
    var response = await uno.delete('${baseUrl}/products/${id}');
    return response;
  }
}
