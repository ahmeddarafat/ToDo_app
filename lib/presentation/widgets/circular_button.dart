import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:my_todo_app/shared/styles/colors.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key,
      required this.color,
      required this.width,
      required this.icon,
      required this.func,
      required this.condition})
      : super(key: key);

  final Color color;
  final double width;
  final IconData icon;
  final Function() func;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 0,
        left: 0,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: MaterialButton(
        onPressed: func,
        child: Center(
          child: (condition)
              ? Icon(
                  Icons.arrow_forward_rounded,
                  color: Appcolors.white,
                  size: 15.sp,
                )
              : Text(
                  'Begin',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 9.sp, color: Appcolors.white),
                ),
        ),
      ),
    );
  }
}