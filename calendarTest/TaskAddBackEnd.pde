class TaskAddBackEnd {
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

    millisCalTaskYear();
    millisCalYear();
    taskTimeCal();
    timeStampArrayUpdate();
    updateDatasheet();
  }

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

  void taskTimeCal() {
    taskTime = yearMillisTotal + monthMillisTotal[taskMonth - 1] + ((long)(taskDay-1) * millisInDay) + ((long)(taskHour) * millisInHour) + ((long)(taskMinut) * millisInMinut);
  }

  void timeStampArrayUpdate() {
    if (oneDayTask == 0) {
      //time stamp til at starte med. Sat til at være klokken 8 næste dag
      extraDay = 0;
      timeStampStart = thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour);
      timeStampEnd = timeStampStart + millisInHour;
      //tjekker om taskDuration er et helt tal
      if ( taskDuration % 2 == 0 ) {
        println("i'm even!");
        //deler timeDuration op, så det kommer et time stamp for hver time
        for (int i = 0; i < taskDuration; i++) {
          algoritmeCode(i);
        }
      } else {
        println("I can't even.");
        float remaining = taskDuration % floor(taskDuration);
        if (remaining <=0.49) {
          for (int i = 0; i < taskDuration; i++) {            
            if (i == 0) {
              timeStampEnd = timeStampStart + (millisInHour * (1 + remaining));
            } else {
              timeStampEnd = timeStampStart + millisInHour;
            }
            algoritmeCode(i);
          }
        } else if (remaining >= 0.5) {
          for (int i = 0; i < taskDuration; i++) {
            if (i == taskDuration - 1) {
              timeStampEnd = timeStampStart + (millisInHour * remaining);
            } else {
              timeStampEnd = timeStampStart + millisInHour;
            }
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

    for (int j = 0; j < taskTimeStamps.getRowCount(); j++) {
      TableRow row = taskTimeStamps.getRow(j);
      println(row.getDouble("start"));
      println(row.getDouble("slut"));
      timeStampEnd = timeStampStart + (double)(millisInHour);
      
      if (timeStampStart >= row.getDouble("start") && timeStampStart <= row.getDouble("slut")) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      } else if (timeStampEnd >= row.getDouble("start") && timeStampEnd <= row.getDouble("slut")) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      } else if (row.getDouble("start") >= timeStampStart && row.getDouble("start") <= timeStampEnd) {
        timeStampStart = row.getDouble("slut") + millisInPause;
      }
    }
    timeStampStartArray = (double[]) append(timeStampStartArray, timeStampStart);
    timeStampEndArray = (double[]) append(timeStampEndArray, timeStampEnd);
        
    while (timeStampEndArray[i] >= thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour)) {
      extraDay++;
    }

    timeStampStart = thisYearInMillis + monthMillisTotal[month() - 1] + ((long)(day() + extraDay) * millisInDay) + (long)(8 * millisInHour);
  }

  void updateDatasheet() {
    if (oneDayTask == 0) {
      println(timeStampStartArray);
      for (int i = 0; i < timeStampStartArray.length; i++) {
        TableRow row = taskTimeStamps.addRow();
        row.setFloat("id", id + float(i)/float(100));
        row.setDouble("start", timeStampStartArray[i]);
        row.setDouble("slut", timeStampEndArray[i]);
        saveTable(taskTimeStamps, "taskTimeStamps.csv");
      }
    }

    if (oneDayTask == 1) {
      TableRow row = taskTimeStamps.addRow();
      timeStampStart = taskTime;
      timeStampEnd = taskTime + (taskDuration * millisInHour);
      row.setFloat("id", id);
      row.setDouble("start", timeStampStart);
      row.setDouble("slut", timeStampEnd);
      saveTable(taskTimeStamps, "taskTimeStamps.csv");
      println("oneDayTask skulle være gemt");
    }
  }
}
