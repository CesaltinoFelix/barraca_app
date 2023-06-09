import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  // Observáveis para os dados do usuário
  RxString id = ''.obs;
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxBool isLoggedIn = false.obs;
  RxString img = ''.obs;

  // Método para fazer o login do usuário

  void verifyLogin() async {
    String id = await loadData('id');
    String name = await loadData('name');
    String email = await loadData('email');
    String img = await loadData('img');
    if (id != '') {
      username.value = name;
      this.email.value = email;
      this.id.value = id;
      this.img.value = img;
      isLoggedIn.value = true;
    }
  }

  void login(String id, String username, String email, String img) async {
    // Salva os dados do usuário na memória
    this.username.value = username;
    this.email.value = email;
    this.id.value = id;
    this.img.value = img;
    isLoggedIn.value = true;

    await saveData('id', id);
    await saveData('name', username);
    await saveData('email', email);
    await saveData('img', img);
  }

  // Método para fazer o logout do usuário
  void logout() async {
    // Limpa os dados do usuário da memória
    username.value = '';
    email.value = '';
    id.value = '';
    img.value = '';
    isLoggedIn.value = false;

    await deleteData('id');
    await deleteData('name');
    await deleteData('email');
    await deleteData('img');
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

// Pegando dados do usuarios no localstorage
  Future<String> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key) ?? '';
    return value;
  }

  Future<void> deleteData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

// Salvando dados do usuario no localstorage

