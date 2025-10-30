import 'package:myapp/week07/calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget{
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;


  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}