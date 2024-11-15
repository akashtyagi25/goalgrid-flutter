
import 'package:flutter/material.dart';
import 'package:habittracker/habit.dart';
import 'package:habittracker/habit_tile.dart';
import 'package:habittracker/habit_util.dart';
import 'package:habittracker/habitdatabase.dart';
import 'package:habittracker/heatmap.dart';
import 'package:habittracker/mydrawer.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

@override
  void initState() {
    // read existing habits on app startup
    Provider.of<Habitdatabase>(context,listen: false).readHbaits();

    super.initState();
  }

//text controller
final TextEditingController textController=TextEditingController();


  //create new habit
  void createnewHabit() {
    showDialog(context: context, 
    builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: "add new habit",
          hintStyle:TextStyle(color: Theme.of(context).colorScheme.primary),
          
          
        ),
        
      ),
      actions: [
        //save button
        MaterialButton(onPressed: (){
          //get new habit name
          String newhabitName=textController.text;

          //save to db
          context.read<Habitdatabase>().addHabit(newhabitName);

          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text("save"),
        ),

        //cancel button
        MaterialButton(onPressed: (){
          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text("cancel"),)

      ],
    )
    );
  }
  //check habit on/off
  void checkhabitOnoff(bool? value,Habit habit){
    //update completion status
    if(value!=null){
      context.read<Habitdatabase>().updatehabitCompletion(habit.id, value);
    }
  }

  //edit habitbox
  void editHabitbox(Habit habit){
    //set the controller text to the habit current name
    textController.text=habit.name;

    showDialog(context: context, builder: (context)=>AlertDialog(
      content: TextField(controller: textController,),
      actions: [
       //save button
        MaterialButton(onPressed: (){
          //get new habit name
          String newhabitName=textController.text;

          //save to db
          context.read<Habitdatabase>().updatehabitName(habit.id,newhabitName);

          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text("save"),
        ),

        //cancel button
        MaterialButton(onPressed: (){
          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text("cancel"),)


      ],
    )
    );
  }


  //deletehabitbox
  void deleteHabitbox(Habit habit){
     showDialog(context: context, builder: (context)=>AlertDialog(
      title: const Text("are you want to delete this???",style: TextStyle(fontSize: 16),),
      actions: [
       //delete button
        MaterialButton(onPressed: (){
         
          //save to db
          context.read<Habitdatabase>().deleteHabit(habit.id);

          //pop box
          Navigator.pop(context);

        },
        child: const Text("delete"),
        ),

        //cancel button
        MaterialButton(onPressed: (){
          //pop box
          Navigator.pop(context);

        },
        child: const Text("cancel"),)


      ],
    )
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title:  Text("homepage"),
      ),
      drawer: const Mydrawer(),
      floatingActionButton: FloatingActionButton(onPressed: createnewHabit,
      
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Icon(Icons.add,color: Theme.of(context).colorScheme.inversePrimary,),
      ),
      body: ListView(
        children: [
          //heatmap
          _buildheatMap(),

          //habitlist
          _buildhabitList(),
        ],
      ),
    );
  }
  //build heatmap
  Widget _buildheatMap(){
    //habit database
    final habitDatabase=context.watch<Habitdatabase>();

    //current habit
    List<Habit> currentHabits=habitDatabase.currentHabits;

    //return heat map ui
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getfirstLaunchdate(), 
      builder:(context, snapshot) {
        //once data is available->build heatmap
        if(snapshot.hasData){
          return myHeatmap(startDate: snapshot.data!, datasets: prepareheatDataset(currentHabits));
        }

        //handle cases where no data is returned
        else{
          return Container();
        }

      },
      );

  }





  //build habit list
  Widget _buildhabitList(){
    //habit database
    final habitDatabase=context.watch<Habitdatabase>();

    //current habits
    List<Habit> currentHabits=habitDatabase.currentHabits;

    //return list of habits ui
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentHabits.length,
      itemBuilder:(context, index) {
      //get individual habit
      final habit=currentHabits[index];

      //check if the hait is completed today
      bool iscompletedToday=ishabitcompletedToday(habit.completedDays);

      //return habit title ui
      return HabitTile(
        text: habit.name, 
        isCompleted: iscompletedToday,
        onChanged: (value)=> checkhabitOnoff(value,habit),
        editHabit: (context)=> editHabitbox(habit),
        deleteHabit: (context)=> deleteHabitbox(habit),
        );
    },
    );
  }
}