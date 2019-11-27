import java.util.*;
import controlP5.*;
import java.util.GregorianCalendar;
import java.util.Date;

class HomePage {

  ControlP5 cp5;
  AppDesign appDesign;
  Calendar calendar;

  DropdownList calendarManede;
  int y;
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

  float dropDownXpos;
  String[] monthNames = {"Jan", "Feb", "Mar", "Api", "Maj", "Jun", "Jul", "Augt", "Sep", "Okt", "Nov", "Dec"};
  String[] dayNames = {"Man", "Tir", "ons", "Tor", "Fre", "Lor", "Son"};
  int dropDownValue;

  HomePage(ControlP5 cp5) {
    y = year();
    millisCal();

    dropDownXpos = height/20*2;
    if (height > width) {
      calendarSquar = width/9;
    }
    if (width > height) {
      calendarSquar = height/9;
    }
    calendarManede = cp5.addDropdownList("manede").setPosition(width/2-50, dropDownXpos).plugTo(this).setOpen(false);
    
    gridX = calendarSquar;
    gridY = calendarSquar;

    appDesign = new AppDesign(pageName);
    calendar = new GregorianCalendar();
    this.cp5 = cp5;
    cp5.setAutoDraw(false);

    
    calendarManede.addItems(monthNames);
  }

  void display() {
    textAlign(CENTER, CENTER);
    textSize(50);
    fill(255);
    background(0);

    appDesign.draw();
    cp5.draw();

    cp5ValueConverter();
    dayCal();
    yearDebug();
    calendarGrid();
  }

  void millisCal() {
    for (int i = 1970; i < y; i++) {
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
    dropDownValue = int(calendarManede.getValue());
  }
  void dayCal() {
    fill(255);
    if (dropDownValue == 0 || dropDownValue == 2 || dropDownValue == 4 || dropDownValue == 6 || dropDownValue == 7 || dropDownValue == 9 || dropDownValue == 11) {
      text("31 dage", width/2, height/2 + 100);
      daysAMonth = 31;
    }
    if (dropDownValue == 1) {
      if (y % 400 == 0) {
        bLeapYear = true;
      } else if (y % 100 == 0) {
        bLeapYear = false;
      } else if (y % 4 == 0) {
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

    if (dropDownValue == 3 || dropDownValue == 5 || dropDownValue == 8 || dropDownValue == 10) {
      text("30 dage", width/2, height/2 + 100);
      daysAMonth = 30;
    }
  }

  void calendarGrid() {
    calendar.set(Calendar.MONTH, dropDownValue);
    calendar.set(Calendar.DAY_OF_MONTH, 1);
    dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 6; j++) {
        //int index = i + j;
        stroke(0);
        strokeWeight(1);
        fill(255);
        rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar, calendarSquar, calendarSquar);

        fill(255);
        textAlign(CENTER, CENTER);
        if ((i - dayOfWeek + 3) + j * 7 > 0 && (i - dayOfWeek + 2) + j * 7 < daysAMonth) {
          fill(0);
        } else {
          fill(255);
        }
        text((i - dayOfWeek + 3) + j*7, calendarSquar * i + (width/2 - 3 * calendarSquar), j * calendarSquar + 1.5 * calendarSquar);
      }
    }
  }

  void yearDebug() {
    if (y % 400 == 0) {
      bLeapYear = true;
    } else if (y % 100 == 0) {
      bLeapYear = false;
    } else if (y % 4 == 0) {
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
