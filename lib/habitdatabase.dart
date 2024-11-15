import 'package:flutter/material.dart';
import 'package:habittracker/appsettings.dart';
import 'package:habittracker/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Habitdatabase extends ChangeNotifier{
  static late Isar isar;

  /*
setup
  */

  //initialize database
  static Future<void> initialize()async {
    final dir=await getApplicationDocumentsDirectory();
     
    isar=await Isar.open([HabitSchema,AppsettingsSchema], directory: dir.path);
  }


  //save first date of app startup(for heatmap)
  Future<void> savefirstLaunchdate() async{
    final existingSettings=await isar.appsettings.where().findFirst();
    if(existingSettings==null){
      final settings=Appsettings()..firstLaunchDate=DateTime.now();
      await isar.writeTxn(()=> isar.appsettings.put(settings));
    }
  }


  //get first date of app startup(for heatmap)
  Future<DateTime?> getfirstLaunchdate() async{
    final settings=await isar.appsettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
crud operations
  */

  //list of habits
  final List<Habit> currentHabits=[];

  //create-add new habit
  Future<void> addHabit(String habitName) async{
    //create new habit
    final newHabit=Habit()..name=habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-reload frommdb
    readHbaits();

  }


  //read-read/save habit from database
  Future<void> readHbaits() async{
    //fetch all habits from db
    List<Habit> fetchedHabits=await isar.habits.where().findAll();


    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //update ui
    notifyListeners();


  }


  //update-check habit on/off
  Future<void> updatehabitCompletion(int id,bool isCompleted) async{
    //find the specific habit
    final habit=await isar.habits.get(id);

    //update completion status
    if(habit!=null){
      await isar.writeTxn(() async{
        //if the habit is completed-> add current date to the completedays list
        if(isCompleted && !habit.completedDays.contains(DateTime.now())){
          //today
          final today=DateTime.now();

          //add current date if not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day
            )
          );

        }
        //if habit is not completed -> remove the current date from list
        else{
          //remove the current date if the habit is marked as not complete
          habit.completedDays.removeWhere((date)=>
          date.year == DateTime.now().year && 
          date.month == DateTime.now().month && 
          date.day == DateTime.now().day
          );

        }
        //save the updated habits back to the db
        await isar.habits.put(habit);
        

      });
    }

    //re-read from db
    readHbaits();

  }


  //update-edit ahbit name
  Future<void> updatehabitName(int id,String newName) async{
    //find the specific habit
    final habit=await isar.habits.get(id);

    //update habit name
    if(habit!=null){
      //update name
      await isar.writeTxn(() async{
        habit.name=newName;
        //save updated habit back to the dTBase
        await isar.habits.put(habit);

      });

    }

    //re-read from db
    readHbaits();

  }

  //delete-delte habit
  Future<void> deleteHabit(int id) async{
    //perform the delete
    await isar.writeTxn(()async{
        await isar.habits.delete(id);
    });

    //re-read from db
  readHbaits();

  }

}