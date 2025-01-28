import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smees/models/user.dart';

import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/user_provider.dart';

class UserProfile extends StatelessWidget {

  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    
    final userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    
    
    return Center(
      
      child: ListView(
        children: [
          const UserStatusCard(),
          // UserStatistics(),
          ExpansionTile(
            title: Text(
            "User Information",
            style: TextStyle(
              color: Colors.green[900],
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          
            children: [
              
              ListTile(
                title: Text("Username: ${user != null ? user.username : 'guest'}"),
                subtitle: Text("Department: "),
                trailing: TextButton(child: Text("Update"), onPressed: (){},),
              ),
              ListTile(
                title: Text("Email: "),
                subtitle: Text("Password: "),
                trailing: TextButton(child: Text("Change Password"), onPressed: (){},),
              ),
            ],
          )
          
        ],
      ),
    );
  }
}
