import 'package:flutter/material.dart';
import 'package:my_todo_app/Shared/styles/colors.dart';
import 'package:sizer/sizer.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
        required this.color,
        required this.width,
        required this.title,
        required this.onPress})
      : super(key: key);

  final Color color;
  final double width;
  final String title;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onPress,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontSize: 11.sp, color: Appcolors.white),
        ),
      ),
    );
  }
}