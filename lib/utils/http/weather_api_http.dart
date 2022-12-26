import 'package:http/http.dart' as http;
import 'package:weather_app/utils/api_keys.dart';

class WeatherApiHttp {
  weatherHttp() {
    final client = http.Client();
    const url =
        'https://api.openweathermap.org/data/2.5/weather?q=bishkek&appid=${ApiKeys.weatherApiKey}';
  }
}
