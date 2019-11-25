import controlP5.*;
ControlP5 cp5;

AppDesign appDesign;

DropdownList monthDropDown;
int y;
long millisTotal = 0L;
boolean bLeapYear;
long millisInLeapYear = 31622400000L;
long millisInNormalYear = 31536000000L;
String pageName = "Home";

float calendarSquar;
float gridX;
float gridY;
int daysAWeek;

float dropDownXpos;
String[] monthNames = {"Januar", "Februar", "Maj", "Apirl", "Maj", "Juni", "Juli", "August", "Septemper", "Oktober", "November", "December"};
int dropDownValue;

void setup(){
  fullScreen();
  y = year();
  millisCal();
  
  dropDownXpos = height/20*2;
  if(height > width){
    calendarSquar = width/9;
  }
  if(width > height){
    calendarSquar = height/9;
  }
  gridX = calendarSquar;
  gridY = calendarSquar;
  
  appDesign = new AppDesign(pageName);
  cp5 = new ControlP5(this);
  
  monthDropDown = cp5.addDropdownList("Velg manede").setPosition(width/2-50, dropDownXpos).setOpen(false);
  monthDropDown.addItems(monthNames);
}

void draw(){
  textAlign(CENTER,CENTER);
  textSize(50);
  fill(255);
  background(0);
  
  appDesign.draw();
  println(millisTotal);
  
  cp5ValueConverter();
  displayCalendar();
  yearDebug();
  calendarGrid();
}

void millisCal(){
  for(int i = 1970; i < y; i++){
    if(i % 400 == 0){
      bLeapYear = true;
    }
    else if(i % 100 == 0){
      bLeapYear = false;
    }
    else if(i % 4 == 0){
      bLeapYear =true;
    }
    else{
      bLeapYear = false;
    }
    if(bLeapYear){
      millisTotal += millisInLeapYear;
    }
    else{
      millisTotal += millisInNormalYear;
    }
  }
  millisTotal -= 3600000L;
}

void cp5ValueConverter(){
  dropDownValue = int(monthDropDown.getValue());
}
void displayCalendar(){
  fill(255);
  if(dropDownValue == 0 || dropDownValue == 2 || dropDownValue == 4 || dropDownValue == 6 || dropDownValue == 7 || dropDownValue == 9 || dropDownValue == 11){
    for(int i = 0; i < 31; i++){
      text("31 dage", width/2, height/2 + 100);
      daysAWeek = 31;
    }
  }
  if(dropDownValue == 1){
    if(y % 400 == 0){
      bLeapYear = true;
    }
    else if(y % 100 == 0){
      bLeapYear = false;
    }
    else if(y % 4 == 0){
      bLeapYear =true;
    }
    else{
      bLeapYear = false;
    }
    if(bLeapYear){
      for(int i = 0; i < 29; i++){
        text("29 dage", width/2, height/2 + 100);
        daysAWeek = 29;
      }
    }
    else{
      for(int i = 0; i < 28; i++){
        text("28 dage", width/2, height/2 + 100);
        daysAWeek = 28;
      }
    }
  }
  
  if(dropDownValue == 3 || dropDownValue == 5 || dropDownValue == 8 || dropDownValue == 10){
    for(int i = 0; i < 30; i++){
      text("30 dage", width/2, height/2 + 100);
      daysAWeek = 30;
    }
  }
}

void calendarGrid(){
  for(int i = 0; i < 7; i++){
    for (int j = 0; j < 6; j++) {
      //int index = i + j*10;
      stroke(0);
      strokeWeight(1);
      fill(255);
      rect(i * calendarSquar + (width/2 - 3.5 * calendarSquar), j * calendarSquar + calendarSquar, calendarSquar, calendarSquar);
    }
  }
}

void yearDebug(){
    if(y % 400 == 0){
      bLeapYear = true;
    }
    else if(y % 100 == 0){
      bLeapYear = false;
    }
    else if(y % 4 == 0){
      bLeapYear =true;
    }
    else{
      bLeapYear = false;
    }
    if(bLeapYear){
      
    }
    else{

    }
}
