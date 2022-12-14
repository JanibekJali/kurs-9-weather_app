import 'package:flutter/material.dart';

import '../constants/text_styles/text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.location_city,
            size: 50,
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
          top: 150,
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    '8',
                    style: TextStyles.text100White,
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'Jylyy kiinip chyk',
                    style: TextStyles.text35Black,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('data'),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
