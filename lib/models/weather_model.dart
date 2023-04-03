class Weather {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final List<Forecast> forecast;
  double fahrenheitTemp;

  Weather(
      {required this.temperature,
      required this.humidity,
      required this.windSpeed,
      required this.forecast,
      required this.fahrenheitTemp}) {}

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        temperature: json['main']['temp'],
        humidity: json['main']['humidity'],
        windSpeed: json['wind']['speed'],
        forecast: [],
        fahrenheitTemp: ((json['main']['temp']) * 9 / 5) + 32);
  }
}

class Forecast {
  final double high;
  final double low;
  final String? date;
  double fahrenheitTempHigh;
  double fahrenheitTempLow;

  Forecast(
      {required this.high,
      required this.low,
      required this.date,
      required this.fahrenheitTempHigh,
      required this.fahrenheitTempLow});
}
