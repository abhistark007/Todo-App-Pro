import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app_pro_1/extensions/space_exs.dart';
import 'package:todo_app_pro_1/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  // Icons
  final List<IconData> icons = [
    Icons.home,
    Icons.person,
    Icons.settings,
    Icons.info_outlined,
  ];

  // Texts
  final List<String> texts = ["Home", "Profile", "Setting", "Details"];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 90),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/img/img1.png"),
          ),
          8.h,
          Text(
            "Lucy Morningstar",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Text(
            "Flutter Dev",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    log(texts[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      leading: Icon(
                        icons[index],
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        texts[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
