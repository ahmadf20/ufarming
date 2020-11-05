import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ufarming/utils/my_colors.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    Key key,
    @required this.label,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Color(0xfff7f5f2),
        border: Border.all(
          width: 1.00,
          color: Color(0xfff0f0f0),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: MyColors.darkGrey,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontFamily: 'OpenSans',
            color: MyColors.grey,
            height: 0.8,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Color(0xFFF7F5F2),
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }
}
