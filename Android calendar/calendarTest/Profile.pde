class Profile{
  AppDesign appDesign;
  String pageTitle = "Profile";
  
  Profile(){
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
