import 'package:flutter/material.dart';
import 'package:my_todo_app/Shared/styles/colors.dart';
import 'package:sizer/sizer.dart';

class MyTextfield extends StatelessWidget {
  final IconData icon;
  final IconData? suffixIcon;
  final String hint;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final TextInputType keyboardtype;
  final bool obscure;
  final bool readonly;
  final bool showPrefixIcon;
  final bool showSuffixIcon;

  final int? maxlenght;
  final Function()? ontap;

  const MyTextfield(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.validator,
      required this.controller,
      this.suffixIcon,
      this.obscure = false,
      this.readonly = false,
      this.showPrefixIcon = true,
      this.showSuffixIcon = false,
      this.ontap,
      this.keyboardtype = TextInputType.text,
      this.maxlenght = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // textCapitalization: TextCapitalization.words,
      maxLength: maxlenght,
      readOnly: readonly,
      obscureText: obscure,
      keyboardType: keyboardtype,
      onTap: readonly ? ontap : null,
      controller: controller,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 11.sp,
            color: Colors.deepPurple,
          ),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 0,
            )),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 2.3.h),
        hintStyle: Theme.of(context).textTheme.headline1?.copyWith(
              fontSize: 11.sp,
              color: Appcolors.deepPurple,
            ),
        prefixIcon: showPrefixIcon
            ? Icon(
                icon,
                size: 22,
                color: Colors.deepPurple,
              )
            : null,
        suffixIcon: showSuffixIcon
            ? Icon(
                icon,
                size: 22,
                color: Colors.deepPurple,
              )
            : null,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}

// class MyTextField extends StatelessWidget {
//   MyTextField({
//     Key? key,
//     this.label,
//     this.icon,
//     this.hint,
//     this.hidePassword = false,
//     this.onChanged,
//     required this.validator,
//     required this.controller,
//   }) : super(key: key);
//
//   final String? label;
//   final IconData? icon;
//   final String? hint;
//   final void Function(String value)? onChanged;
//   bool hidePassword;
//
//   final String? Function(String? value) validator;
//   final TextEditingController? controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       obscureText: hidePassword,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(25)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.yellow[700]!,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(25)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blue[700]!,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(25)),
//         ),
//       ),
//     );
//   }
// }
