import 'package:flutter/material.dart';
import 'package:marbles_intern_assignment/model/form_component_model.dart';
import 'package:marbles_intern_assignment/widgets/checkbox_widget.dart';

Widget submittedComponent(
  double width,
  double height,
  FormComponentData data,
  VoidCallback onDelete,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5.0),
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    width: width * 0.8,
    height: height * 0.2,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFDBDDE0),
        width: 1.0,
      ),
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: data.label,
                  style: const TextStyle(color: Colors.black),
                  children: data.isRequired
                      ? [
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          )
                        ]
                      : [],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onDelete,
                child: Container(
                  height: height * 0.04,
                  width: width * 0.12,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: width * 0.87,
          height: height * 0.05,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black26,
              width: 1.0,
            ),
            color: const Color(0xFFF8F9FA),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data.infoText),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              const Text('Setting Type:'),
              SizedBox(
                width: width * 0.02,
              ),
              data.isRequired
                  ? const Text('Required')
                  : data.isReadOnly
                      ? const Text('Read Only')
                      : const Text('Hidden')
            ],
          ),
        )
      ],
    ),
  );
}

Widget exampleComponent(
  double width,
  double height,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5.0),
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    width: width * 0.8,
    height: height * 0.2,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFDBDDE0),
        width: 1.0,
      ),
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
            ),
            child: Text("Eg. Label")),
        Container(
          width: width * 0.8,
          height: height * 0.05,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black26,
              width: 1.0,
            ),
            color: const Color(0xFFF8F9FA),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Eg. Info Text'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text('Setting Type: None'),
        )
      ],
    ),
  );
}

Widget customTextField(
    {required double height,
    Color? color,
    String? label,
    String? hintText,
    bool spaced = false,
    bool? enable,
    TextEditingController? controller,
    TextInputType? inputType = TextInputType.text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      (label != null)
          ? Text(
              label.toString(),
              style: TextStyle(
                  color: (color == null) ? Colors.black : color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter'),
            )
          : const SizedBox(),
      SizedBox(height: spaced ? height * 0.02 : 0),
      Container(
        height: height * 0.06,
        padding: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Expanded(
          child: TextField(
            enabled: enable,
            style: const TextStyle(fontSize: 15),
            controller: controller,
            // onChanged: (value) {
            //   controller!.text = value;
            // },
            // maxLines: mulitline,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.only(left: 10.0, bottom: 15.5),
                hintText: hintText,
                border: InputBorder.none,
                counterText: ''),
            keyboardType: inputType,
          ),
        ),
      ),
    ],
  );
}
