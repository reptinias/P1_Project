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
  long millisInLeapYear = 31622400000L;
  long millisInNormalYear = 31536000000L;
  long millis31Day = 2678400000L;
  long millis30Day = 2592000000L;
  long millis28Day = 2419200000L;
  int millisInDay = 86400000;
  int millisInHour = 3600000;
  int millisInMinut = 60000;

  long[] monthMillisTotal = {0, millis31Day, millis28Day + millis31Day, millis28Day + millis31Day * 2, millis28Day + millis31Day * 2 + millis30Day, 
    millis28Day + millis31Day * 3 + millis30Day, millis28Day + millis31Day * 3 + millis30Day * 2, millis28Day + millis31Day * 4 + millis30Day * 2, 
    millis28Day + millis31Day * 5 + millis30Day * 2, millis28Day + millis31Day * 5 + millis30Day * 3, millis28Day + millis31Day * 6 + millis30Day * 3, 
    millis28Day + millis31Day * 6 + millis30Day * 4};

  long taskTime;
  long[] taskTimeStart;
  long timeStampStart;
  double timeStampEnd;

  TaskAddBackEnd(float id, int taskYear, int taskMonth, int taskDay, int taskHour, int taskMinut, float taskDuration, int taskRate, int oneDayTask) {
    taskDatabase = loadTable("taskDatabase.csv", "header");
    taskTimeStamps = loadTable("taskTimeStamps.csv", "header");

    this.id = id;
    this.taskYear = taskYear;
    this.taskMonth = taskMonth;
    this.taskDay = taskDay;
    this.taskHour = taskHour;
    this.taskMinut = taskMinut;
    this.taskDuration = taskDuration;
    this.taskRate = taskRate;
    this.oneDayTask = oneDayTask;
  }

  void runCalculation() {
    millisCal();
    taskTimeCal();
  }

  void millisCal() {
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

  void taskTimeCal() {
    taskTime = yearMillisTotal + monthMillisTotal[taskMonth] + (taskDay * millisInDay) + (taskHour * millisInHour) + (taskMinut * millisInMinut);
  }

  void oneDayTaskCal() {
  }

  void updateDatasheet() {
    TableRow row = taskTimeStamps.addRow();
    if (oneDayTask == 1) {
      timeStampStart = taskTime;
      timeStampEnd = taskTime + (taskDuration * millisInHour);
      row.setFloat("id", id);
      row.setLong("start", timeStampStart);
      row.setDouble("slut", timeStampEnd);
    } else {
    }
  }
}
