//libary import
import java.util.*;
import java.util.GregorianCalendar;
import java.util.Date;

class HomePage {
  
  //declares the classes
  AppDesign appDesign;
  Calendar calendar;
  Calendar converterCal;
  
  int year;
  boolean bLeapYear;
  String pageName = "Home";
  
  //initialize long variables, that contains the amout of millis secunds, in a given time period
  long yearMillisTotal = 0L;
  long millisInLeapYear = 31622400000L;
  long millisInNormalYear = 31536000000L;
  long millis31Day = 2678400000L;
  long millis30Day = 2592000000L;
  long millis28Day = 2419200000L;
  int millisInDay = 86400000;
  long[] monthMillisTotal = {0, millis31Day, millis28Day + millis31Day, millis28Day + millis31Day * 2, millis28Day + millis31Day * 2 + millis30Day, 
    millis28Day + millis31Day * 3 + millis30Day, millis28Day + millis31Day * 3 + millis30Day * 2, millis28Day + millis31Day * 4 + millis30Day * 2, 
    millis28Day + millis31Day * 5 + millis30Day * 2, millis28Day + millis31Day * 5 + millis30Day * 3, millis28Day + millis31Day * 6 + millis30Day * 3, 
    millis28Day + millis31Day * 6 + millis30Day * 4};
  
  int dayOfWeek;

  
  float calendarSquar;
  int daysAMonth;
  int amountOfDaysRemove;
  int dayToShow;
  long millisToShow;

  //string arrays that contains names of the months and days
  String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Augt", "Sep", "Okt", "Nov", "Dec"};
  String[] dayNames = {"Man", "Tir", "ons", "Tor", "Fre", "Lor", "Son"};
  int monthValue;
  
  Table taskDatabase;
  Table taskTable;
  int taskArray[];
  double taskTime[];
  double remainingTime;

  int taskToDisplay;
  boolean showTaskWindow = false;
  int taskWindowW = width - 400;
  int taskWindowH = height - 400;

  HomePage() {
    year = year();
    millisCal();
    
    //check if width is greater that height and reversed
    if (height > width) {
      calendarSquar = width/9;
    }
    if (width > height) {
      calendarSquar = height/9;
    }
    
    //assigns the class declarations and other variables
    appDesign = new AppDesign(pageName);
    calendar = new GregorianCalendar();
    converterCal = new GregorianCalendar();
    monthValue = month();
    taskDatabase = loadTable("taskDatabase.csv", "header");
    taskTable = loadTable("taskTimeStamps.csv", "header");
    
    //Create empty arrays
    taskArray = new int[0];
    taskTime = new double[0];
  }

  //function to update the calendar, when a task have been added
  void updateCalendar() {
    taskDatabase = loadTable("taskDatabase.csv", "header");
    taskTable = loadTable("taskTimeStamps.csv", "header");
  }
  
  //calls functions, so only one function needs to bee called
  void display() {
    textAlign(CENTER, CENTER);
    textSize(calendarSquar/3);
    fill(255);
    background(0);

    appDesign.draw();

    dayGrid();
    dayCal();
    monthPicker();
    taskDisplayer();
    calendarGrid();
    taskWindow();
  }
  
  //function that visiulizes the month picker, in the top of the calendar
  void monthPicker() {
    //draws the button and text connector
    fill(255);
    rect(width/2 - 3.5 * calendarSquar, calendarSquar, 7*calendarSquar, calendarSquar);

    //creates to arrows to navigate calendar
    textSize(calendarSquar/3*2);
    fill(0);
    triangle(width/2 - 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 - 3 * calendarSquar, 1.25 * calendarSquar, width/2 - 3 * calendarSquar, 1.75 * calendarSquar);
    triangle(width/2 + 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 + 3 * calendarSquar, 1.25 * calendarSquar, width/2 + 3 * calendarSquar, 1.75 * calendarSquar);
    
    //puts month names and the year
    textAlign(CENTER, CENTER);
    text(monthNames[monthValue-1] + " " + year, width/2, 1.5 * calendarSquar);
  }
  
