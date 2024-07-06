import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color borderColor;
  final Color checkColor;
  final String label;

  const CustomCheckbox(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged,
      required this.borderColor,
      required this.checkColor});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        onChanged!(!value);
      },
      child: Row(
        children: [
          Container(
            width: height * 0.025,
            height: height * 0.025,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: value ? borderColor : Colors.grey.shade300,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: height * 0.02,
                    color: checkColor,
                  )
                : null,
          ),
          SizedBox(
            width: width * 0.01,
          ),
          Text(
            label,
            style:
                TextStyle(fontWeight: FontWeight.w600, fontSize: height * 0.02),
          )
        ],
      ),
    );
  }
}
