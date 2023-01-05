import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/utils/weather_util.dart';

import '../constants/text_styles/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _temp = '';
  String _cityName = '';
  String _description = '';
  String _icons = '';
  bool _ailanipAtat = false;
  @override
  void initState() {
    setState(() {
      _ailanipAtat = true;
    });
    showWeatherByLocation();
    super.initState();
  }

  Future<void> showWeatherByLocation() async {
    final position = await _getPosition();
    await abaIraynLocationMenenAlipKel(positionBer: position);
  }

  Future<void> abaIraynLocationMenenAlipKel({Position? positionBer}) async {
    try {
      final client = http.Client();
      setState(() {
        _ailanipAtat = true;
      });
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${positionBer!.latitude}&lon=${positionBer.longitude}&appid=c3aa0301d9353c81b3f8e8254ca12e23');
      final response = await client.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonJoop = response.body;
        final data = jsonDecode(jsonJoop) as Map<String, dynamic>;

        final kelvin = data['main']['temp'] as num;

        _cityName = data['name'] as String;

        _temp = WeatherUtil.kelvinToCelcius(kelvin);
        _description = WeatherUtil.getDescription(num.parse(_temp));

        _icons = WeatherUtil.getWeatherIcon(kelvin);
        setState(() {
          _ailanipAtat = false;
        });
      }
    } catch (e) {
      setState(() {
        _ailanipAtat = false;
      });

      throw Exception(e);
    }
  }

  Future<void> getCityName(String typeCityName) async {
    try {
      final client = http.Client();

      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$typeCityName&appid=c3aa0301d9353c81b3f8e8254ca12e23');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final data = jsonDecode(body);
        final kelvin = data['main']['temp'];
        _cityName = data['name'];

        _temp = WeatherUtil.kelvinToCelcius(kelvin);
        _icons = WeatherUtil.getWeatherIcon(kelvin);
        _description = WeatherUtil.getDescription(int.parse(_temp));

        setState(() {
          _ailanipAtat = false;
        });
      }
    } catch (katany) {
      setState(() {
        _ailanipAtat = false;
      });
      throw Exception(katany);
    }
  }

  // GPS
  Future<Position> _getPosition() async {
    bool? serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () async {
              final typedCityName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );

              await getCityName(typedCityName);
              setState(() {});
            },
            child: const Icon(
              Icons.location_city,
              size: 50,
            ),
          ),
        ],
        leading: InkWell(
          onTap: () async => await showWeatherByLocation(),
          child: Image.asset(
            'assets/images/location.png',
            scale: 10,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        Container(
          child: null,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/bg_image.jpg'),
            ),
          ),
        ),
        if (_ailanipAtat == true)
          const Positioned(
            left: 150,
            top: 400,
            child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.red,
                )),
          )
        else
          Positioned(
            left: 50,
            top: 200,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      '$_temp\u00B0',
                      style: TextStyles.text100White,
                    ),
                    Text(
                      _icons,
                      style: TextStyles.text60Wight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        Positioned(
          top: 400,
          right: 0,
          child: Text(_description,
              textAlign: TextAlign.center, style: TextStyles.text20Black),
        ),
        Positioned(
            top: 600,
            left: 150,
            child: Text(
              _cityName,
              // WeatherApiHttp().weatherHttp(),
              style: TextStyles.text35White,
            )),
      ]),
    );
  }
}
