//Import libary
import controlP5.*;

class AddTask{

  ControlP5 cp5;
  TaskAddBackEnd taskAddBack;
  AppDesign appDesign;
  String pageTitle = "Tilføje opgave";
  
  String taskName;
  String taskDescription;
  int taskYear;
  int taskMonth;
  int taskDay;
  int taskHour;
  int taskMinut;
  float taskDuration;
  int taskRate;
  int oneDayTask;
  
  int slider;
  Table taskTable;
  
  //Declare dropdown lists from controlP5 libary
  DropdownList yearDropDown;
  DropdownList monthDropDown;
  DropdownList dayDropDown;
  DropdownList hourDropDown;
  DropdownList minutDropDown;
  
  //Dropdowns, slider og textinput position on the x-axes
  float taskNameXpos = 100;
  float taskDescriptionXpos = 150;
  float dropDownXpos = 300;
  float taskDurationXpos = 400; 
  float sliderXpos = 500;
  
  color backgroundColor = color(0);
  
  AddTask(ControlP5 cp5){
    //sets the program to be fullscreen, so it will fit all screens.
    fullScreen();
    
    this.cp5 = cp5;
    cp5.setAutoDraw(false);
    
    taskName = "";
    taskDescription = "";
    
    taskTable = loadTable("taskDatabase.csv", "header");
    
    yearDropDown = cp5.addDropdownList("Velg ar").setPosition(width/2-302, dropDownXpos);
    monthDropDown = cp5.addDropdownList("Velg manede").setPosition(width/2-102, dropDownXpos);
    dayDropDown = cp5.addDropdownList("Velg dag").setPosition(width/2-202, dropDownXpos);
    hourDropDown = cp5.addDropdownList("Time").setPosition(width/2+2, dropDownXpos);
    minutDropDown = cp5.addDropdownList("Minutter").setPosition(width/2+102, dropDownXpos);
    
    yearDropDown.setOpen(false);
    monthDropDown.setOpen(false);
    dayDropDown.setOpen(false);
    hourDropDown.setOpen(false);
    minutDropDown.setOpen(false);
    
    for(int i = year(); i < year() + 10; i++){
      yearDropDown.addItem("" + i, i);
    }
    for (int i=0; i<12; i++) {
      monthDropDown.addItem("" + (i+1),i+1);
    }
    for (int i=0; i<24; i++) {
      hourDropDown.addItem("" + (i+1),i);
    }
    for (int i=0; i<4; i++) {
      minutDropDown.addItem("" + (i*15),i);
    }
    
    cp5.addSlider("slider").setPosition(width/2-50, sliderXpos).setRange(1, 10);
    
    cp5.addTextfield("taskName").setPosition(width/2-100, taskNameXpos).setSize(200, 40).setAutoClear(false);
    cp5.addTextfield("taskDescription").setPosition(width/2-100, taskDescriptionXpos).setSize(200, 100).setAutoClear(false);
    cp5.addTextfield("taskDuration").setPosition(width/2-100, taskDurationXpos).setSize(200, 40).setAutoClear(false).setInputFilter(ControlP5.FLOAT);
    
    oneDayTask = 0;
    
    appDesign = new AppDesign(pageTitle);
  }
  
  void display(){
    background(backgroundColor);
    appDesign.draw();
    cp5.draw();
    
    rectMode(CENTER);
    updateDayDropDown();
    cp5ValueConverter();
    checkBox();
    saveButton();
  }
  
  void updateDayDropDown(){
    println(taskMonth);
    if(dayDropDown.isOpen() == false){
      dayDropDown.clear();
      if(taskMonth == 1 || taskMonth == 3 || taskMonth == 5 || taskMonth == 7 || taskMonth == 8 || taskMonth == 10 || taskMonth == 12){
        for (int i=0; i<31; i++) {
          dayDropDown.addItem("" + (i+1),i);
        }
      }
      else if(taskMonth == 2){
        for (int i=0; i<28; i++) {
          dayDropDown.addItem("" + (i+1),i);
        }
      }
      else if(taskMonth == 4 || taskMonth == 6 || taskMonth == 9 || taskMonth == 11) {
        for (int i=0; i<30; i++) {
          dayDropDown.addItem("" + (i+1),i);
        }
      }
    }
  }
  
  void cp5ValueConverter(){
    taskYear = int(yearDropDown.getValue());
    taskMonth = int(monthDropDown.getValue());
    taskDay = int(dayDropDown.getValue());
    taskHour = int(hourDropDown.getValue());
    taskMinut = int(minutDropDown.getValue());
    taskName = cp5.get(Textfield.class,"taskName").getText();
    taskDescription = cp5.get(Textfield.class,"taskDescription").getText();
    taskDuration = cp5.get(Textfield.class, "taskDuration").getValue();
    taskRate = slider;
  }
  
  void textMaker(){
    fill(255);
    textSize(height/50);
    textAlign(CENTER,CENTER);
    text("Hvor vigtig er opgaven?", width/2, 480);
    text(":", width/2, 300);
  }
  
  void checkBox(){
    textAlign(CENTER,CENTER);
    textSize(height/50);
    text("Er det en endags ting?", width/2, 570);
    if(oneDayTask == 0){
      text("Nej", width/2-40, 595);
      fill(backgroundColor);
    }
    else{
      text("Ja", width/2-40, 595);
      fill(0,0,255);
    }
    stroke(255);
    rect(width/2, 600, 20, 20);
  }
  
  void saveButton(){
    fill(backgroundColor);
    stroke(255);
    rect(width/2, 700, 100, 50);
    
    fill(255);
    textSize(height/50);
    text("Tilføj opgave", width/2, 700);
  }
  
  void mousePressed(){
    if(mouseX >= width/2-10 && mouseX <= width/2+10 && mouseY >= 590 && mouseY <= 610){
      if(oneDayTask == 0){
        oneDayTask = 1;
      }
      else if(oneDayTask == 1){
        oneDayTask = 0;
      }
    }
    else if(mouseX >= width/2-50 && mouseX <= width/2+50 && mouseY >= 675 && mouseY <= 725){
      TableRow row = taskTable.addRow();
      row.setInt("id", taskTable.getRowCount());
      row.setString("name", taskName);
      row.setString("description", taskDescription);
      row.setInt("year", taskYear);
      row.setInt("month", taskMonth);
      row.setInt("day", taskDay);
      row.setInt("hour", taskHour);
      row.setInt("minut", taskMinut);
      row.setFloat("duration", taskDuration);
      row.setInt("rate", taskRate);
      row.setInt("oneDayTask", oneDayTask);
      row.setInt("completed", 0);
      saveTable(taskTable, "taskDatabase.csv");
      
      taskAddBack = new TaskAddBackEnd(taskTable.getRowCount(), taskYear, taskMonth, taskDay, taskHour, taskMinut, taskDuration, taskRate, oneDayTask);
    }
  }
  
  int pageNumberReturn(){
    return appDesign.programState;
  }
}
