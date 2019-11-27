import java.util.*;
import java.util.GregorianCalendar;
import java.util.Date;

class HomePage {

  AppDesign appDesign;
  Calendar calendar;

  int year;
  long millisTotal = 0L;
  boolean bLeapYear;
  long millisInLeapYear = 31622400000L;
  long millisInNormalYear = 31536000000L;
  String pageName = "Home";

  int millisInDay = 86400000;
  int dayOfWeek;
  int rowNumber = 1;

  float calendarSquar;
  float gridX;
  float gridY;
  int daysAMonth;

  String[] monthNames = {"Jan", "Feb", "Mar", "Api", "Maj", "Jun", "Jul", "Augt", "Sep", "Okt", "Nov", "Dec"};
  String[] dayNames = {"Man", "Tir", "ons", "Tor", "Fre", "Lor", "Son"};
  int monthValue;

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
    calendarGrid();
  }
  
  void monthPicker(){
    fill(255);
    rect(width/2 - 3.5 * calendarSquar, calendarSquar, 7*calendarSquar, calendarSquar);
    
    fill(0);
    triangle(width/2 - 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 - 3 * calendarSquar, 1.25 * calendarSquar, width/2 - 3 * calendarSquar, 1.75 * calendarSquar);
    triangle(width/2 + 3.25 * calendarSquar, 1.5 * calendarSquar, width/2 + 3 * calendarSquar, 1.25 * calendarSquar, width/2 + 3 * calendarSquar, 1.75 * calendarSquar);
    textAlign(CENTER,CENTER);
    text(monthNames[monthValue-1], width/2, 1.5*calendarSquar);
  }

  void millisCal() {
    for (int i = 1970; i < year; i++) {
      if (i % 400 == 0) {
        bLeapYear = true;
      } else if (i % 100 == 0) {
        bLeapYear = false;
      } else if (i % 4 == 0) {
        bLeapYear =true;
      } else {
        bLeapYear = false;
      }
      if (bLeapYear) {
        millisTotal += millisInLeapYear;
      } else {
        millisTotal += millisInNormalYear;
      }
    }
    millisTotal -= 3600000L;
  }

  void cp5ValueConverter() {
    
  }
  void dayCal() {
    fill(255);
    if (monthValue == 0 || monthValue == 2 || monthValue == 4 || monthValue == 6 || monthValue == 7 || monthValue == 9 || monthValue == 11) {
      text("31 dage", width/2, height/2 + 100);
      daysAMonth = 31;
    }
    if (monthValue == 1) {
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
      } else {
        text("28 dage", width/2, height/2 + 100);
      }
    }

    if (monthValue == 3 || monthValue == 5 || monthValue == 8 || monthValue == 10) {
      text("30 dage", width/2, height/2 + 100);
      daysAMonth = 30;
    }
  }

  void calendarGrid() {
    calendar.set(Calendar.MONTH, monthValue);
    calendar.set(Calendar.DAY_OF_MONTH, 1);
    dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 6; j++) {
        //int index = i + j;
        stroke(0);
        strokeWeight(1);
        fill(255);
        rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar*2, calendarSquar, calendarSquar);

        fill(255);
        textAlign(CENTER, CENTER);
        if ((i - dayOfWeek + 3) + j * 7 > 0 && (i - dayOfWeek + 2) + j * 7 < daysAMonth) {
          fill(0);
        } else {
          fill(255);
        }
        text((i - dayOfWeek + 3) + j*7, calendarSquar * i + (width/2 - 3 * calendarSquar), j * calendarSquar + 2.5 * calendarSquar);
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
    } else {
    }
  }

  int pageNumberReturn() {
    return appDesign.programState;
  }
}
