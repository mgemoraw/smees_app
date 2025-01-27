import 'package:flutter/material.dart';
import 'package:smees/views/common/appbar.dart';


class SmeesSettings extends StatefulWidget {
  const SmeesSettings({super.key});

  @override
  State<SmeesSettings> createState() => _SmeesSettingsState();
}

class _SmeesSettingsState extends State<SmeesSettings> {
  bool offlineMode = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES-Settings"),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text("Theme"),
            leading: Icon(Icons.color_lens),
            children: [
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: const Text("Switch Dardk Mode"),
                  trailing: Switch(value:darkMode, onChanged: (value){
                  setState((){
                    darkMode = !darkMode;
                  });
                }),),
                
            ],
          ),
          ExpansionTile(
            title: Text("Use Mode"),
            leading: Icon(Icons.mode),
            children: [
                ListTile(
                  leading: Icon(Icons.work),
                  title: const Text("Switch Off Offline Mode"),
                  trailing: Switch(value:offlineMode, onChanged: (value){
                  setState((){
                    offlineMode = !offlineMode;
                  });
                }),),
                
            ],
          ),
      ],)
    );
  }
}