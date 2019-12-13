//a class that have the button and layout to have the same layout on all the pages
class AppDesign{
  
  int programState;

  int logoSize;
  
  //images that is used in the layout
  PImage settingsLogo; 
  PImage profileLogo;
  PImage addLogo;
  PImage homeLogo;
  PImage statsLogo;
  String pageTitle;
  
  AppDesign(String pageTitle){
    
    logoSize = height/20;
    
    //loading the image and resizes the image
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
    
    //gets the page title
    this.pageTitle = pageTitle;
  }
  
  //calls all function, so only one function needs to be called
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
  
  //functions that make the buttons
  void homeButton(){
    image(homeLogo, 0, height-logoSize);
    if(mousePressed && mouseX >= 0 && mouseX <= logoSize && mouseY >= height - logoSize && mouseY <= height){
      programState = 0;
    }
  }  
    
  void settingsButton(){
    image(settingsLogo, 0, 0);
    if(mousePressed && mouseX >= 0 && mouseX <= logoSize && mouseY >= 0 && mouseY <= logoSize){
      programState = 1;
    }
  }
  
  void profileButton(){
    image(profileLogo, width - logoSize, 0);
    if(mousePressed && mouseX >= width-logoSize && mouseX <= width && mouseY >= 0 && mouseY <= logoSize){
      programState = 2;
    }
  }
  
  void addTaskButton(){
    image(addLogo, width/2 - logoSize/2, height-logoSize);
    if(mousePressed && mouseX >= width/2 - logoSize/2 && mouseX <= width/2 + logoSize/2 && mouseY >= height - logoSize && mouseY <= height){
      programState = 3;
    }
  }
  
  void statsButton(){
    image(statsLogo, width-logoSize, height-logoSize);
    if(mousePressed && mouseX >= width - logoSize && mouseX <= width && mouseY >= height - logoSize && mouseY <= height){
      programState = 4;
    }
  }
  
  //prints the page title in the top of the screen
  void windowText(){
    fill(255);
    textSize(logoSize);
    textAlign(CENTER, BOTTOM);
    text(pageTitle, width/2, logoSize);
  }
  
  //makes som rects that connects the buttons
  void buttonConnector(){
    rectMode(CORNER);
    noStroke();
    fill(50);
    rect(0, 0, width, logoSize+5);
    rect(0, height, width, -logoSize - 5);
  }
  
  //returns the pageNumber
  int programStateReturner(){
    return programState;
  }
}
