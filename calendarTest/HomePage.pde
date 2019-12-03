import java.util.*;
import java.util.GregorianCalendar;
import java.util.Date;

class HomePage {

  AppDesign appDesign;
  Calendar calendar;

  int year;
  boolean bLeapYear;
  String pageName = "Home";

  long yearMillisTotal = 0L;
  long millisInLeapYear = 31622400000L;
  long millisInNormalYear = 31536000000L;
  long millis31Day = 2678400000L;
  long millis30Day = 2592000000L;
  //long millis29Day = 2505600000L;
  long millis28Day = 2419200000L;
  int millisInDay = 86400000;

  long[] monthMillisTotal = {0, millis31Day, millis28Day + millis31Day, millis28Day + millis31Day * 2, millis28Day + millis31Day * 2 + millis30Day, 
    millis28Day + millis31Day * 3 + millis30Day, millis28Day + millis31Day * 3 + millis30Day * 2, millis28Day + millis31Day * 4 + millis30Day * 2, 
    millis28Day + millis31Day * 5 + millis30Day * 2, millis28Day + millis31Day * 5 + millis30Day * 3, millis28Day + millis31Day * 6 + millis30Day * 3, 
    millis28Day + millis31Day * 6 + millis30Day * 4};
  int dayOfWeek;

  float calendarSquar;
  float gridX;
  float gridY;
  int daysAMonth;
  int amountOfDaysRemove;
  int dayToShow;
  long millisToShow;

  String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Augt", "Sep", "Okt", "Nov", "Dec"};
  String[] dayNames = {"Man", "Tir", "ons", "Tor", "Fre", "Lor", "Son"};
  int monthValue;

  Table taskDatabase;
  Table taskTable;
  float taskArray[];

  int taskToDisplay;
  boolean showTaskWindow = false;
  int taskWindowW = width - 400;
  int taskWindowH = height - 400;

  HomePage() {
    year = year();
    millisCal();

    if (height > width) {
      calendarSquar = width/9;
    }
    if (width > height) {
      calendarSquar = height/9;
    }

    gridX = calendarSquar;
    gridY = calendarSquar;

    appDesign = new AppDesign(pageName);
    calendar = new GregorianCalendar();
    monthValue = month();

    taskDatabase = loadTable("taskDatabase.csv", "header");
    taskTable = loadTable("taskTimeStamps.csv", "header");
    taskArray = new float[0];
  }

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

  void monthPicker() {
    fill(255);
    rect(width/2 - 3.5 * calendarSquar, calendarSquar, 7*calendarSquar, calendarSquar);
    
    textSize(calendarSquar/3*2);
    fill(0);
    triangle(width/2 - 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 - 3 * calendarSquar, 1.25 * calendarSquar, width/2 - 3 * calendarSquar, 1.75 * calendarSquar);
    triangle(width/2 + 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 + 3 * calendarSquar, 1.25 * calendarSquar, width/2 + 3 * calendarSquar, 1.75 * calendarSquar);
    textAlign(CENTER, CENTER);
    text(monthNames[monthValue-1] + " " + year, width/2, 1.5 * calendarSquar);
  }

  void millisCal() {
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
  
  void dayGrid(){
    fill(255);
    stroke(2);
    textSize(calendarSquar/3);
    textAlign(CENTER,CENTER);
    fill(255);
    for(int i = 0; i < 7; i++){
      rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), 2 * calendarSquar, calendarSquar, calendarSquar/2);
    }
    fill(0);
    for(int i = 0; i < 7; i++){
      text(dayNames[i], i * calendarSquar + (width/2 - 3 * calendarSquar), 2.25 * calendarSquar);
    }
  }

  void calendarGrid() {
    calendar.set(Calendar.MONTH, monthValue);
    calendar.set(Calendar.DAY_OF_MONTH, 1);
    calendar.set(Calendar.YEAR, year);
    dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 6; j++) {
        stroke(0);
        strokeWeight(1);
        fill(255);
        rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar*2.5, calendarSquar, calendarSquar);
        
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

  void updateTaskArray() {
    taskArray = new float[0];
    for (int i = 0; i < taskTable.getRowCount(); i++) {
      TableRow row = taskTable.getRow(i);
      long startTime = row.getLong("start");
      if (startTime >= millisToShow && startTime <= millisToShow + millisInDay) {
        float idNumber = row.getFloat("id");
        taskArray = (float[]) append(taskArray, idNumber);
      }
    }
  }

  void taskDisplayer() {
    for (int i = 0; i < taskArray.length; i++) {
      int taskId = floor(taskArray[i]);
      TableRow row = taskDatabase.getRow(taskId-1);
      String taskName = row.getString("name");

      fill(255);
      rect(width/2 - 3 * calendarSquar, 8.5 * calendarSquar+calendarSquar*i, 6 * calendarSquar, calendarSquar);
      
      textSize(calendarSquar/3*1.5);
      fill(0);
      textAlign(CENTER, TOP);
      text(taskName, width/2, 8.5 * calendarSquar + calendarSquar * i);
    }
  }

  void taskWindow() {
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
      text("dato: " + taskDay + "/" + monthNames[taskMonth], width/2, height/2 + taskWindowH/3.4);
      text("klokken: " + taskHour + ":" + taskMinut, width/2, height/2 + taskWindowH/2.8);
      
      if(row.getInt("completed") == 0){
        text("Denne opgave er ikke klaret", width/2, height/2 + taskWindowH/2.4);
      }
      if(row.getInt("completed") == 1){
        text("Denne opgave er klaret", width/2, height/2 + taskWindowH/2.4);
      }
    }
  }

  int pageNumberReturn() {
    return appDesign.programState;
  }

  void mouseReleased() {
    if (mouseX >= width/2 - 3.25 * calendarSquar && mouseX <= width/2 - 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar) {
      monthValue -= 1;
      taskArray = new float[0];
    }
    if (mouseX <= width/2 + 3.25 * calendarSquar && mouseX >= width/2 + 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar) {
      monthValue += 1;
      taskArray = new float[0];
    }
    if (monthValue <= 0) {
      monthValue = 12;
      year -= 1;
    }
    if (monthValue >= 13) {
      monthValue = 1;
      year += 1;
    }
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

  void mousePressed() {
    if(showTaskWindow != true){ 
      for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 7; i++) {
          if (mouseX >= i * calendarSquar + (width/2 - 3.5 * calendarSquar) && mouseX <= i * calendarSquar + (width/2 - 3.5 * calendarSquar)+calendarSquar &&
            mouseY >= j * calendarSquar + calendarSquar * 2.5 && mouseY <= j * calendarSquar + calendarSquar * 3.5) {
            dayToShow = (i - dayOfWeek - amountOfDaysRemove) + j * 7;
            millisToShow = yearMillisTotal + (dayToShow - 1) * millisInDay + monthMillisTotal[monthValue - 1];
  
            if (monthValue == 2 && bLeapYear == true) {
              millisToShow += millisInDay;
            }         
            updateTaskArray();
          }
        }
      }
    }
    if(showTaskWindow == true){
      showTaskWindow = false;
    }
  }
   
}
