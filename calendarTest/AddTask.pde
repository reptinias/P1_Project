//Import libary
import controlP5.*;

class AddTask {
  //declars the classes
  ControlP5 cp5;
  TaskAddBackEnd taskAddBack;
  AppDesign appDesign;

  //The page title
  String pageTitle = "Tilføje opgave";

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


  //Dropdowns, slider og textinput position on the x-axes
  float taskNameXpos = 100;
  float taskDescriptionXpos = 150;
  float dropDownXpos = 300;
  float taskDurationXpos = 400; 
  float sliderXpos = 500;

  int[] yearArray = {2019, 2020, 2021, 2022, 2023, 2024, 2025};

  color backgroundColor = color(0);

  boolean taskSavedWindowShow = false;

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
    yearDropDown = cp5.addDropdownList("Velg ar").setPosition(width/2 - 152, dropDownXpos);
    monthDropDown = cp5.addDropdownList("Velg manede").setPosition(width/2 - 50, dropDownXpos);
    dayDropDown = cp5.addDropdownList("Velg dag").setPosition(width/2 + 52, dropDownXpos);
    hourDropDown = cp5.addDropdownList("Time").setPosition(width/2 - 102, dropDownXpos + 50);
    minutDropDown = cp5.addDropdownList("Minutter").setPosition(width/2, dropDownXpos + 50);

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
    cp5.addSlider("slider").setPosition(width/2-50, sliderXpos).setRange(1, 10);

    //adds text boxes the user can use to give names and sescriptions
    cp5.addTextfield("taskName").setPosition(width/2-100, taskNameXpos).setSize(200, 40).setAutoClear(false);
    cp5.addTextfield("taskDescription").setPosition(width/2-100, taskDescriptionXpos).setSize(200, 100).setAutoClear(false);
    cp5.addTextfield("taskDuration").setPosition(width/2-100, taskDurationXpos).setSize(200, 40).setAutoClear(false).setInputFilter(ControlP5.FLOAT);

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
    text("Hvor vigtig er opgaven?", width/2, 480);
  }

  void checkBox() {
    //makes a check box, that changes color based on the oneDayTask variable
    textAlign(CENTER, CENTER);
    textSize(height/50);
    text("Er det en endags ting?", width/2, 570);
    if (oneDayTask == 0) {
      text("Nej", width/2-40, 595);
      fill(backgroundColor);
    } else {
      text("Ja", width/2-40, 595);
      fill(0, 0, 255);
    }
    stroke(255);
    rect(width/2, 600, 20, 20);
  }

  void saveButton() {
    //makes a button to save the task
    fill(backgroundColor);
    stroke(255);
    rect(width/2, 700, 100, 50);

    fill(255);
    textSize(height/50);
    text("Tilføj opgave", width/2, 700);
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
      text("Din opgave er blevet tilføjet", width/2, height/3);
    }
  }

  void mousePressed() {
    //check if the user pressed the one day check box
    if (mouseX >= width/2-10 && mouseX <= width/2+10 && mouseY >= 590 && mouseY <= 610) {
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
    //check ifthe save button is pressed, saves the task to the datasheet
    if (mouseX >= width/2-50 && mouseX <= width/2+50 && mouseY >= 675 && mouseY <= 725) {
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
