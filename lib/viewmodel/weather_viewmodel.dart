  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  import '../models/weather_model.dart';

  const WEATHER_API_KEY = '46bc5ebd5af71d543d12c4af2dcde186';

  class WeatherViewModel extends ChangeNotifier {
    Weather? _weather;
    bool _isCelsius = true;
    String? _location;
    bool _isLoading = false;
    String? _error;
    List<Forecast> _forecastData = [];

    Weather? get weather => _weather;
    bool get isCelsius => _isCelsius;
    String get location => _location ?? '';
    bool get isLoading => _isLoading;
    String? get error => _error;
    List<Forecast> get forecastData => _forecastData;

    // Function to make the API call and retrieve weather data
    Future<void> getWeather() async {
      _isLoading = true;
      _error = null;
      var uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$_location&appid=46bc5ebd5af71d543d12c4af2dcde186');
      notifyListeners();
      try {
        var response = await http.get(uri);
        if (response.statusCode == 200) {
          _weather = Weather.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to retrieve weather data');
        }
        print(response.body);
      } catch (e) {
        _error = e.toString();
      }
      _isLoading = false;
      notifyListeners();
    }

    // function for Forecast
    Future<void> getForecast() async {
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$_location&appid=46bc5ebd5af71d543d12c4af2dcde186');
      notifyListeners();
      try {
        final response = await http.get(url);
        final extractedData = json.decode(response.body) as Map<String, dynamic>;
        final _forecast = extractedData['list'];
        url = Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$_location&appid=46bc5ebd5af71d543d12c4af2dcde186');
        final List<Forecast> loadedForecast = [];
        _forecast.forEach((element) {
          loadedForecast.add(
            Forecast(
                high: element['main']['temp_max'],
                low: element['main']['temp_min'],
                date: element['dt_txt'],
                fahrenheitTempLow: ((element['main']['temp_max']) * 9 / 5) + 32,
                fahrenheitTempHigh: ((element['main']['temp_max']) * 9 / 5) + 32),
          );
        });
        _forecastData = loadedForecast;
        notifyListeners();
      } catch (e) {
        _error = e.toString();
      }
    }

    // Function to handle unit conversion
    void toggleUnit() {
      _isCelsius = !_isCelsius;
      notifyListeners();
    }

    // Function to handle location change
    void setLocation(String location) {
      _location = location;
      notifyListeners();
    }
  }
