
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;


var files = {
  "Automotive Engineering": "AutomotiveEngineering",
  "Industrial Engineering": "IndustrialEngineering",
  "Mechanical Engineering": "MechanicalEngineering",
  "Civil Engineering": "CivilEngineering",
  'Water Resources and Irrigation Engineering': "wrie",
  'Hydraulic and Water Resources Engineering': "hwre",
  "Chemical Engineering": "ChemicalEngineering",
  "Food Engineering": "FoodEngineering",
  "Human Nutrition": "HumanNutrition",
  "Electrical Engineering": "ElectricalEngineering",
  "Computer Engineering": "ComputerEngineering",
  "Computer Science": "ComputerScience",
  "Software Engineering": "SoftwareEngineering",
};


class DepartmentOptions extends StatefulWidget {
  const DepartmentOptions({super.key});

  @override
  State<DepartmentOptions> createState() => _DepartmentOptionsState();
}

class _DepartmentOptionsState extends State<DepartmentOptions> {
  var items = [
    'none',
    'Civil Engineering',
    'Water Resources and Irrigation Engineering',
    'Hydraulic and Water Resources Engineering',
    'Computer Science',
    'Software Engineering',
    'Computer Engineering',
    'Electrical Engineering',
    'Food Engineering',
    'Chemical Engineering',
    'Human Nutrition',
    'Automotive Engineering',
    'Mechanical Engineering',
    'Industrial Engineering',
  ];

  String file_path = "CivilEngineering";
  String? department;

  final TextEditingController universityController = TextEditingController();
  String university = 'Civil Engineering';
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      leadingIcon: Icon(Icons.school),
      hintText: 'Select Field of Study',
      initialSelection: 'Civil Engineering',
      expandedInsets: const EdgeInsets.all(1.0),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: Colors.amber,
      ),
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      controller: universityController,
      dropdownMenuEntries: items
          .map<DropdownMenuEntry<String>>(
              (String value) => DropdownMenuEntry<String>(
            value: value,
            label: value,
          ))
          .toList(),
      onSelected: (String? value) {
        setState(() {
          index++;
          university = items[index];
        });
      },
    );
  }
}
