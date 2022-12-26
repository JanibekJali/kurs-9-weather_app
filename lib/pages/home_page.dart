import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/pages/search_page.dart';

import '../constants/text_styles/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _getPosition();
    super.initState();
  }

  Future<Position> _getPosition() async {
    bool? serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
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
        Positioned(
          left: 50,
          top: 200,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Text(
                    '8\u00B0',
                    style: TextStyles.text100White,
                  ),
                  Text(
                    ' ',
                    style: TextStyles.text60Wight,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 400,
          right: 50,
          child: Text(
            '''
            Jylyy kiinip chyk  
            Jylyy kiinip chyk
            Jylyy kiinip chyk 
            ''',
            textAlign: TextAlign.center,
            style: TextStyles.text35Black,
          ),
        ),
        const Positioned(
            top: 700,
            left: 150,
            child: Text(
              'Bishkek',
              // WeatherApiHttp().weatherHttp(),
              style: TextStyles.text35White,
            )),
      ]),
    );
  }
}
