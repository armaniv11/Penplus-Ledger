import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget rowTwoChild(child1, child2,
    {bool iconshow: false,
    IconData icon: Icons.add,
    FontWeight weight: FontWeight.normal}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          child1,
          style: TextStyle(fontSize: 12, fontWeight: weight),
        ),
        Spacer(),
        iconshow
            ? FaIcon(
                icon,
                size: 12,
                color: Colors.grey[400],
              )
            : Container(),
        SizedBox(
          width: 6,
        ),
        FaIcon(
          FontAwesomeIcons.rupeeSign,
          size: 10,
          color: Colors.grey[400],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            child2,
            style: TextStyle(fontSize: 12, fontWeight: weight),
          ),
        )
      ],
    ),
  );
}
