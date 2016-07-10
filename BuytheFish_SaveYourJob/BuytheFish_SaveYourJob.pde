MarketGame mg;
void setup() {
  size(1200,800);
  frameRate(30);
  mg = new MarketGame();
}

void draw() {
  mg.play();
}

void keyPressed() {
  mg.inputKey();
}
void mouseClicked() {
  mg.changeScreen();
}
//-------------------------------------------------------------------------------------------------//
class MarketGame {
  int CURRENT_SCREEN, DAY, TEXTSTRING;
  IntList userInput;
  StringList combos;
  StringDict textStrings;
  PFont regular, regular_italic, regular_bold, bornaddict;
  PImage bg, bg1, bg2, bg3, bg4, bg5;
  boolean MORN_TALK, GAMESTART, ALLOW_INPUTS, COUNTED, INTRO, RECEIVED_EARNINGS;
  int[] keyBindings = {37,38,39,40};
  Boss b;
  Button start, option, exit;
  Notes notepad;
  Auction auction;
  MarketGame() {
    CURRENT_SCREEN = 0;
    DAY = 1;
    TEXTSTRING = 1;
    userInput = new IntList();
    combos = new StringList();
    addCombos();
    RECEIVED_EARNINGS = MORN_TALK = GAMESTART = ALLOW_INPUTS = COUNTED = false;
    INTRO = true;
    textStrings = new StringDict();
    addStrings();
    regular = createFont("ARIAL.TTF", 25);
    regular_italic = createFont("ARIALI.TTF", 25);
    regular_bold = createFont("ARIBLK.TTF", 25);
    bornaddict = createFont("BornAddict.ttf", 20);
    bg = loadImage("newbackground.jpg");
    bg1 = loadImage("background1.jpg");
    bg2 = loadImage("background2.jpg");
    bg3 = loadImage("background3.jpg");
    //bg4 = loadImage("background4.jpg");
    bg5 = loadImage("background5.jpg");
    b = new Boss("Soosh-E");
    start = new Button("Start", new PVector(width/7, height*.5), 150, 70, 0);
    option = new Button("Options", new PVector(width/10, height*.6), 180, 180, 180);
    exit = new Button("Exit", new PVector(width/7, height*.7), 0, 150, 0);
    notepad = new Notes();
    auction = new Auction();
  }
  private void addStrings() {
    textStrings.set("Boss1", "\"Welcome, new employee.\"");
    textStrings.set("Boss2", "\"No need for introductions - time to get straight to work.\"");
    textStrings.set("Boss3", "\"Your job is to buy fish for the shop. Here's some money to use. Don't spend it all.\"");
    textStrings.set("Boss4", "Received ");
    textStrings.set("Boss5", "\" Good morning, employee. Sleep well?\"");
    textStrings.set("Boss6", "\"You have a busy day at the market today - like every day for the rest of your time here.\"");
    textStrings.set("Boss7", "\"... Well? Get going. The fish aren't going to buy themselves. (Although that would save a lot of money)\"");
    textStrings.set("Boss8", "\"Time is money. Go.\"");
    textStrings.set("Boss9", "\"Wait. Before you go, here's what you can spend with what the restaurant earned yesterday.\"");
    textStrings.set("Boss10","Received ");
    textStrings.set("Boss11", "\"Welcome back. Did you get what I wanted?\"");
    textStrings.set("Boss12", "\"There better still be cash on you or else if comes out of your paycheck.\"");
    textStrings.set("Boss13","\"See you tomorrow.\"");
    textStrings.set("Give", "Handed fish over.");
    textStrings.set("Buyer1", "\"Haven't seen you around before. Are you new?\"");
    textStrings.set("Buyer2", "\"I'm not worried about some newbie. Good luck trying to beat me in the auction.\"");
    textStrings.set("Buyer3", "\"Back again? Some people never learn.\"");
    textStrings.set("Buyer4", "\"I will be buying the best tuna here today so you can leave now.\"");
  }
  private void addCombos() {
    combos.append("0"); 
    combos.append("37");
    combos.append("38");
    combos.append("39");
    combos.append("4040");
    combos.append("4037");
    combos.append("4039");
    combos.append("393739");
    combos.append("39383738");
    combos.append("37393938");
  }
  void play() {
    if(CURRENT_SCREEN == 0)
      StartScreen();
    else if(CURRENT_SCREEN == 1) 
      OptionScreen();
    else if(CURRENT_SCREEN == 2) 
      LoadingScreen();
    else if(CURRENT_SCREEN == 3)
      BossScreen();
    else if(CURRENT_SCREEN == 4) 
      MarketScreen();
    else if(CURRENT_SCREEN == 5) 
      ANewDayScreen();
    else {
      println("ERROR LOADING SCREEN");
      exit();
    }
  }
  private void StartScreen() {
    background(bg);
    start.draw();
    option.draw();
    exit.draw();
  }
  private void OptionScreen() {
    background(bg5);
    //will probably add story here too - what your goal is
  }
  private void BossScreen() {
    background(bg2);
    b.move();
    b.draw();
    drawUI();
    drawContinue();
    displayText();
  }
  private void MarketScreen() {
    background(bg3);
    drawUI();
    notepad.display();
    if(GAMESTART) {
      auction.display();
    }
  }
  private void LoadingScreen() {
    background(bg1);
  }
  private void ANewDayScreen() {
    //moon going down and sun coming up animation  
  }
  //Backspace 8, Enter 13, Spacebar 32, Left 37, Up 38, Right 39, Down 40
  void inputKey() {    
    //Input keys for Boss Screen
    if(CURRENT_SCREEN == 3 && keyCode == 32) 
      if(b.LEAVE) CURRENT_SCREEN = 2;
      
      if(!MORN_TALK) {
        if((INTRO && TEXTSTRING < b.INTRO_NUM) || (!INTRO && TEXTSTRING < b.DAY_NUM)) 
          TEXTSTRING++;
        else if(!RECEIVED_EARNINGS && ((INTRO && TEXTSTRING == b.INTRO_NUM) || TEXTSTRING == b.DAY_NUM)) {
          b.comp.balance += b.comp.earnings;
          RECEIVED_EARNINGS = true;
        }
        else{
          MORN_TALK = true;
          CURRENT_SCREEN = 4;
        }
      }
      else {
        if(TEXTSTRING < b.AFTER_NUM) 
          TEXTSTRING++;
        else b.LEAVE = true;
      }
      
    //Input keys for Play Screen
    if(CURRENT_SCREEN == 4 && keyCode == 39 && !GAMESTART) {
      TEXTSTRING = b.DAY_NUM + 1;
      CURRENT_SCREEN = 3;
    }
    else if(CURRENT_SCREEN == 4 && keyCode == 32 && !GAMESTART) {
      notepad.openClose();
    }
    else if(CURRENT_SCREEN == 4 && keyCode == 37 && !GAMESTART) {
      ALLOW_INPUTS = GAMESTART = true;
    }
    else if(CURRENT_SCREEN == 4 && GAMESTART && ALLOW_INPUTS && (keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode == 40)) {
      userInput.append(keyCode);
      println(userInput);
    }
    else if(CURRENT_SCREEN == 4 && GAMESTART && ALLOW_INPUTS && keyCode == 10) {
      auction.compareInput(userInput, combos);
      clearInputs();
      ALLOW_INPUTS = false;
      //call method for AI
    }
    else if(CURRENT_SCREEN == 4 && !GAMESTART && !ALLOW_INPUTS && keyCode == 32) {
      TEXTSTRING = b.DAY_NUM + 1;
      GAMESTART = false;
      CURRENT_SCREEN = 3;
    }
    //Input keys for Loading Screen
    if(CURRENT_SCREEN == 2 && keyCode == 39) {
      //reset MarketGame stuff here
      nextDay();
      CURRENT_SCREEN = 3;
    }
  }
  //mouseClicked
  void changeScreen() {
    if(CURRENT_SCREEN == 0 && start.mouseOver()) 
      CURRENT_SCREEN = 3;
    else if(CURRENT_SCREEN == 0 && option.mouseOver())
      CURRENT_SCREEN = 1;
    else if(CURRENT_SCREEN == 0 && exit.mouseOver())
      exit();
  }
  private void displayText() {
    fill(10);
    if(TEXTSTRING == b.INTRO_NUM || TEXTSTRING == b.DAY_NUM) {
      textFont(regular_bold);
      text(textStrings.get("Boss" + TEXTSTRING) + b.comp.earnings + " yen", 50, height*.8, width - 50, height*.2);
    }
    else {
      textFont(regular);
      text(textStrings.get("Boss" + TEXTSTRING), 50, height*.8, width - 50, height*.2);
    }
  }
  private void drawUI() {
    textFont(bornaddict);
    textSize(25);
    fill(240);
    textAlign(LEFT);
    text("Day " + DAY, 5, height*.04);
    text("Money " + b.comp.balance, 5, height*.08);
    textAlign(CENTER);
    fill(240,240,240);
    noStroke();
    rect(0, height*.75, width, height*.25); 
  }
  private void drawArrow() {
    fill(10, millis() % 510);
    text("Press the right arrow", width*.8, height*.95);
  }
  private void drawContinue() {
    textSize(22);
    fill(10, millis() % 510);
    text("Press SPACEBAR to continue", width*.8, height*.95);
  }
  private void clearInputs() {
    userInput.clear();
    auction.DIGIT_ONE = auction.DIGIT_TWO = 0;
  }
  private void nextDay() {
    DAY++;
    if(INTRO) INTRO = false;
    RECEIVED_EARNINGS = b.LEAVE = MORN_TALK = false;
    TEXTSTRING = b.INTRO_NUM + 1;
    CURRENT_SCREEN = 3;
  }
  private void buyerTurn() {
     
  }
}
//-------------------------------------------------------------------------------------------------//
class Auction{
  int YOUR_BID, BUYER_BID, HIGHEST_BID, DIGIT_ONE, DIGIT_TWO;
  boolean WRONG_INPUT;
  Auction() {
    DIGIT_TWO = DIGIT_ONE = HIGHEST_BID = YOUR_BID = BUYER_BID = 0;
    WRONG_INPUT = false;
  }
  void display() {
    rectMode(CORNER);
    fill(10,150);
    rect(0, 0, width, height);
    fill(240);
    rectMode(CENTER);
    rect(width*.2, height*.45, 200, 40);
    rect(width*.8, height*.45, 200, 40);
    rect(width*.5, height*.1, 300, 50);
    rectMode(CORNER);
    textSize(30);
    textAlign(CENTER);
    fill(10);
    text(YOUR_BID, width*.2, height*.46);
    text(BUYER_BID, width*.8, height*.46);
    fill(240);
    text("Your bid", width*.2, height*.4);
    text("Rival bid", width*.8, height*.4);
    textSize(35);
    text("Highest bid", width*.5, height*.05); 
    textAlign(LEFT);
  }
  void updateBB(int bb) {
    BUYER_BID = bb;
    if(BUYER_BID > YOUR_BID) HIGHEST_BID = BUYER_BID;
  }
  void compareInput(IntList UI, StringList C) {
    println("In compareInput");
    String input = "";
    for(int i = 0; i < UI.size(); i++) 
      input = input + UI.get(i);
    for(int j = 0; j < C.size(); j++) {
      if(input.equals(C.get(j)) && DIGIT_ONE == 0) { 
        DIGIT_ONE = j;
        break;
      }
      else if (input.equals(C.get(j)) && DIGIT_ONE != 0 && DIGIT_ONE == 0) {
        DIGIT_TWO = j;
        break;
      }
      else{
        WRONG_INPUT = true;
      }
    }
    convertInputs();
  }
  private void convertInputs() {
    YOUR_BID = (DIGIT_ONE * 1000) + (DIGIT_TWO * 100); 
    if(YOUR_BID > BUYER_BID) HIGHEST_BID = YOUR_BID;
    else if (BUYER_BID > YOUR_BID) HIGHEST_BID = BUYER_BID;
  }
}
//-------------------------------------------------------------------------------------------------//
class Notes{
  PImage note;
  PVector loc;
  boolean OPEN_UP;
  Notes() {
    //800,600
    note = loadImage("notepad.jpg");
    loc = new PVector(width/2, height/2);
    OPEN_UP = false;
  }
  void display() {
    if(!OPEN_UP) {
      fill(10, 150);
      rect(0, 0, width, height);
      imageMode(CENTER);
      image(note, loc.x, loc.y);
      imageMode(CORNER);
    }
    else {
      fill(100,100,0);
      rect(width- 50, 10, 20, 30);
    }
  }
  void openClose() {
    if(!OPEN_UP)
      OPEN_UP = true;
    else OPEN_UP = false;
  }
}
//-------------------------------------------------------------------------------------------------//
//Time is money
class Company{
  String name;
  int balance, earnings;
  float tuna_amount;
  
