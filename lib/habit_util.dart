//give a habit list of completion days
//is the habit completed today
import 'package:habittracker/habit.dart';

bool ishabitcompletedToday(List<DateTime> completedDays){
  final today=DateTime.now();
  return completedDays.any((date) => 
  date.year==today.year &&  
  date.month==today.month &&  
  date.day==today.day 

  );
}
//prepare heatmap dataset
Map<DateTime,int> prepareheatDataset(List<Habit> habits){
  Map<DateTime,int> dataset={};

  for(var habit in habits){
    for(var date in habit.completedDays){
      //normalize date to avoid time mismatch
      final normalizedDate=DateTime(date.year,date.month,date.day);

      //if the date is already in dataset,increment its count
      if(dataset.containsKey(normalizedDate)){
        dataset[normalizedDate]= dataset[normalizedDate]!+1;
      }else{
        //initialize it with a count of 1
        dataset[normalizedDate]=1;

      }

    }
  }

  return dataset;

}