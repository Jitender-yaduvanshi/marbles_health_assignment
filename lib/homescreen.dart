import 'package:flutter/material.dart';
import 'package:marbles_intern_assignment/widgets/custom_widgets.dart';
import 'package:marbles_intern_assignment/widgets/checkbox_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/form_component_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FormComponentData> formDataList = [];

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  void _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? formDataStrings = prefs.getStringList('formDataList');
    if (formDataStrings != null) {
      setState(() {
        formDataList = formDataStrings.map((dataString) {
          return FormComponentData.fromJson(dataString);
        }).toList();
      });
    }
  }

  void _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> formDataStrings = formDataList.map((data) {
      return data.toJson();
    }).toList();
    await prefs.setStringList('formDataList', formDataStrings);
  }

  void _deleteComponent(int index) {
    setState(() {
      formDataList.removeAt(index);
    });
    _saveFormData();
  }

  String generateOutputString(List<FormComponentData> formDataList) {
    StringBuffer output = StringBuffer();

    for (int i = 0; i < formDataList.length; i++) {
      FormComponentData data = formDataList[i];
      output.writeln('Component ${i + 1}:');
      output.writeln('Label: ${data.label}');
      output.writeln('Info-Text: ${data.infoText}');
      String settings = '';
      if (data.isRequired) settings += 'Required ';
      if (data.isReadOnly) settings += 'Readonly ';
      if (data.isHidden) settings += 'Hidden ';
      output.writeln('Settings: ${settings.trim()}');
      output.writeln();
    }

    return output.toString();
  }

  void showOutputDialog(BuildContext context, String output) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Form Data'),
          content: SingleChildScrollView(
            child: Text(
              output,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  const Text(
                    'Watermeter Quarterly Check',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  const Spacer(),
                  (formDataList.isNotEmpty)
                      ? IconButton(
                          onPressed: () {
                            String output = generateOutputString(formDataList);
                            showOutputDialog(context, output);
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.green,
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 20.0, top: 5.0, right: 5.0, left: 5.0),
                width: width * 0.95,
                height: height * 0.9,
                decoration: const BoxDecoration(
                    color: Color(0xFFDBDDE0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: (formDataList.isEmpty)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          exampleComponent(
                            width,
                            height,
                          ),
                        ],
                      )
                    : Center(
                        child: ListView.builder(
                          itemCount: formDataList.length,
                          itemBuilder: (context, index) {
                            final component = formDataList[index];
                            return submittedComponent(
                              width,
                              height,
                              component,
                              () => _deleteComponent(index),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: width * 0.12,
        height: height * 0.05,
        margin: EdgeInsets.only(right: width * 0.05),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FormComponent(
                  onSubmit: (data) {
                    setState(() {
                      formDataList.add(data);
                    });
                    _saveFormData();
                  },
                );
              },
            );
          },
          child: Text(
            'ADD',
            style: TextStyle(fontSize: height * 0.0215, color: Colors.green),
          ),
        ),
      ),
    );
  }
}

class FormComponent extends StatefulWidget {
  final Function(FormComponentData) onSubmit;

  const FormComponent({super.key, required this.onSubmit});

  @override
  State<FormComponent> createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  bool isChecked = false;
  bool isRequired = false;
  bool isReadOnly = false;
  bool isHidden = false;
  TextEditingController labelController = TextEditingController();
  TextEditingController infoTextController = TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _validateInputs() {
    if (!isChecked) {
      _showSnackBar(context, 'Please select the checkbox first.');
      return false;
    }
    if (labelController.text.isEmpty) {
      _showSnackBar(context, 'Label field cannot be empty.');
      return false;
    }
    if (infoTextController.text.isEmpty) {
      _showSnackBar(context, 'Info-Text field cannot be empty.');
      return false;
    }
    if (!isRequired && !isReadOnly && !isHidden) {
      _showSnackBar(context, 'Please select one mode of settings checkbox.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
        width: width * 0.8,
        height: height * 0.32,
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
            Row(
              children: [
                CustomCheckbox(
                  label: 'Checkbox',
                  checkColor: Colors.green,
                  borderColor: Colors.green,
                  value: isChecked,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        isChecked = value;
                      });
                    }
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (_validateInputs()) {
                      widget.onSubmit(FormComponentData(
                        label: labelController.text,
                        infoText: infoTextController.text,
                        isRequired: isRequired,
                        isReadOnly: isReadOnly,
                        isHidden: isHidden,
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    height: height * 0.04,
                    width: width * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                        child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                if (!isChecked) {
                  _showSnackBar(context, 'Please select the checkbox first.');
                }
              },
              child: AbsorbPointer(
                absorbing: !isChecked,
                child: customTextField(
                  enable: isChecked,
                  controller: labelController,
                  height: height * 0.7,
                  label: 'Label',
                  hintText: 'Enter Title',
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                if (!isChecked) {
                  _showSnackBar(context, 'Please select the checkbox first.');
                }
              },
              child: AbsorbPointer(
                absorbing: !isChecked,
                child: customTextField(
                  enable: isChecked,
                  controller: infoTextController,
                  height: height * 0.7,
                  label: 'Info-Text',
                  hintText: 'Add additional information',
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                CustomCheckbox(
                  label: 'Required',
                  checkColor: Colors.blue,
                  borderColor: Colors.blue,
                  value: isRequired,
                  onChanged: isChecked
                      ? (bool? value) {
                          setState(() {
                            if (value == true) {
                              isRequired = true;
                              isReadOnly = false;
                              isHidden = false;
                            } else {
                              isRequired = false;
                            }
                          });
                        }
                      : null,
                ),
                SizedBox(
                  width: width * 0.04,
                ),
                CustomCheckbox(
                  label: 'ReadOnly',
                  checkColor: Colors.blue,
                  borderColor: Colors.blue,
                  value: isReadOnly,
                  onChanged: isChecked
                      ? (bool? value) {
                          setState(() {
                            if (value == true) {
                              isReadOnly = true;
                              isRequired = false;
                              isHidden = false;
                            } else {
                              isReadOnly = false;
                            }
                          });
                        }
                      : null,
                ),
                SizedBox(
                  width: width * 0.04,
                ),
                CustomCheckbox(
                  label: 'Hidden Field',
                  checkColor: Colors.blue,
                  borderColor: Colors.blue,
                  value: isHidden,
                  onChanged: isChecked
                      ? (bool? value) {
                          setState(() {
                            if (value == true) {
                              isHidden = true;
                              isRequired = false;
                              isReadOnly = false;
                            } else {
                              isHidden = false;
                            }
                          });
                        }
                      : null,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
