import 'dart:convert';
import 'dart:developer';

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
  dynamic temp = '';
  String cityName = '';
  String description = '';
  String icons = '';
  bool ailanipAtat = false;
  @override
  void initState() {
    setState(() {
      ailanipAtat = true;
    });
    showWeatherByLocation();
    super.initState();
  }

  Future<void> showWeatherByLocation() async {
    final position = await _getPosition();
    await abaIraynLocationMenenAlipKel(positionBer: position);
    await getCityName(cityName);

    // log('Position lat ${position.latitude}');
    // log('Position log ${position.longitude}');
    // log('Position ${position.altitude}');
  }

  Future<void> abaIraynLocationMenenAlipKel({Position? positionBer}) async {
    setState(() {
      ailanipAtat = true;
    });
    try {
      final clientHttp = http.Client();
      Uri uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${positionBer!.latitude}&lon=${positionBer.longitude}&appid=c3aa0301d9353c81b3f8e8254ca12e23',
      );
      final joop = await clientHttp.get(uri);
      final jsonJoop = jsonDecode(joop.body);
      // log('json ==> ${jsonJoop.body}');

      // log('Json Joop  ===> $jsonJoop');
      final kelvin = jsonJoop['main']['temp'] as dynamic;

      //  Kelvin − 273,15
      temp = kelvin;
      cityName = jsonJoop['name'];
      description = WeatherUtil.getDescription(temp);
      icons = WeatherUtil.getWeatherIcon(kelvin);
    } catch (error) {
      throw Exception(error);
    }
    setState(() {
      ailanipAtat = false;
    });
  }

  Future<Map<String, dynamic>>? getCityName(String cityName) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=c3aa0301d9353c81b3f8e8254ca12e23');
      final response = await client.get(uri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final kelvin = data['main']['temp'];
        temp = kelvin;
        cityName = data['name'];
        icons = WeatherUtil.getWeatherIcon(kelvin);
        description = WeatherUtil.getDescription(temp);
        setState(() {});
      }
      return data;
    } catch (kata) {
      throw Exception(kata);
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
    log('Build ===>');
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
              log('typedCityName ====> $typedCityName');
              await getCityName(typedCityName);
              setState(() {});
            },
            child: const Icon(
              Icons.location_city,
              size: 50,
            ),
          ),
        ],
        leading: Image.asset(
          'assets/images/location.png',
          scale: 10,
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
        if (ailanipAtat == true)
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
                      '$temp\u00B0',
                      style: TextStyles.text100White,
                    ),
                    Text(
                      icons,
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
          child: Text(description,
              textAlign: TextAlign.center, style: TextStyles.text20Black),
        ),
        Positioned(
            top: 700,
            left: 150,
            child: Text(
              cityName,
              // WeatherApiHttp().weatherHttp(),
              style: TextStyles.text35White,
            )),
      ]),
    );
  }
}
