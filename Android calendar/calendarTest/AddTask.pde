//Import libary
import controlP5.*;

class AddTask {
  //declars the classes
  ControlP5 cp5;
  TaskAddBackEnd taskAddBack;
  AppDesign appDesign;

  //The page title
  String pageTitle = "Tilfoje opgave";

  //the variables the are going into a datasheet  
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
  int dropDownH = 50;
  
  //Declare textfield from controlP5 libary
  Textfield nameTextfield;
  Textfield descriptionTextfield;
  Textfield durationTextfield;
  //makes a font for the text fields
  PFont textfieldFont = createFont("arial", height/100*1);

  //Dropdowns, slider og textinput position on the x-axes
  int taskNameXpos = height/100*10;
  int taskDescriptionXpos = height/100*20;
  int dropDownXpos = height/100*45;
  int taskDurationXpos = height/100*35; 
  int sliderXpos = height/100*70;

  int[] yearArray = {2019, 2020, 2021, 2022, 2023, 2024, 2025};

  color backgroundColor = color(0);

  boolean taskSavedWindowShow = false;
  boolean keyboardOpen = false;

  AddTask(ControlP5 cp5) {    
    this.cp5 = cp5;
    //Because controlp5 autodraws, we disable it, so we can control when it's drawn
    cp5.setAutoDraw(false);

    //declaring user input strings as empty
    taskName = "";
    taskDescription = "";

    //csv file gets loaded
    taskTable = loadTable("taskDatabase.csv", "header");

    //declaring drop down lists and gives it a position
    yearDropDown = cp5.addDropdownList("Velg ar", width/5-5, dropDownXpos, width/5, height/100*9).setBarHeight(height/100*2).setItemHeight(height/100*2).setFont(textfieldFont);
    monthDropDown = cp5.addDropdownList("Velg manede", width/5*2, dropDownXpos, width/5, height/100*9).setBarHeight(height/100*2).setItemHeight(height/100*2).setFont(textfieldFont);
    dayDropDown = cp5.addDropdownList("Velg dag", width/5*3+5, dropDownXpos, width/5, height/100*9).setBarHeight(height/100*2).setItemHeight(height/100*2).setFont(textfieldFont);
    hourDropDown = cp5.addDropdownList("Time", int(width/5*1.5-2.5), dropDownXpos + 200, width/5, height/100*9).setBarHeight(height/100*2).setItemHeight(height/100*2).setFont(textfieldFont);
    minutDropDown = cp5.addDropdownList("Minutter", int(width/5*2.5+2.5), dropDownXpos + 200, width/5, height/100*9).setBarHeight(height/100*2).setItemHeight(height/100*2).setFont(textfieldFont);

    //sets the drop downs to be closed, when the screen is drawn
    yearDropDown.setOpen(false);
    monthDropDown.setOpen(false);
    dayDropDown.setOpen(false);
    hourDropDown.setOpen(false);
    minutDropDown.setOpen(false);

    //puts items/variables into the drop downs
    for (int i = 0; i < yearArray.length; i++) {
      yearDropDown.addItem("" + yearArray[i], i);
    }
    for (int i=0; i<12; i++) {
      monthDropDown.addItem("" + (i+1), i+1);
    }
    for (int i=0; i<24; i++) {
      hourDropDown.addItem("" + (i+1), i);
    }
    for (int i=0; i<4; i++) {
      minutDropDown.addItem("" + (i*15), i);
    }

    //adds a slider and gives it a position and a rang
    cp5.addSlider("slider").setPosition(width/2-(width/5*3)/2, sliderXpos).setRange(1, 10).setSize(width/5*3, height/100*2).setFont(textfieldFont);

    //adds text boxes the user can use to give names and sescriptions
    nameTextfield = cp5.addTextfield("taskName").setPosition(width/2-(width/2)/2, taskNameXpos).setSize(width/2, height/100*5).setAutoClear(false).setFont(textfieldFont);
    descriptionTextfield = cp5.addTextfield("taskDescription").setPosition(width/2-(width/2)/2, taskDescriptionXpos).setSize(width/2, height/100*10).setAutoClear(false).setFont(textfieldFont);
    durationTextfield = cp5.addTextfield("taskDuration").setPosition(width/2-(width/2)/2, taskDurationXpos).setSize(width/2, height/100*5).setAutoClear(false).setInputFilter(ControlP5.FLOAT).setFont(textfieldFont);
    
    //makes a variable that can be used as a boolean variable
    oneDayTask = 0;

    //declares the app design class
    appDesign = new AppDesign(pageTitle);
  }

  void display() {
    //draws app design, to have the same buttons and layout as on the other pages
    background(backgroundColor);
    appDesign.draw();
    //draws control5p when the draw funkction is called
    cp5.draw();

    //Calling all the functions, so the only funcion that need to be called, when the is drawn, is the draw function
    rectMode(CENTER);
    updateDayDropDown();
    cp5ValueConverter();
    checkBox();
    textMaker();
    saveButton();
    taskSavedWindow();
  }
  
