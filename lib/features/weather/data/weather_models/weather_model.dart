import 'package:smart_home1/features/weather/domain/weather_entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.cityName,
    required super.date,
    required super.description,
    required super.temperature,
    required super.minTemp,
    required super.maxTemp,
    required super.humidity,
    required super.windspeed,
    required super.main,
  });

  // ✅ Current Weather (WeatherAPI.com format)
  factory WeatherModel.fromWeatherApiCurrent(Map<String, dynamic> json) {
    print('📦 Parsing WeatherAPI Current:');
    print('   Location: ${json["location"]}');
    print('   Current: ${json["current"]}');

    final location = json["location"] as Map<String, dynamic>;
    final current = json["current"] as Map<String, dynamic>;
    final condition = current["condition"] as Map<String, dynamic>;

    return WeatherModel(
      cityName: location["name"] as String,
      date: location["localtime"] as String,
      description: condition["text"] as String,
      temperature: (current["temp_c"] as num).toDouble(),
      minTemp: (current["temp_c"] as num).toDouble(), // Current'da min/max yo'q
      maxTemp: (current["temp_c"] as num).toDouble(),
      humidity: (current["humidity"] as num).toDouble(),
      windspeed: (current["wind_kph"] as num).toDouble(),
      main: condition["text"] as String, // "Sunny", "Cloudy", etc.
    );
  }

  // ✅ Forecast (WeatherAPI.com format)
  factory WeatherModel.fromWeatherApiForecast(
    Map<String, dynamic> json,
    String cityName,
  ) {
    print('📦 Parsing WeatherAPI Forecast Day:');
    print('   Date: ${json["date"]}');
    print('   Day: ${json["day"]}');

    final day = json["day"] as Map<String, dynamic>;
    final condition = day["condition"] as Map<String, dynamic>;

    return WeatherModel(
      cityName: cityName,
      date: json["date"] as String,
      description: condition["text"] as String,
      temperature: (day["avgtemp_c"] as num).toDouble(),
      minTemp: (day["mintemp_c"] as num).toDouble(),
      maxTemp: (day["maxtemp_c"] as num).toDouble(),
      humidity: (day["avghumidity"] as num).toDouble(),
      windspeed: (day["maxwind_kph"] as num).toDouble(),
      main: condition["text"] as String,
    );
  }

  // CopyWith
  WeatherModel copyWith({
    String? cityName,
    String? date,
    String? description,
    double? temperature,
    double? minTemp,
    double? maxTemp,
    double? humidity,
    double? windspeed,
    String? main,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      date: date ?? this.date,
      description: description ?? this.description,
      temperature: temperature ?? this.temperature,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      humidity: humidity ?? this.humidity,
      windspeed: windspeed ?? this.windspeed,
      main: main ?? this.main,
    );
  }

  // ToJson
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'date': date,
      'description': description,
      'temperature': temperature,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'humidity': humidity,
      'windspeed': windspeed,
      'main': main,
    };
  }
}