  //calculates the amount of millis secunds since epoch
  void millisCal() {
    yearMillisTotal = 0;
    for (int i = 1970; i < year; i++) {
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

  //calculates how many days needs to be displayed in the calendar
  void dayCal() {
    fill(255);
    if (monthValue == 1 || monthValue == 3 || monthValue == 5 || monthValue == 7 || monthValue == 8 || monthValue == 10 || monthValue == 12) {
      daysAMonth = 31;
      amountOfDaysRemove = 1;
    }
    if (monthValue == 2) {
      if (year % 400 == 0) {
        bLeapYear = true;
      } else if (year % 100 == 0) {
        bLeapYear = false;
      } else if (year % 4 == 0) {
        bLeapYear =true;
      } else {
        bLeapYear = false;
      }
      if (bLeapYear) {
        daysAMonth = 29;
        amountOfDaysRemove = 10;
      } else {
        daysAMonth = 28;
        amountOfDaysRemove = 4;
      }
    }

    if (monthValue == 4 || monthValue == 6 || monthValue == 9 || monthValue == 11) {
      daysAMonth = 30;
      amountOfDaysRemove = 2;
    }
  }

  //makes the rectangles and adds the day names, right under the month picker
  void dayGrid() {
    fill(255);
    stroke(2);
    textSize(calendarSquar/3);
    textAlign(CENTER, CENTER);
    fill(255);
    for (int i = 0; i < 7; i++) {
      rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), 2 * calendarSquar, calendarSquar, calendarSquar/2);
    }
    fill(0);
    for (int i = 0; i < 7; i++) {
      text(dayNames[i], i * calendarSquar + (width/2 - 3 * calendarSquar), 2.25 * calendarSquar);
    }
  }
  
  //Makes a grid of squares and adds the day numbers to the grid
  void calendarGrid() {
    //sets a calendar to be the first day of the picked month, so we have know where to put the first day, in the grid
    calendar.set(Calendar.MONTH, monthValue);
    calendar.set(Calendar.DAY_OF_MONTH, 1);
    calendar.set(Calendar.YEAR, year);
    dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
    
    //Now makes the grid of squars and numbers
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 6; j++) {
        //makes the squars
        stroke(0);
        strokeWeight(1);
        fill(255);
        rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar*2.5, calendarSquar, calendarSquar);