  Company(String n) {
    name = n; 
    balance = 0;
    tuna_amount = 0;
    earnings = 10000;
  }
  //get rid of old tuna and replace it with freshly bought one
  void restock(float more_tuna) {
    tuna_amount = more_tuna;
  }
  
  String printblah() {
    return name + " " + balance + " " + tuna_amount;
  }
}
//-------------------------------------------------------------------------------------------------//
class Person{
  String name;
  int LOCX, DIALOGUE_NUM, INTRO_NUM, DAY_NUM;
  PImage img;
  boolean LEAVE, INTRO;
  Person() {    
  }
  void fixTransparency() {
    for(int i = 0; i < img.width * img.height; i++) {
      if((img.pixels[i] & 0x00FFFFFF) >= 0x00FAFAFA)
        img.pixels[i] = 0;
    }
    img.format = ARGB;
    img.updatePixels(); 
  }
  void move() {
    if(!LEAVE) {
      if(LOCX < width/3) 
        LOCX+=12;
    }
    else {
      if(LOCX > -img.width)
        LOCX-=12;
    }
  }
  void draw() {
    image(img, LOCX, 10);
  }
}
//-------------------------------------------------------------------------------------------------//
class Buyer extends Person{
   Buyer() {
     name = "Boyr";
     LOCX = 0;
     DIALOGUE_NUM = 0;
     INTRO_NUM = 0;
     DAY_NUM = 0;
     LEAVE = false;
     INTRO = true;
   }
}
//-------------------------------------------------------------------------------------------------//
//Big Boss
class Boss extends Person{
  Float happiness;
  Company comp;
  int AFTER_NUM;
  Boss(String n) {
    name = "Boss";
    happiness = 70.0;
    img = loadImage("newboss.jpg");
    img.resize(450,600);
    LOCX = -img.width;
    DIALOGUE_NUM = 13;
    INTRO_NUM = 4;
    DAY_NUM = 10;
    AFTER_NUM = 13;
    LEAVE = false;
    INTRO = true;
    comp = new Company(n);
    fixTransparency();
  }
}
//-------------------------------------------------------------------------------------------------//
//Would you press the button
class Button{
  String text;
  PVector location;
  color col,over;
  PFont pf;
  Button(String t, PVector l, int r, int g, int b) {
    text = t;
    location = l;
    col = color(r,g,b);
    over = color(r+100,g+100,b+100);
    pf = createFont("BornAddict.ttf", 25);
  }
  void draw() {
    if(mouseX >= location.x && mouseX <= location.x + 100 
    && mouseY >= location.y-20 && mouseY <= location.y + 20)
      fill(over);
    else
      fill(col);
    stroke(col);
    strokeWeight(4);
    beginShape();
      vertex(location.x,location.y);//1         vertex(86,115);//1
      vertex(location.x+42,location.y-25);//2   vertex(128,90);//2
      vertex(location.x+62,location.y-26);  //  vertex(148,89);
      vertex(location.x+67,location.y-42);    //vertex(153,73);
      vertex(location.x+92,location.y-30);    //vertex(178,85);
      vertex(location.x+94,location.y-22);   // vertex(180,93);
      vertex(location.x+102,location.y-20);//3  vertex(188,95);//3
      vertex(location.x+127,location.y);//4     vertex(213,115);//4
      vertex(location.x+152,location.y-25);//5  vertex(238,90);//5
      vertex(location.x+142,location.y);//6     vertex(228,115);//6
      vertex(location.x+152,location.y+25);//7  vertex(238,140);//7
      vertex(location.x+127,location.y);      //vertex(213,115);
      vertex(location.x+102,location.y+20);//8  vertex(188,135);//8
      vertex(location.x+62,location.y+24);   // vertex(148,139);
      vertex(location.x+42,location.y+24);//9   vertex(128,139);//9
      vertex(location.x+2,location.y+5);//10    vertex(88,120);//10
    endShape(CLOSE);
    textAlign(CENTER);
    fill(250);
    textFont(pf);
    text(text, location.x+65, location.y+8);
  }
  boolean mouseOver() {
    if(mouseX >= location.x && mouseX <= location.x + 100 
    && mouseY >= location.y-20 && mouseY <= location.y + 20) 
      return true;
    return false;
  }
}