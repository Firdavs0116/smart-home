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

  // Current Weather (api.openweathermap.org/data/2.5/weather)
  factory WeatherModel.fromCurrentjson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json["name"] as String,
      date: DateTime.now().toIso8601String(),
      description: json["weather"][0]["description"] as String,
      temperature: (json["main"]["temp"] as num).toDouble(),
      minTemp: (json["main"]["temp_min"] as num).toDouble(), // ✅ TUZATILDI
      maxTemp: (json["main"]["temp_max"] as num).toDouble(), // ✅ TUZATILDI
      humidity: (json["main"]["humidity"] as num).toDouble(),
      windspeed: (json["wind"]["speed"] as num).toDouble(),
      main: json["weather"][0]["main"] as String,
    );
  }

  // 7-Day Forecast (api.openweathermap.org/data/2.5/onecall)
  factory WeatherModel.fromDailyJson(
    Map<String, dynamic> json,
    String cityName,
  ) {
    return WeatherModel(
      cityName: cityName,
      date: DateTime.fromMillisecondsSinceEpoch(
        (json["dt"] as int) * 1000,
      ).toIso8601String(),
      description: json["weather"][0]["description"] as String,
      temperature: (json["temp"]["day"] as num).toDouble(),
      minTemp: (json["temp"]["min"] as num).toDouble(),
      maxTemp: (json["temp"]["max"] as num).toDouble(),
      humidity: (json["humidity"] as num).toDouble(),
      windspeed: (json["wind_speed"] as num).toDouble(),
      main: json["weather"][0]["main"] as String, // ✅ TUZATILDI (wather → weather)
    );
  }

  // CopyWith (optional, lekin foydali)
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
}