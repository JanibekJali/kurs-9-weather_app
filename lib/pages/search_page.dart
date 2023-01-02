import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/constants/colors/colors.dart';
import 'package:weather_app/constants/text_styles/text_styles.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/bg_image.jpg'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: 'Издөө',
                  hintStyle: const TextStyle(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 4.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    textEditingController.text,
                  );
                  log('textEditingController ===>  ${textEditingController.text}');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.grey.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  // backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      color: Colors.black, width: 3), //<-- SEE HERE
                ),
                child: const SizedBox(
                  width: 200,
                  child: Text(
                    'Шаарды өзгөрт',
                    textAlign: TextAlign.center,
                    style: TextStyles.text20Black,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
