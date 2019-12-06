import controlP5.*;

HomePage homePage;
Settings settings;
Profile profile;
AddTask addTask;
Stats stats;

ControlP5 cp5;
int pageNumber;

void setup(){
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
  
  /*if(pageNumber == 0){
    addTask = new AddTask(cp5);
  }
  if(pageNumber == 3){
    homePage.updateCalendar();
  }*/
}

void pageMan(){
  switch (pageNumber){
    case 0:
      homePage.display();
      pageNumber = homePage.pageNumberReturn();
      break;
      
    case 1: 
      settings.display();
      pageNumber = settings.pageNumberReturn();
      break;
      
    case 2:
      profile.display();
      pageNumber = profile.pageNumberReturn();
      break;
    
    case 3:
      addTask.display();
      pageNumber = addTask.pageNumberReturn();
      break;
      
    case 4:
      stats.display();
      pageNumber = stats.pageNumberReturn();
      break;
  }
}

void mousePressed(){
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
  switch (pageNumber){
    case 0:
    homePage.mouseReleased();
    break;
    
    case 3:
    addTask.mouseReleased();
    break;
  }
}
