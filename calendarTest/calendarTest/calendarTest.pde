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
}

void draw(){
  background(0);
  pageMan();
}

void pageMan(){
  switch (pageNumber){
    case 0:
      homePage = new HomePage();
      homePage.display();
      pageNumber = homePage.pageNumberReturn();
      break;
      
    case 1: 
      settings = new Settings();
      settings.display();
      pageNumber = settings.pageNumberReturn();
      break;
      
    case 2:
      profile = new Profile();
      profile.display();
      pageNumber = profile.pageNumberReturn();
      break;
    
    case 3:
      addTask = new AddTask(cp5);
      addTask.display();
      pageNumber = addTask.pageNumberReturn();
      break;
      
    case 4:
      stats = new Stats();
      stats.display();
      pageNumber = stats.pageNumberReturn();
      break;
  }
}
