import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/themeprovider.dart';
import 'package:provider/provider.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Center(
          child: CupertinoSwitch(value: Provider.of<Themeprovider>(context).isdarkMode, 
          onChanged: (value)=> Provider.of<Themeprovider>(context,listen: false).toggleTheme()),
        ),
      );
  }
}