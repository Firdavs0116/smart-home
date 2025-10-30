class WeatherEntity {
  final String cityName;
  final String date;
  final String description;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final double humidity;
  final double windspeed;
  final String main;

  WeatherEntity({
  required  this.cityName, 
  required  this.date, 
  required  this.description, 
  required  this.temperature, 
  required  this.minTemp, 
  required  this.maxTemp, 
  required  this.humidity, 
  required  this.windspeed, 
  required  this.main,
    });
}

// Biz buyerda biz nimalar olishimiz kerakligi yozildi. 
//bizga shular ko'rsatiladi va ishlatiladi