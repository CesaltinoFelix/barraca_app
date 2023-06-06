import 'package:http/http.dart' as http;

class ImageUploader {
  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    var response = request.send();
    return response;
  }
}
