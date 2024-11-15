import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/habitdatabase.dart';
import 'package:habittracker/homepage.dart';
import 'package:habittracker/themeprovider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //initialize database
  await Habitdatabase.initialize();
  await Habitdatabase().savefirstLaunchdate();
  
  runApp(MultiProvider(providers: [
    //habit provider
    ChangeNotifierProvider(create: (context)=> Habitdatabase(),),
 
    //theme provider
     ChangeNotifierProvider(create: (context)=> Themeprovider(),),

  ],
  child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: Size(375, 812),
      builder:(context,child)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Homepage(),
        theme: Provider.of<Themeprovider>(context).themeData,
      ),
    );
  }
}