        //prints the numbers
        textSize(calendarSquar/3*1.5);
        fill(255);
        textAlign(CENTER, CENTER);
        if ((i - dayOfWeek - amountOfDaysRemove) + j * 7 > 0 && (i - dayOfWeek + 2) + j * 7 < daysAMonth + amountOfDaysRemove + 3) {
          fill(0);
        } else {
          fill(255);
        }
        text((i - dayOfWeek - amountOfDaysRemove) + j * 7, calendarSquar * i + (width/2 - 3 * calendarSquar), j * calendarSquar + 3 * calendarSquar);
      }
    }
  }
  
  //finds the task that needs to be shown, and put the task's id in an array
  void updateTaskArray() {
    taskArray = new int[0];
    for (int i = 0; i < taskTable.getRowCount(); i++) {
      TableRow row = taskTable.getRow(i);
      double startTime = row.getDouble("start");
      if (startTime >= millisToShow && startTime <= millisToShow + millisInDay) {
        float idNumber = row.getFloat("id");
        taskArray = (int[]) append(taskArray, floor(idNumber));
        taskTime = (double[]) append(taskTime, startTime);
      }
    }
  }
  
  //goes through the task id's and print the task's name in a box, under the calendar grid
  void taskDisplayer() {
    textAlign(CENTER, TOP);
    
    //prints the date, at the top of the box
    if(dayToShow > 0 && dayToShow < daysAMonth + amountOfDaysRemove){
      fill(255);
      rect(width/2 - 3 * calendarSquar, 8.5 * calendarSquar, 6 * calendarSquar, calendarSquar);
      fill(0);
      text(dayToShow + "/" + monthNames[monthValue-1],width/2, 8.5 * calendarSquar);
    }
    
    //prints the task in the box along with the starting time
    for (int i = 0; i < taskArray.length; i++) {
      //finds the task names based on the ids
      int taskId = floor(taskArray[i]);
      TableRow row = taskDatabase.getRow(taskId-1);
      String taskName = row.getString("name");
      
      //converts the task's start time stamp, into a date
      converterCal.setTimeInMillis((long)(taskTime[i]));
      int hour = converterCal.get(Calendar.HOUR_OF_DAY);
      int minute = converterCal.get(Calendar.MINUTE);
      
      //draws the rectangles, that the task names will be put in
      fill(255);
      rect(width/2 - 3 * calendarSquar, 9.5 * calendarSquar+calendarSquar*i, 6 * calendarSquar, calendarSquar);

      //prints the name and start time
      textSize(calendarSquar/3*1.5);
      fill(0);
      text(taskName + " " + nf(hour, 2) + ":" + nf(minute, 2), width/2, 9.5 * calendarSquar + calendarSquar * i);
    }
  }
  
  //Creates a window, that display information about the task
  void taskWindow() {
    //checks if the window shold be displayed
    if (showTaskWindow == true) {
      rectMode(CENTER);
      rect(width/2, height/2, taskWindowW, taskWindowH);

      textSize(calendarSquar/3);
      fill(0);
      TableRow row = taskDatabase.getRow(taskToDisplay-1);

      String taskName = row.getString("name");
      text(taskName, width/2, height/2 - taskWindowH/2.2);

      String taskDescription = row.getString("description");
      text(taskDescription, width/2, height/2 - taskWindowH/2.6);

      int taskMonth = row.getInt("month");
      int taskDay = row.getInt("day");
      int taskHour = row.getInt("hour");
      int taskMinut = row.getInt("minut");
      text("dato: " + taskDay + "/" + monthNames[taskMonth - 1], width/2, height/2 + taskWindowH/3.4);
      text("klokken: " + nf(taskHour, 2) + ":" + taskMinut, width/2, height/2 + taskWindowH/2.8);

      if (row.getInt("completed") == 0) {
        text("Denne opgave er ikke klaret", width/2, height/2 + taskWindowH/2.4);
      }
      if (row.getInt("completed") == 1) {
        text("Denne opgave er klaret", width/2, height/2 + taskWindowH/2.4);
      }
    }
  }
  
  //returns the pageNumber
  int pageNumberReturn() {
    return appDesign.programState;
  }
  
  //Checks if the mouse is released
  void mouseReleased() {
    //checks if it's the month picker that is pressed
    if (mouseX >= width/2 - 3.25 * calendarSquar && mouseX <= width/2 - 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar) {
      //chenges the month value to be one less and resets the task ids and the day to show
      monthValue -= 1;
      taskArray = new int[0];
      dayToShow = 0;
    }
    if (mouseX <= width/2 + 3.25 * calendarSquar && mouseX >= width/2 + 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar) {
      //chenges the month value to be one higher and resets the task ids and the day to show
      monthValue += 1;
      taskArray = new int[0];
      dayToShow = 0;
    }
    
    //checks what the monthvalue is and changes the month shown, to the correct month
    if (monthValue <= 0) {
      monthValue = 12;
      year -= 1;
      millisCal();
    }
    if (monthValue >= 13) {
      monthValue = 1;
      year += 1;
      millisCal();
    }
    
    //checks what task is pressed on, under the calendar grid
    if (taskArray.length != 0) {
      for (int i = 0; i < taskArray.length; i++) {
        if (mouseX >= width/2 - 3 * calendarSquar && mouseX <= width/2 + 3 * calendarSquar && 
          mouseY >= 8.5 * calendarSquar + i * calendarSquar && mouseY <= 9.5 * calendarSquar + i * calendarSquar) {
          showTaskWindow = true;
          taskToDisplay = floor(taskArray[i]);
        }
      }
    }
  }
  
  //checks if the mouse is pressed
  void mousePressed() {
    if (showTaskWindow != true) { 
      for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 7; i++) {
          //checks what day is pressed in the calendar
          if (mouseX >= i * calendarSquar + (width/2 - 3.5 * calendarSquar) && mouseX <= i * calendarSquar + (width/2 - 3.5 * calendarSquar)+calendarSquar &&
            mouseY >= j * calendarSquar + calendarSquar * 2.5 && mouseY <= j * calendarSquar + calendarSquar * 3.5) {
            //calculates the day that will be shown
            dayToShow = (i - dayOfWeek - amountOfDaysRemove) + j * 7;
            
            //Calculates the amount of millis secunds from epuch to the picked day
            millisToShow = yearMillisTotal + ((dayToShow - 1) * (long)(millisInDay)) + monthMillisTotal[monthValue - 1];
            
            //checks if it's a leapyear and if the date is later then february and add one days millis secunds
            if (monthValue >= 2 && bLeapYear == true) {
              millisToShow += millisInDay;
            }
            
            //update the task ids that is shown
            updateTaskArray();
          }
        }
      }
    }
    if (showTaskWindow == true) {
      showTaskWindow = false;
    }
  }
}
