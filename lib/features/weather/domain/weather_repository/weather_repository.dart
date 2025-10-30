import 'package:smart_home1/features/weather/domain/weather_entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getCurrentWeather(double lat, double lon);
  Future<List<WeatherEntity>> get7DayForecast(double lat, double lon);
}