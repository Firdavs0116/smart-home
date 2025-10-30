import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home1/features/weather/data/weather_models/weather_model.dart';

class WeatherRemoteDatasource {
  final String apikey = "2a142141c9ea8edbaae881689941c762";
  
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=41.3111&lon=69.2797&appid=2a142141c9ea8edbaae881689941c762&units=metric');
    
    print("API URL: $url");
    print('🔹 [API CALL] Fetching current weather...');
    print('🔹 URL: $url');
    final response = await http.get(url);

    print('🔹 [API RESPONSE] Status: ${response.statusCode}');
    print('🔹 Response body: ${response.body}');

    if(response.statusCode == 200){
      return WeatherModel.fromCurrentjson(jsonDecode(response.body));
    }else{
      throw Exception("Hozirgi ob havo ni yuklashda xatolik");
    }
  }

  Future<List<WeatherModel>> get7daysForecast(double lat, double lon) async {
  // ✅ BEPUL API (5 kun / 3 soat intervali)
  final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric&lang=uz',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final cityName = data["city"]["name"] as String;
    final List list = data["list"] as List;

    // Group by day (3 soatlik ma'lumotlardan kunlik qilish)
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};

    for (var item in list) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        (item["dt"] as int) * 1000,
      );
      final dateKey = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

      if (!groupedByDay.containsKey(dateKey)) {
        groupedByDay[dateKey] = [];
      }
      groupedByDay[dateKey]!.add(item as Map<String, dynamic>);
    }

    // Har bir kun uchun average hisoblash
    final List<WeatherModel> dailyForecast = [];

    for (var entry in groupedByDay.entries) {
      if (dailyForecast.length >= 7) break; // Faqat 7 kun

      final dayData = entry.value;

      // Average temperature
      final avgTemp = dayData
              .map((e) => (e["main"]["temp"] as num).toDouble())
              .reduce((a, b) => a + b) /
          dayData.length;

      // Min/Max temperature
      final minTemp = dayData
          .map((e) => (e["main"]["temp_min"] as num).toDouble())
          .reduce((a, b) => a < b ? a : b);
      final maxTemp = dayData
          .map((e) => (e["main"]["temp_max"] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);

      // Most common weather condition
      final weatherDescriptions =
          dayData.map((e) => e["weather"][0]["description"] as String).toList();
      final mostCommonDesc = weatherDescriptions.first;

      final weatherMains =
          dayData.map((e) => e["weather"][0]["main"] as String).toList();
      final mostCommonMain = weatherMains.first;

      // Average humidity & wind
      final avgHumidity = dayData
              .map((e) => (e["main"]["humidity"] as num).toDouble())
              .reduce((a, b) => a + b) /
          dayData.length;
      final avgWind = dayData
              .map((e) => (e["wind"]["speed"] as num).toDouble())
              .reduce((a, b) => a + b) /
          dayData.length;

      dailyForecast.add(
        WeatherModel(
          cityName: cityName,
          date: entry.key,
          description: mostCommonDesc,
          temperature: avgTemp,
          minTemp: minTemp,
          maxTemp: maxTemp,
          humidity: avgHumidity,
          windspeed: avgWind,
          main: mostCommonMain,
        ),
      );
    }

    return dailyForecast;
  } else {
    throw Exception(
      "7 kunlik ob-havo yuklashda xatolik. Status: ${response.statusCode}",
    );
  }
}
}