import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyAmeP5BeS_i4vmxvHksVV5M38Tankk3Mc4';

class LocationHelper {
  static String generateLocationPreviewImage({
    double longtitude,
    double latitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longtitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longtitude&key=$GOOGLE_API_KEY';
  }

  // DOCUMENT REFERENCE:
  // https://developers.google.com/maps/documentation/geocoding/start#reverse
  static Future<String> getPlaceAddress(
    double lat,
    double lng,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
