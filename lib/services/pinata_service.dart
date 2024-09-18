import 'package:http/http.dart' as http;
import 'dart:convert';

class PinataService {
  static const String _apiKey = '622256431c80c0bebd79';
  static const String _secretApiKey = 'd9034570f179b94197fa5a22cb30581100ba9b2ae9d1afd1d5c33d180fc3bec1';
  static const String _url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

  static Future<String?> uploadToPinata(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(_url));
    
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    
    request.headers.addAll({
      'pinata_api_key': _apiKey,
      'pinata_secret_api_key': _secretApiKey,
    });

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Uploaded to Pinata successfully');
        var responseData = await response.stream.toBytes();
        var result = json.decode(String.fromCharCodes(responseData));
        return result['IpfsHash'];
      } else {
        print('Failed to upload to Pinata');
      }
    } catch (e) {
      print('Error uploading to Pinata: $e');
    }
    return null;
  }
}
