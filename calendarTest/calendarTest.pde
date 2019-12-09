//Libary import
import controlP5.*;

//declares classes
HomePage homePage;
Settings settings;
Profile profile;
AddTask addTask;
Stats stats;
ControlP5 cp5;

//variable that control which page at is showen
int pageNumber;

void setup(){
  //Puts the program in fullscreen
  fullScreen();
  
  cp5 = new ControlP5(this);
  homePage = new HomePage();
  settings = new Settings();
  profile = new Profile();
  addTask = new AddTask(cp5);
  stats = new Stats();
}

void draw(){
  background(0);
  pageMan();
}

void pageMan(){
  //the function that uses pageNumber to control which page is showen
  switch (pageNumber){
    //Calendar/home page
    case 0:
      homePage.display();
      pageNumber = homePage.pageNumberReturn();
      break;
    
    //Settings page
    case 1: 
      settings.display();
      pageNumber = settings.pageNumberReturn();
      break;
      
    //Profile page  
    case 2:
      profile.display();
      pageNumber = profile.pageNumberReturn();
      break;
    
    //the add task page
    case 3:
      addTask.display();
      homePage.updateCalendar();
      pageNumber = addTask.pageNumberReturn();
      break;
    
    //stats page
    case 4:
      stats.display();
      pageNumber = stats.pageNumberReturn();
      break;
  }
}

void mousePressed(){
  //making sure that the mouse only presses buttons on the page the user is on
  switch (pageNumber){
    case 0:
    homePage.mousePressed();
    break;
    
    case 3:
    addTask.mousePressed();
    break;
  }
}

void mouseReleased(){
  //same as mousepressed, but just when mouse is released
  switch (pageNumber){
    case 0:
    homePage.mouseReleased();
    break;
    
    case 3:
    addTask.mouseReleased();
    break;
  }
}
