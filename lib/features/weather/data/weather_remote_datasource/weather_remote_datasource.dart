import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home1/features/weather/data/weather_models/weather_model.dart';

class WeatherRemoteDatasource {
  // ✅ SIZNING YANGI KEY
  final String apikey = "c317f74b233c4cacb93132712252701";
  final String baseUrl = "https://api.weatherapi.com/v1";

  // ✅ Current Weather
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    // WeatherAPI.com lat/lon yoki city name qabul qiladi
    final query = "$lat,$lon"; // yoki "Samarkand"

    final url = Uri.parse(
      '$baseUrl/current.json?key=$apikey&q=$query&lang=uz',
    );

    print('🌍 ===== WEATHERAPI CURRENT REQUEST =====');
    print('🔗 URL: $url');
    print('🔑 API KEY: $apikey');
    print('📍 Query: $query');

    try {
      final response = await http.get(url);

      print('📡 STATUS CODE: ${response.statusCode}');
      print('📦 RESPONSE LENGTH: ${response.body.length} chars');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        print('✅ Current weather parsed successfully!');
        print('   City: ${json["location"]["name"]}');
        print('   Temp: ${json["current"]["temp_c"]}°C');
        
        return WeatherModel.fromWeatherApiCurrent(json);
      } else if (response.statusCode == 401) {
        print('❌ 401 UNAUTHORIZED - API key invalid!');
        print('🔑 Your key: $apikey');
        print('💡 Check: https://www.weatherapi.com/my/');
        throw Exception('API key noto\'g\'ri');
      } else if (response.statusCode == 400) {
        print('❌ 400 BAD REQUEST');
        print('📦 Response: ${response.body}');
        throw Exception('Noto\'g\'ri so\'rov parametrlari');
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('📦 Response: ${response.body}');
        throw Exception('Ob-havo yuklashda xatolik: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ ===== ERROR IN getCurrentWeather =====');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }

  // ✅ 7-Day Forecast
  Future<List<WeatherModel>> get7daysForecast(double lat, double lon) async {
    final query = "$lat,$lon";

    final url = Uri.parse(
      '$baseUrl/forecast.json?key=$apikey&q=$query&days=7&lang=uz',
    );

    print('🌍 ===== WEATHERAPI FORECAST REQUEST =====');
    print('🔗 URL: $url');
    print('🔑 API KEY: $apikey');
    print('📍 Query: $query');

    try {
      final response = await http.get(url);

      print('📡 STATUS CODE: ${response.statusCode}');
      print('📦 RESPONSE LENGTH: ${response.body.length} chars');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final location = data["location"] as Map<String, dynamic>;
        final cityName = location["name"] as String;
        final forecast = data["forecast"] as Map<String, dynamic>;
        final forecastDays = forecast["forecastday"] as List;

        print('🏙️  City: $cityName');
        print('📊 Forecast days: ${forecastDays.length}');

        final List<WeatherModel> dailyForecast = [];

        for (var day in forecastDays) {
          final model = WeatherModel.fromWeatherApiForecast(
            day as Map<String, dynamic>,
            cityName,
          );
          dailyForecast.add(model);
          
          print('✅ Day ${dailyForecast.length}: ${model.date} - ${model.temperature}°C');
        }

        print('✅ Successfully parsed ${dailyForecast.length} days forecast');
        return dailyForecast;
      } else if (response.statusCode == 401) {
        print('❌ 401 UNAUTHORIZED');
        throw Exception('API key noto\'g\'ri');
      } else if (response.statusCode == 400) {
        print('❌ 400 BAD REQUEST');
        print('📦 Response: ${response.body}');
        throw Exception('Noto\'g\'ri so\'rov');
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        throw Exception('Forecast yuklashda xatolik: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ ===== ERROR IN get7daysForecast =====');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }
}