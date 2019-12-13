class Stats{
  AppDesign appDesign;
  String pageTitle = "Stats";
  
  Stats(){
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
