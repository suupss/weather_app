import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_screen/secrets.dart';
import './additional_info.dart';
import './hourly_forcast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIkey'));
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      print(data['list'][0]['main']['temp']);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '300K',
                              style: TextStyle(fontSize: 32),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.cloud,
                              size: 64,
                            ),
                            Text(
                              'Rain',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                'Weather Forcast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForcastItem(
                      time: '3:00',
                      temperature: '301.2',
                      icon: Icons.cloud,
                    ),
                    HourlyForcastItem(
                      time: '4:00',
                      temperature: '301.2',
                      icon: Icons.cloud,
                    ),
                    HourlyForcastItem(
                      time: '5:00',
                      temperature: '301.2',
                      icon: Icons.sunny,
                    ),
                    HourlyForcastItem(
                      time: '6:00',
                      temperature: '300.52',
                      icon: Icons.cloud,
                    ),
                    HourlyForcastItem(
                      time: '7:00',
                      temperature: '301.2',
                      icon: Icons.sunny,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              const Text(
                'Additional Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 14,
              ),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '94',
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '7.67',
                    ),
                    AdditionalInfo(
                      icon: Icons.umbrella,
                      label: 'Pressure',
                      value: '1006',
                    ),
                  ]),
            ],
          ),
        ));
  }
}
