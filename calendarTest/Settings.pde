class Settings{
  AppDesign appDesign;
  String pageTitle = "Settings";

  Settings(){
    appDesign = new AppDesign(pageTitle);
  }
  
  void display(){
    background(0);
    appDesign.draw();
  }
  
  int pageNumberReturn(){
    return appDesign.programState;
  }
}
