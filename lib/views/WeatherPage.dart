import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_viewmodel.dart';

class WeatherPage extends StatelessWidget {
  WeatherPage({Key? key}) : super(key: key);

  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final WeatherViewModel _viewModel =
        Provider.of<WeatherViewModel>(context, listen: true);
    final weather = _viewModel.weather;
    final hasError = _viewModel.error != null;
    String? fahrenheitTempString = weather?.fahrenheitTemp.toStringAsFixed(2);

    final isLoading = _viewModel.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Enter location (name or zip code)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _viewModel.setLocation(_locationController.text);
              _viewModel.getWeather();
              _viewModel.getForecast();
              // print(updatedWeather);
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(child: Text('Enter A valid Zip code or City'))
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Temperature:  ${_viewModel.isCelsius ? weather?.temperature : fahrenheitTempString} ${_viewModel.isCelsius ? '°C' : '°F'}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Humidity: ${_viewModel.weather?.humidity ?? 0}%'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Wind speed: ${_viewModel.weather?.windSpeed ?? 0}m/s'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _viewModel.forecastData.length,
                              itemBuilder: (context, index) {
                                var forecast = _viewModel.forecastData[index];
                                String? fahrenheitTempHighString = forecast
                                    .fahrenheitTempHigh
                                    .toStringAsFixed(2);
                                String? fahrenheitTempLowString = forecast
                                    .fahrenheitTempLow
                                    .toStringAsFixed(2);

                                return ListTile(
                                  title: Text(forecast.date ?? ''),
                                  subtitle: Text(
                                      'High: ${_viewModel.isCelsius ? forecast.high : fahrenheitTempHighString} ${_viewModel.isCelsius ? '°C' : '°F'}\nLow:  ${_viewModel.isCelsius ? forecast.low : fahrenheitTempLowString}${_viewModel.isCelsius ? '°C' : '°F'}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.toggleUnit,
        child: Icon(_viewModel.isCelsius ? Icons.wb_sunny : Icons.ac_unit),
      ),
    );
  }
}
