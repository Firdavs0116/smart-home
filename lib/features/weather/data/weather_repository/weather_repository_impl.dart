import 'package:smart_home1/features/weather/data/weather_remote_datasource/weather_remote_datasource.dart';
import 'package:smart_home1/features/weather/domain/weather_entities/weather_entity.dart';
import 'package:smart_home1/features/weather/domain/weather_repository/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository{

  final WeatherRemoteDatasource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WeatherEntity>> get7DayForecast(double lat, double lon) async {
    return await remoteDataSource.get7daysForecast(lat, lon);
  }

  @override
Future<WeatherEntity> getCurrentWeather(double lat, double lon) async {
  print('📡 [Repository] getCurrentWeather started: $lat, $lon');
  final weather = await remoteDataSource.getCurrentWeather(lat, lon);
  print('✅ [Repository] Weather received: ${weather.temperature}');
  return weather;
}


}