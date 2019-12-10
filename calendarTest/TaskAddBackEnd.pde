class TaskAddBackEnd {
  //Declare variables
  Table taskDatabase;
  Table taskTimeStamps;

  boolean bLeapYear;

  float id;
  int taskYear;
  int taskMonth;
  int taskDay;
  int taskHour;
  int taskMinut;
  float taskDuration;
  int taskRate;
  int oneDayTask;
  
  //initialize long variables, that contains the amout of millis secunds, in a given time period
  long yearMillisTotal = 0L;
  long thisYearInMillis = 0L;
  long millisInLeapYear = 31622400000L;
  long millisInNormalYear = 31536000000L;
  long millis31Day = 2678400000L;
  long millis30Day = 2592000000L;
  long millis28Day = 2419200000L;
  int millisInDay = 86400000;
  int millisInHour = 3600000;
  int millisInMinut = 60000;
  int millisInPause = 3600000;
  long[] monthMillisTotal = {0, millis31Day, millis28Day + millis31Day, millis28Day + millis31Day * 2, millis28Day + millis31Day * 2 + millis30Day, 
    millis28Day + millis31Day * 3 + millis30Day, millis28Day + millis31Day * 3 + millis30Day * 2, millis28Day + millis31Day * 4 + millis30Day * 2, 
    millis28Day + millis31Day * 5 + millis30Day * 2, millis28Day + millis31Day * 5 + millis30Day * 3, millis28Day + millis31Day * 6 + millis30Day * 3, 
    millis28Day + millis31Day * 6 + millis30Day * 4};

  long taskTime;
  double[] timeStampStartArray;
  double[] timeStampEndArray;
  double timeStampStart;
  double timeStampEnd;
  int extraDay;

  TaskAddBackEnd(float id, int taskYear, int taskMonth, int taskDay, int taskHour, int taskMinut, float taskDuration, int taskRate, int oneDayTask) {
    //assigns values to the variables
    taskDatabase = loadTable("taskDatabase.csv", "header");
    taskTimeStamps = loadTable("taskTimeStamps.csv", "header");

    timeStampStartArray = new double[0];
    timeStampEndArray = new double[0];

    this.id = id;
    this.taskYear = taskYear;
    this.taskMonth = taskMonth;
    this.taskDay = taskDay;
    this.taskHour = taskHour;
    this.taskMinut = taskMinut;
    this.taskDuration = taskDuration;
    this.taskRate = taskRate;
    this.oneDayTask = oneDayTask;

    //calls functions in the constructer, because they are only runned once
    millisCalTaskYear();
    millisCalYear();
    taskTimeCal();
    timeStampArrayUpdate();
    updateDatasheet();
  }
  
  //Calculates the millis secunds in the year, that the task is set in
  void millisCalTaskYear() {
    for (int i = 1970; i < taskYear; i++) {
      if (i % 400 == 0) {
        bLeapYear = true;
      } else if (i % 100 == 0) {
        bLeapYear = false;
      } else if (i % 4 == 0) {
        bLeapYear = true;
      } else {
        bLeapYear = false;
      }
      if (bLeapYear) {
        yearMillisTotal += millisInLeapYear;
      } else {
        yearMillisTotal += millisInNormalYear;
      }
    }
    yearMillisTotal -= 3600000L;
  }
  
  //calculates the millis secunds in this year, to make the first time stamp
  void millisCalYear() {
    for (int i = 1970; i < year(); i++) {
      if (i % 400 == 0) {
        bLeapYear = true;
      } else if (i % 100 == 0) {
        bLeapYear = false;
      } else if (i % 4 == 0) {
        bLeapYear = true;
      } else {
        bLeapYear = false;
      }
      if (bLeapYear) {
        thisYearInMillis += millisInLeapYear;
      } else {
        thisYearInMillis += millisInNormalYear;
      }
    }
    thisYearInMillis -= 3600000L;
  }
  
  //calculates the millis secunds there is, to the given task day
  void taskTimeCal() {
    taskTime = yearMillisTotal + monthMillisTotal[taskMonth - 1] + ((long)(taskDay-1) * millisInDay) + ((long)(taskHour) * millisInHour) + ((long)(taskMinut) * millisInMinut);
  }
  
  //makes an array, that contains the time stamps, that will be put in the datasheet
  void timeStampArrayUpdate() {
    //checks if the task is a task, that can be spread over more days
    if (oneDayTask == 0) {
      //time stamp til to start with. the time stamp is sat at 8 o'clock the next day
      extraDay = 0;
      timeStampStart = thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour);
      timeStampEnd = timeStampStart + millisInHour;
      //checks if the task duration is a even number
      if ( taskDuration % 2 == 0 ) {
        //divides taskduration up, so you work one hour per session
        for (int i = 0; i < taskDuration; i++) {
          //run the algoritme code with i as a argument
          algoritmeCode(i);
        }
      }
      //if task duration isn't even
      else {
        //Calculates the remaining time there is, when you have divided taskDuration with a round down taskDuration
        float remaining = taskDuration % floor(taskDuration);
        
        if (remaining <=0.49) {
          for (int i = 0; i < taskDuration; i++) {            
            //if it is the first time stamp, put the ekstra time on the first time stamp
            if (i == 0) {
              timeStampEnd = timeStampStart + (millisInHour * (1 + remaining));
            } 
            //set the time stamp to be one hour long
            else {
              timeStampEnd = timeStampStart + millisInHour;
            }
            //run the algoritme code with i as a argument
            algoritmeCode(i);
          }
        } else if (remaining >= 0.5) {
          for (int i = 0; i <= taskDuration; i++) {
            if (i == taskDuration) {
              timeStampEnd = timeStampStart + (millisInHour * remaining);
            } else {
              timeStampEnd = timeStampStart + millisInHour;
            }
            //run the algoritme code with i as a argument
            algoritmeCode(i);
          }
        }
      }
    }
  }

  void algoritmeCode(int i) {
    println(i);
    println(taskTime);
    println(timeStampStart);
    println(timeStampEnd);
    println(taskYear + " " + taskMonth + " " + taskDay + " " + taskHour + " " + taskMinut + " " + taskDuration + " " + taskRate);

    //goes through the whole datasheet, to check the time stamps
    for (int j = 0; j < taskTimeStamps.getRowCount(); j++) {
      //sets the row we are looking at, to be row j
      TableRow row = taskTimeStamps.getRow(j);
      //assigning a value to the end time stamp
      timeStampEnd = timeStampStart + (double)(millisInHour);
      
      //check if the new task, i overlapping with task in the row
      if (timeStampStart >= row.getDouble("start") && timeStampStart <= row.getDouble("slut")) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      } else if (timeStampEnd >= row.getDouble("start") && timeStampEnd <= row.getDouble("slut")) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      } else if (row.getDouble("start") >= timeStampStart && row.getDouble("start") <= timeStampEnd) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      }
    }
    //after going through the datasheet, we append the time stamps into arrays
    timeStampStartArray = (double[]) append(timeStampStartArray, timeStampStart);
    timeStampEndArray = (double[]) append(timeStampEndArray, timeStampEnd);
    
    //Check what the next day is, after the time stamp, that is put into the time stamp array    
    while (timeStampEndArray[i] >= thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour)) {
      extraDay++;
    }
    
    //moves the new start time stamp to 8 o'clock the next morning
    timeStampStart = thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour);
  }
  
  //puts the variables into the task datasheets.
  void updateDatasheet() {
    //starts by check if the new task is a one day task
    if (oneDayTask == 0) {
      //goes through the time stamp arraies and adds the time stamps to the datasheet
      for (int i = 0; i < timeStampStartArray.length; i++) {
        //adds a new row
        TableRow row = taskTimeStamps.addRow();
        
        //adds the variables to the datasheet
        row.setFloat("id", id + float(i)/float(100));
        row.setDouble("start", timeStampStartArray[i]);
        row.setDouble("slut", timeStampEndArray[i]);
        
        //saves the datasheet
        saveTable(taskTimeStamps, "taskTimeStamps.csv");
      }
    }

    if (oneDayTask == 1) {
      //add a row
      TableRow row = taskTimeStamps.addRow();
      
      //sets the time stamps start to be the chossen day
      //sets the time stamp end to be the chossen day, plus task duration times the amount of millis secunds in a hour
      timeStampStart = taskTime;
      timeStampEnd = taskTime + (taskDuration * millisInHour);
      
      //puts variables into the datasheet
      row.setFloat("id", id);
      row.setDouble("start", timeStampStart);
      row.setDouble("slut", timeStampEnd);
      
      //saves the datasheet
      saveTable(taskTimeStamps, "taskTimeStamps.csv");
    }
  }
}
