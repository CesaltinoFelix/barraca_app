import 'package:get/get.dart';

class UserController extends GetxController {
  // Observáveis para os dados do usuário
  RxString id = ''.obs;
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxBool isLoggedIn = false.obs;
  RxString img = ''.obs;

  // Método para fazer o login do usuário
  void login(String id, String username, String email, String img) {
    // Salva os dados do usuário na memória
    this.username.value = username;
    this.email.value = email;
    isLoggedIn.value = true;
  }

  // Método para fazer o logout do usuário
  void logout() {
    // Limpa os dados do usuário da memória
    username.value = '';
    email.value = '';
    isLoggedIn.value = false;
  }
}
