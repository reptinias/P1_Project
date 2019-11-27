class AppDesign{
  
  int programState;

  int logoSize;
  
  PImage settingsLogo; 
  PImage profileLogo;
  PImage addLogo;
  PImage homeLogo;
  PImage statsLogo;
  String pageTitle;
  
  AppDesign(String pageTitle){
    
    //programState = 0;
    logoSize = height/20;
    
    settingsLogo = loadImage("Settings_black.png");
    settingsLogo.resize(logoSize, logoSize);
  
    profileLogo = loadImage("Profile_picture.png");
    profileLogo.resize(logoSize, logoSize);
    
    addLogo = loadImage("Add_button.png");
    addLogo.resize(logoSize, logoSize);
    
    homeLogo = loadImage("Home_Button.png");
    homeLogo.resize(logoSize, logoSize);
    
    statsLogo = loadImage("Stats_button.png");
    statsLogo.resize(logoSize, logoSize);
    
    this.pageTitle = pageTitle;
  }
  
  void draw(){
    background(0);
    buttonConnector();
    
    homeButton();
    settingsButton();
    profileButton();
    addTaskButton();
    statsButton();
    windowText(); 
  }
  
  void homeButton(){
    image(homeLogo, 0, height-logoSize);
    if(mousePressed && mouseX >= 0 && mouseX <= logoSize && mouseY >= height - logoSize && mouseY <= height){
      println("home");
      programState = 0;
    }
  }  
    
  void settingsButton(){
    image(settingsLogo, 0, 0);
    if(mousePressed && mouseX >= 0 && mouseX <= logoSize && mouseY >= 0 && mouseY <= logoSize){
      println("settings");
      programState = 1;
    }
  }
  
  void profileButton(){
    image(profileLogo, width - logoSize, 0);
    if(mousePressed && mouseX >= width-logoSize && mouseX <= width && mouseY >= 0 && mouseY <= logoSize){
      println("profile");
      programState = 2;
    }
  }
  
  void addTaskButton(){
    image(addLogo, width/2 - logoSize/2, height-logoSize);
    if(mousePressed && mouseX >= width/2 - logoSize/2 && mouseX <= width/2 + logoSize/2 && mouseY >= height - logoSize && mouseY <= height){
      println("add task");
      programState = 3;
    }
  }
  
  void statsButton(){
    image(statsLogo, width-logoSize, height-logoSize);
    if(mousePressed && mouseX >= width - logoSize && mouseX <= width && mouseY >= height - logoSize && mouseY <= height){
      println("stats");
      programState = 4;
    }
  }
  
  void windowText(){
    fill(255);
    textSize(logoSize);
    textAlign(CENTER, BOTTOM);
    text(pageTitle, width/2, logoSize);
  }
  
  void buttonConnector(){
    rectMode(CORNER);
    noStroke();
    fill(50);
    rect(0, 0, width, logoSize+5);
    rect(0, height, width, -logoSize - 5);
  }
   
  int programStateReturner(){
    return programState;
  }
}