  //function that updates the items/variables in one of the drop down
  void updateDayDropDown() {
    //check if the drop down is closed or open
    if (dayDropDown.isOpen() == false) {
      //clear the items in the drop down
      dayDropDown.clear();
      //checks what month is picked in one of the other drop down
      //if there are 31 days in the picked month
      if (taskMonth == 1 || taskMonth == 3 || taskMonth == 5 || taskMonth == 7 || taskMonth == 8 || taskMonth == 10 || taskMonth == 12) {
        for (int i=0; i<31; i++) {
          dayDropDown.addItem("" + (i+1), i);
        }
      }
      //if there are 28 days
      else if (taskMonth == 2) {
        for (int i=0; i<28; i++) {
          dayDropDown.addItem("" + (i+1), i);
        }
      }
      //if there are 30 days
      else if (taskMonth == 4 || taskMonth == 6 || taskMonth == 9 || taskMonth == 11) {
        for (int i=0; i<30; i++) {
          dayDropDown.addItem("" + (i+1), i);
        }
      }
    }
  }
  
  void softKeyboard(){
    if(nameTextfield.isActive() == true || descriptionTextfield.isActive() == true || durationTextfield.isActive() == true && !keyboardOpen){
      keyboardOpen = true;
      openKeyboard();
    }
    else if(nameTextfield.isActive() == false || descriptionTextfield.isActive() == false || durationTextfield.isActive() == false && keyboardOpen){
      keyboardOpen = false;
      closeKeyboard();
    }
  }
  
  
  void cp5ValueConverter() {
    //converts the selected value into the valiables we declared in the start
    taskYear = yearArray[int(yearDropDown.getValue())];
    taskMonth = int(monthDropDown.getValue() + 1);
    taskDay = int(dayDropDown.getValue() + 1);
    taskHour = int(hourDropDown.getValue() + 1);
    taskMinut = int(minutDropDown.getValue() * 15);
    taskName = cp5.get(Textfield.class, "taskName").getText();
    taskDescription = cp5.get(Textfield.class, "taskDescription").getText();
    taskDuration = float(cp5.get(Textfield.class, "taskDuration").getText());
    taskRate = int(cp5.get(Slider.class, "slider").getValue());
  }

  void textMaker() {
    fill(255);
    textSize(height/50);
    textAlign(CENTER, CENTER);
    text("Hvor vigtig er opgaven?", width/2, height/100*65);
  }

  void checkBox() {
    //makes a check box, that changes color based on the oneDayTask variable
    textAlign(CENTER, CENTER);
    textSize(height/50);
    text("Er det en endags ting?", width/2, height/100*77);
    if (oneDayTask == 0) {
      text("Nej", width/2-80, height/100*80);
      fill(backgroundColor);
    } else {
      text("Ja", width/2-80, height/100*80);
      fill(0, 0, 255);
    }
    stroke(255);
    rectMode(CENTER);
    rect(width/2, height/100*80, 50, 50);
  }

  void saveButton() {
    //makes a button to save the task
    fill(backgroundColor);
    stroke(255);
    rectMode(CENTER);
    rect(width/2, height/100*90, 300, 150);
    
    fill(255);
    textSize(height/50);
    text("Tilfoj opgave", width/2, height/100*90);
  }

  void taskSavedWindow() {
    //makes a window, that indicate that the user saved the task
    if (taskSavedWindowShow == true) {
      fill(255);
      rectMode(CENTER);
      textAlign(CENTER, CENTER);
      rect(width/2, height/3, (width/100)*60, (height/100)*40);
      fill(0);
      textSize(20);
      text("Din opgave er blevet tilfojet", width/2, height/3);
    }
  }

  void mousePressed() {
    //check if the user pressed the one day check box
    if (mouseX >= width/2-25 && mouseX <= width/2+25 && mouseY >= height/100*80 - 25 && mouseY <= height/100*80 + 25) {
      if (oneDayTask == 0) {
        oneDayTask = 1;
      } else if (oneDayTask == 1) {
        oneDayTask = 0;
      }
    }
    //check if the task added window is shown, and removes it again, if it's shown
    if (taskSavedWindowShow == true) {
      taskSavedWindowShow = false;
    }
  }

  void mouseReleased() {    
    softKeyboard();
    
    //check if the save button is pressed, saves the task to the datasheet
    if (mouseX >= width/2-150 && mouseX <= width/2+150 && mouseY >= height/100*90 - 75 && mouseY <= height/100*90 - 75) {
      //adds a new row to the datasheet ands the variables
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

      //calls the back end constructer, and gives the arguments needed 
      taskAddBack = new TaskAddBackEnd(taskTable.getRowCount(), taskYear, taskMonth, taskDay, taskHour, taskMinut, taskDuration, taskRate, oneDayTask);

      taskSavedWindowShow = true;

      //clear the textfields 
      cp5.get(Textfield.class, "taskName").clear();
      cp5.get(Textfield.class, "taskDescription").clear();
      cp5.get(Textfield.class, "taskDuration").clear();
    }
  }
  
  //returns the pageNumber to the main script
  int pageNumberReturn() {
    return appDesign.programState;
  }
}
