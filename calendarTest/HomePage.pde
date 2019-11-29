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
  long millis29Day = 2505600000L;
  long millis28Day = 2419200000L;
  int millisInDay = 86400000;
  
  long[] monthMillisTotal = {0, millis31Day, millis28Day + millis31Day, millis28Day + millis31Day * 2, millis28Day + millis31Day * 2 + millis30Day,
                            millis28Day + millis31Day * 3 + millis30Day, millis28Day + millis31Day * 3 + millis30Day * 2, millis28Day + millis31Day * 4 + millis30Day * 2,
                            millis28Day + millis31Day * 5 + millis30Day * 2, millis28Day + millis31Day * 5 + millis30Day * 3, millis28Day + millis31Day * 6 + millis30Day * 3,
                            millis28Day + millis31Day * 6 + millis30Day * 4};
  int dayOfWeek;
  int rowNumber = 1;

  float calendarSquar;
  float gridX;
  float gridY;
  int daysAMonth;
  int amountOfDaysRemove;
  int dayToShow;
  long millisToShow;

  String[] monthNames = {"Jan", "Feb", "Mar", "Api", "Maj", "Jun", "Jul", "Augt", "Sep", "Okt", "Nov", "Dec"};
  String[] dayNames = {"Man", "Tir", "ons", "Tor", "Fre", "Lor", "Son"};
  int monthValue;

  Table taskDatabase;
  Table taskTable;
  float taskArray[];

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
    textSize(50);
    fill(255);
    background(0);

    appDesign.draw();

    dayCal();
    yearDebug();
    monthPicker();
    taskDisplayer();
    calendarGrid();
  }
  
  void monthPicker(){
    fill(255);
    rect(width/2 - 3.5 * calendarSquar, calendarSquar, 7*calendarSquar, calendarSquar);
    
    fill(0);
    triangle(width/2 - 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 - 3 * calendarSquar, 1.25 * calendarSquar, width/2 - 3 * calendarSquar, 1.75 * calendarSquar);
    triangle(width/2 + 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 + 3 * calendarSquar, 1.25 * calendarSquar, width/2 + 3 * calendarSquar, 1.75 * calendarSquar);
    textAlign(CENTER,CENTER);
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
      text("31 dage", width/2, height/2 + 100);
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
        text("29 dage", width/2, height/2 + 100);
        daysAMonth = 29;
        amountOfDaysRemove = 10;
      } else {
        daysAMonth = 28;
        amountOfDaysRemove = 4;
        text("28 dage", width/2, height/2 + 100);
      }
    }

    if (monthValue == 4 || monthValue == 6 || monthValue == 9 || monthValue == 11) {
      text("30 dage", width/2, height/2 + 100);
      daysAMonth = 30;
      amountOfDaysRemove = 2;
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
        rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar*2, calendarSquar, calendarSquar);

        fill(255);
        textAlign(CENTER, CENTER);
        if ((i - dayOfWeek - amountOfDaysRemove) + j * 7 > 0 && (i - dayOfWeek + 2) + j * 7 < daysAMonth + amountOfDaysRemove + 3) {
          fill(0);
        } else {
          fill(255);
        }
        text((i - dayOfWeek - amountOfDaysRemove) + j * 7, calendarSquar * i + (width/2 - 3 * calendarSquar), j * calendarSquar + 2.5 * calendarSquar);
      }
    }
  }
  
  void updateTaskArray(){
    taskArray = (float[]) subset(taskArray, 0, taskArray.length);
    for(int i = 0; i < taskTable.getRowCount(); i++){
      TableRow row = taskTable.getRow(i);
      long startTime = row.getLong("start");
      if(startTime >= millisToShow && startTime <= millisToShow + millisInDay){
        float idNumber = row.getFloat("id");
        taskArray = (float[]) append(taskArray, idNumber);
      }
    }
  }
  
  void taskDisplayer(){
    fill(255);
    rect(width/2 - 3 * calendarSquar, 8*calendarSquar, 6*calendarSquar, 100 * taskArray.length);
    for(int i = 0; i < taskArray.length; i++){
      int taskId = floor(taskArray[i]);
      TableRow row = taskDatabase.getRow(taskId);
      String taskName = row.getString("name");
      fill(0);
      text(taskName, width/2, 700 + 100 * i);
    }
  }

  int pageNumberReturn() {
    return appDesign.programState;
  }
  
  void mouseReleased(){
    if(mouseX >= width/2 - 3.25 * calendarSquar && mouseX <= width/2 - 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar){
      monthValue -= 1;
    }
    if(mouseX <= width/2 + 3.25 * calendarSquar && mouseX >= width/2 + 3 * calendarSquar && mouseY >= 1.25 * calendarSquar && mouseY <= 1.75 * calendarSquar){
      monthValue += 1;
    }
    if(monthValue <= 0){
      monthValue = 12;
      year -= 1;
    }
    if(monthValue >= 13){
      monthValue = 1;
      year += 1;
    }
  }
  
  void mousePressed(){
    for (int j = 0; j < 6; j++) {
      for (int i = 0; i < 7; i++) {
        if(mouseX >= i * calendarSquar + (width/2 - 3.5 * calendarSquar) && mouseX <= i * calendarSquar + (width/2 - 3.5 * calendarSquar)+calendarSquar &&
          mouseY >= j * calendarSquar + calendarSquar * 2 && mouseY <= j * calendarSquar + calendarSquar * 3){
          dayToShow = (i - dayOfWeek - amountOfDaysRemove) + j * 7;
          millisToShow = yearMillisTotal + (dayToShow - 1) * millisInDay + monthMillisTotal[monthValue - 1];
          
          if(monthValue == 2 && bLeapYear == true){
            millisToShow += millisInDay;
          }
          println(dayToShow);
          println(dayOfWeek);
          println(millisToShow);
          
          
          updateTaskArray();
        }
      }
    }
  }
  
  void yearDebug() {
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
    } 
    else {
    }
  }
}
