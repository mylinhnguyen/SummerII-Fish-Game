//add something to show boss happiness
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
  mg.mouseInput();
}
//-------------------------------------------------------------------------------------------------//
//↑ ↓ → ←
class MarketGame {
  int CURRENT_SCREEN, DAY, TEXTSTRING, SELECTED_TUNA, CUSTOMER_COUNT, BOUGHT_PRICE, salNum, mackNum, squidNum;
  IntList userInput;
  StringList combos, locations;
  StringDict textStrings;
  PFont regular, regular_italic, regular_bold, bornaddict;
  PImage bg, bg1, bg2, bg3, bg4, bg5, bg6;
  boolean MORN_TALK, GAMESTART, ALLOW_INPUTS, COUNTED, INTRO, RECEIVED_EARNINGS, AT_TUNA_MARKET, AT_FISH_MARKET, SHOW_BUYER, NEW_DAY_ANIM, STORE_CLOSE;
  Boss b;
  Button start, info, exit;
  Notes notepad;
  Auction auction;
  Market market;
  Tuna[] tunas = new Tuna[10];
  Customer[] customers = new Customer[100];
  Timer timer;
  MarketGame() {
    salNum = mackNum = squidNum = SELECTED_TUNA = CURRENT_SCREEN = 0;
    TEXTSTRING = DAY = 1;
    BOUGHT_PRICE = 0;
    userInput = new IntList();
    combos = new StringList();
    locations = new StringList();
    addLocations();
    addCombos();
    STORE_CLOSE = NEW_DAY_ANIM = SHOW_BUYER = AT_FISH_MARKET = AT_TUNA_MARKET = RECEIVED_EARNINGS = MORN_TALK = GAMESTART = ALLOW_INPUTS = COUNTED = false;
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
    bg6 = loadImage("background6.jpg");
    b = new Boss("Soosh-E");
    start = new Button("Start", new PVector(width/7, height*.5), 150, 70, 0);
    info = new Button("Info", new PVector(width/10, height*.6), 180, 180, 180);
    exit = new Button("Exit", new PVector(width/7, height*.7), 0, 150, 0);
    notepad = new Notes();
    auction = new Auction();
    market = new Market();
    timer = new Timer(5, new PVector(width/2-85, 500));
    int x = 100;
    int y = 300;
    for(int i = 0; i < tunas.length; i++) {
      tunas[i] = new Tuna(new PVector(x, y), 80, locations.get(int(random(0,locations.size()-1)))); 
      println(tunas[i].print());
      x+=250;
      if(i == 4) {
        x = 100;
        y = 450;
      }
    }
    for(int j = 0; j < customers.length; j++) 
      customers[j] = new Customer();
    notepad.setNums(b.reqSal, b.reqMack, b.reqSquid);
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
    textStrings.set("Boss10", "\"Sales were horrible. I hope today is better.\"");
    textStrings.set("Boss11", "\"Sales were great! Keep up the good work.\"");
    
    textStrings.set("Boss12","Received ");
    textStrings.set("Boss13", "\"Welcome back. Did you get what I wanted?\"");
    textStrings.set("Boss14", "\"There better still be cash on you or else if comes out of your paycheck.\"");
    //add dialogue for when giving fish to boss
    textStrings.set("Boss15", "Handed over the fish.");
    textStrings.set("Boss16", "\"Hmm...\"");
    textStrings.set("Boss17", "\"The quality could be better, but it'll have to do.\"");
    textStrings.set("Boss18", "\"Looks good. Let's hope it sales.\"");
    textStrings.set("Boss19", "\"This is top quality! I'm sure this will sale for a lot.\"");
    textStrings.set("Boss20", "\"Tomorrow we'll see how well your fish sales.\"");
    textStrings.set("Boss21","\"See you tomorrow.\"");
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
  private void addLocations() {
    locations.append("New Zealand");
    locations.append("California");
    locations.append("Nova Scotia");
    locations.append("Mexico");
    locations.append("Mediterranean");
    locations.append("Japan");
  }
  void play() {
    if(CURRENT_SCREEN == 0)
      StartScreen();
    else if(CURRENT_SCREEN == 1) 
      SettingScreen();
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
    info.draw();
    exit.draw();
  }
  private void SettingScreen() {
    background(bg5);
    //will probably add story here too - what your goal is - sound if/when I add music
  }
  private void BossScreen() {
    background(bg2);
    b.move();
    b.draw();
    drawUI(true);
    drawContinue();
    displayText();
  }
  private void MarketScreen() {
    background(bg6);
    drawUI(false);
    auction.displayIcon();
    market.displayIcon();
    notepad.display();
    if(auction.WIN) drawWinText();
    if(AT_TUNA_MARKET) {
      background(bg3);
      notepad.display();
      textFont(regular);
      for(int i = 0; i < tunas.length; i++) 
        tunas[i].draw(); 
      drawUI(false);
      if(SHOW_BUYER) {
        auction.buyer.draw();
        drawUI(true);
        displayText();
      }
      else if(GAMESTART) {
        timer.run();
        timer.display();
        auction.display();
        if(timer.TIME_UP) {
          tunas[SELECTED_TUNA].LOOK_AT = true;
          auction.totalReset();
          GAMESTART = false;
        }
      
      }
      if(tunas[SELECTED_TUNA].LOOK_AT) drawLoseText();
    }
    else if(AT_FISH_MARKET){
      market.drawMarket();
      drawEnter("buy");
    }
  }
  private void LoadingScreen() {
    background(bg1);
    if(!STORE_CLOSE) drawLoading();
    else drawEnter("continue");
  }
  private void ANewDayScreen() {
    //moon going down and sun coming up animation  
    background(bg3);
    openStore();
    CURRENT_SCREEN = 2;
  }
  //Backspace 8, Enter 13, Spacebar 32, Left 37, Up 38, Right 39, Down 40
  //Probably could make this simpler...
  void inputKey() {    
    //Input keys for Boss Screen
    if(CURRENT_SCREEN == 3 && keyCode == 32) {
      if(b.LEAVE) CURRENT_SCREEN = 5;
      
      if(!MORN_TALK) {
        if((INTRO && TEXTSTRING < b.INTRO_NUM) || (!INTRO && TEXTSTRING < b.DAY_NUM)) {
          if(TEXTSTRING == 10) TEXTSTRING = 12;
          else if(TEXTSTRING == 9) {
            int result = b.salesHappy(BOUGHT_PRICE);
            if(result == 0) TEXTSTRING++;
            else if(result == 1) TEXTSTRING+=2;
          }
          else TEXTSTRING++;
        }
        else if(!RECEIVED_EARNINGS && ((INTRO && TEXTSTRING == b.INTRO_NUM) || TEXTSTRING == b.DAY_NUM)) {
          b.comp.balance += b.comp.earnings;
          RECEIVED_EARNINGS = true;
        }
        else{
          if(INTRO) TEXTSTRING = 1;
          else TEXTSTRING = auction.buyer.INTRO_NUM + 1;
          MORN_TALK = true;
          CURRENT_SCREEN = 4;
        }
      }
      else {
        if(TEXTSTRING < b.DIALOGUE_NUM) {
          if(TEXTSTRING == 17 || TEXTSTRING == 18) TEXTSTRING = 20;
          else if(TEXTSTRING == 16) {
             int result = b.qualityHappy(b.comp.TUNA_QUALITY);
             if(result == 0) TEXTSTRING++;
             else if(result == 1) TEXTSTRING+=2;
             else TEXTSTRING+=3;
          }
          else TEXTSTRING++;
        }
        else b.LEAVE = true;
      }
    }
    //Input keys for Play Screen
    if(CURRENT_SCREEN == 4) {
       if(!GAMESTART && (keyCode == 78 || keyCode == 110)) 
         notepad.openClose();
       else if(AT_FISH_MARKET) {
         if(keyCode == 8)
           AT_FISH_MARKET = false;
         else if(keyCode == 10) {
          //buy all fish here
          b.comp.buy(market.TOTAL);
          salNum = market.SALMON_QUANT;
          mackNum = market.MACKEREL_QUANT;
          squidNum = market.SQUID_QUANT;
          AT_FISH_MARKET = false;
         }
       }
       else if(!GAMESTART && AT_TUNA_MARKET && SHOW_BUYER && keyCode == 32) {
         if((INTRO && TEXTSTRING < auction.buyer.INTRO_NUM) || (!INTRO && TEXTSTRING < auction.buyer.DAY_NUM)) {
           TEXTSTRING++;
         }
         else SHOW_BUYER = false;
       }
       else if(GAMESTART && ALLOW_INPUTS) {
         if(keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode == 40) 
           userInput.append(keyCode); 
         //User inputs first digit
         else if(keyCode == 32) {
           auction.compareInput(userInput, combos, "");
           userInput.clear();
           if(auction.WRONG_INPUT) {
             GAMESTART = false;
             tunas[SELECTED_TUNA].LOOK_AT = true;
             //change println to text on screen
             auction.totalReset();
           }
         }
         //User inputs second digit
         else if(keyCode == 10) {
           auction.compareInput(userInput, combos, "Last");
           userInput.clear();
           ALLOW_INPUTS = false;
           if(auction.WRONG_INPUT) {
             GAMESTART = false;
             tunas[SELECTED_TUNA].LOOK_AT = true;
             auction.totalReset();
           }
           auction.miniReset();
           auction.buyerBid(tunas[SELECTED_TUNA].quality);
           timer.reset();
           if(auction.WIN) {
             //user buys the fish they chose SELECTED_TUNA
             if(auction.YOUR_BID > b.comp.balance) {
               GAMESTART = false;
               tunas[SELECTED_TUNA].LOOK_AT = true;
               auction.totalReset();
               auction.WIN = false;
             }
             else {
               b.comp.buy(auction.YOUR_BID);
               BOUGHT_PRICE = auction.YOUR_BID;
               AT_TUNA_MARKET = GAMESTART = false;
             }
           }
           ALLOW_INPUTS = true;
         }
       }
       else if(auction.WIN && keyCode == 32) {
         TEXTSTRING = b.DAY_NUM + 1;
         b.comp.restock(tunas[SELECTED_TUNA]);
         b.otherFishHappy(salNum, mackNum, squidNum);
         ALLOW_INPUTS = false;
         CURRENT_SCREEN = 3;
       }
    }
    //Input keys for Loading Screen
    if(CURRENT_SCREEN == 2 && keyCode == 32) {
      //reset MarketGame stuff here
      nextDay();
      CURRENT_SCREEN = 3;
    }
  }
  //mouseClicked
  void mouseInput() {
    if(CURRENT_SCREEN == 0) {
      if(start.mouseOver())
        CURRENT_SCREEN = 3;
      else if(info.mouseOver())
        CURRENT_SCREEN = 1;
      else if(exit.mouseOver()) 
        exit();
      timer.reset();
    }
    if(CURRENT_SCREEN == 4) {
      if(!AT_TUNA_MARKET) {
        if(auction.mouseOver() && !auction.WIN)
          SHOW_BUYER = AT_TUNA_MARKET = true;
        else if(market.mouseOver() && !AT_FISH_MARKET) {
          AT_FISH_MARKET = true;
        }
        else if(AT_FISH_MARKET) {
          market.addFish(); 
        }
      }
      else if(AT_TUNA_MARKET && !SHOW_BUYER) {
        for(int i = 0; i < tunas.length; i++) {
          if(tunas[i].mouseOver()) {
            ALLOW_INPUTS = GAMESTART = true;
            timer.reset();
            SELECTED_TUNA = i;
          }
        }
      }
    }
  }
  private void displayText() {
    fill(10);
    if(CURRENT_SCREEN == 3) {
      if(TEXTSTRING == b.INTRO_NUM || TEXTSTRING == b.DAY_NUM || TEXTSTRING == 15) {
        textFont(regular_bold);
        if(TEXTSTRING == 15) text(textStrings.get("Boss" + TEXTSTRING), 50, height*.8, width - 50, height*.2);
        else  text(textStrings.get("Boss" + TEXTSTRING) + b.comp.earnings + " yen", 50, height*.8, width - 50, height*.2);
      }
      else {
        textFont(regular);
        text("Boss: " + textStrings.get("Boss" + TEXTSTRING), 50, height*.8, width - 50, height*.2);
      }
    }
    else if(CURRENT_SCREEN == 4 && !GAMESTART && !ALLOW_INPUTS && SHOW_BUYER){
      textFont(regular);
      text(auction.buyer.name + ": " + textStrings.get("Buyer" + TEXTSTRING), 50, height*.8, width - 50, height*.2);
    }
  }
  void openStore() {
    CUSTOMER_COUNT = 0;
    for(Customer c: customers) {
      if(c.visit(b.comp.TUNA_QUALITY) != 0 && c.buyAmount <= b.comp.TUNA_AMOUNT) {
        b.comp.makeEarnings(c.spend);
        b.comp.sellTuna(c.buyAmount);
        CUSTOMER_COUNT++;
        println(CUSTOMER_COUNT + " " + b.comp.earnings);
      }
    }
    b.comp.makeEarnings(1000);
    STORE_CLOSE = true;
  }
  private void drawUI(boolean bool) {
    textFont(bornaddict);
    textSize(25);
    fill(240);
    textAlign(LEFT);
    text("Day " + DAY, 5, height*.04);
    text("Money " + b.comp.balance, 5, height*.08);
    if(bool) {
      textAlign(CENTER);
      fill(240,240,240);
      noStroke();
      rect(0, height*.75, width, height*.25); 
    }
  }
  private void drawLoseText() {
    textFont(bornaddict);
    textSize(30);
    fill(240, millis() % 1020);
    text("You did not get to buy the tuna.", width*.3, height*.05); 
  }
  private void drawWinText() {
    textFont(bornaddict); 
    textSize(30);
    fill(240, millis() % 1020);
    text("You bought the tuna!", width*.4, height*.05);
  }
  private void drawContinue() {
    textSize(22);
    fill(10, millis() % 510);
    text("Press SPACEBAR to continue", width*.8, height*.95);
  }
  private void drawEnter(String s) {
    textFont(regular_bold);
    textSize(40);
    fill(240, millis() % 1020);
    text("Press Enter to " + s, width*.8, height*.95);
  }
  private void drawLoading() {
    textFont(regular_bold);
    textSize(40);
    fill(240, millis() % 1020);
    text("Loading...", width*.8, height*.95);
  }
  private void nextDay() {
    DAY++;
    salNum = squidNum = mackNum = 0;
    if(INTRO) INTRO = false;
    STORE_CLOSE = auction.WIN = RECEIVED_EARNINGS = b.LEAVE = MORN_TALK = false;
    auction.totalReset();
    TEXTSTRING = b.INTRO_NUM + 1;
    CURRENT_SCREEN = 3;
    for(Tuna t : tunas)
      t.reset(0, 0, 0);
    for(Customer c : customers)
      c.reset();
    b.reset();
  }
}
//-------------------------------------------------------------------------------------------------//
class Auction{
  int YOUR_BID, BUYER_BID, HIGHEST_BID, DIGIT_ONE, DIGIT_TWO,YB_STORED;
  boolean WRONG_INPUT, WIN;
  PImage framel, framew, door, a_note;
  Buyer buyer;
  Auction() {
    DIGIT_TWO = DIGIT_ONE = HIGHEST_BID = YOUR_BID = BUYER_BID = 0;
    WIN = WRONG_INPUT = false;
    buyer = new Buyer();
    door = loadImage("steeldoor.jpg");
    framel = loadImage("darkconcrete.jpg");
    framew = loadImage("darkconcrete.jpg");
    framel.resize(10, 270);
    framew.resize(300, 10);
    a_note = loadImage("auctionNote.jpg");
  }
  void displayIcon() {
    noStroke();
    image(door, 800, 50);
    image(framel, 800, 50);
    image(framel, 1100, 50);
    image(framew, 800, 50);
    fill(240);
    rect(700, 100, 80, 60, 4);
    textSize(20);
    textAlign(CENTER);
    fill(15);
    text("Tuna Auction", 700, 100, 80, 60); 
    textAlign(LEFT);
  }
  void display() {
    rectMode(CORNER);
    fill(10,150);
    rect(0, 0, width, height);
    fill(240);
    rectMode(CENTER);
    rect(width*.2, height*.45, 200, 40);
    rect(width*.8, height*.45, 200, 40);
    //rect(width*.5, height*.1, 300, 50);
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
    //text("Highest bid", width*.5, height*.05); 
    textAlign(LEFT);
    image(a_note, 0, height-125);
  }
  void compareInput(IntList UI, StringList C, String type) {
    String input = "";
    for(int i = 0; i < UI.size(); i++) 
      input = input + UI.get(i);
    for(int j = 0; j < C.size(); j++) {
      if(DIGIT_ONE == 0 && input.equals(C.get(j))) { 
        DIGIT_ONE = j;
        if(type == "Last" && DIGIT_ONE * 1000 > BUYER_BID) YOUR_BID = DIGIT_ONE * 1000;
        else if(type == "Last" && DIGIT_ONE * 1000 <= BUYER_BID) WRONG_INPUT = true;
        else YB_STORED = DIGIT_ONE * 1000;
        break;
      }
      else if (DIGIT_ONE != 0 && input.equals(C.get(j))) {
        DIGIT_TWO = j;
        YOUR_BID = YB_STORED + DIGIT_TWO * 100;
        if(YOUR_BID <= BUYER_BID) WRONG_INPUT = true;
        break;
      }
    }
    if(DIGIT_ONE == 0) WRONG_INPUT = true;
  }
  void buyerBid(float q) {
    int result = round(random(0,100));
    if(result <= buyer.BID_CHANCE) {
      BUYER_BID = YOUR_BID + 100;
      buyer.BID_CHANCE-=pow(2,buyer.RATE);
      println(buyer.BID_CHANCE);
      if(q >= 2) buyer.RATE+=.3;
      else buyer.RATE++;
    }
    if(BUYER_BID > YOUR_BID) HIGHEST_BID = BUYER_BID;
    else WIN = true;
    }
  void miniReset() {
    DIGIT_ONE = DIGIT_TWO = 0;
    WRONG_INPUT = false;
  }
  void totalReset() {
    YOUR_BID = BUYER_BID = DIGIT_ONE = DIGIT_TWO = 0;
    WRONG_INPUT = false;
    buyer.BID_CHANCE = 100.0;
  }
  boolean mouseOver() {
    if(mouseX > 800 && mouseX < 1100 
    && mouseY > 50  && mouseY < 320) 
      return true;
    return false;
  }
}
//-------------------------------------------------------------------------------------------------//
class Market{
  PImage stallbase, stallbeam;
  int SALMON_PRICE, MACKEREL_PRICE, SQUID_PRICE, TOTAL;
  int SALMON_QUANT, MACKEREL_QUANT, SQUID_QUANT;
  PFont arial;
  SmallButton salmin, salplus, mackmin, mackplus, squimin, squiplus;
  Market() {
    stallbase = loadImage("woodcrate.jpg");
    stallbeam = loadImage("woodbeam.jpg");
    arial = createFont("ARIAL.TTF", 25);
    stallbeam.resize(50,200);
    salmin = new SmallButton("-", new PVector(385, 575), 100, 100, 200);
    salplus = new SmallButton("+", new PVector(465, 575), 200, 100, 100);
    mackmin = new SmallButton("-", new PVector(585, 575), 100, 100, 200);
    mackplus = new SmallButton("+", new PVector(665, 575), 200, 100, 100);
    squimin = new SmallButton("-", new PVector(785, 575), 100, 100, 200);
    squiplus = new SmallButton("+", new PVector(865, 575), 200, 100, 100);
    SALMON_QUANT = MACKEREL_QUANT = SQUID_QUANT = 0;
    SALMON_PRICE = 500;
    MACKEREL_PRICE = 200;
    SQUID_PRICE = 300;
  }
  void displayIcon() {
    image(stallbeam, 200, 200);
    image(stallbeam, 450, 200);
    fill(190);
    rect(220,375,80,60,6);
    rect(310,375,80,60,6);
    rect(400,375,80,60,6);
    image(stallbase, 150, 400);
    fill(230);
    stroke(70, 50, 0);
    strokeWeight(5);
    rect(100, 100 ,500, 125, 8);
    fill(10);
    textSize(80);
    text("Fresh Fish", 140, 190);
  }
  void drawMarket() {
    rectMode(CORNER);
    fill(10,200);
    rect(0, 0, width, height);
    fill(200);
    rect(200, 150, 800, 400);
    fill(150);
    rect(200, 550, 800, 100);
    //close up of fish in their containers
    textFont(arial);
    salmin.draw();
    salplus.draw();
    mackmin.draw();
    mackplus.draw();
    squimin.draw();
    squiplus.draw();
    fill(10);
    text("Salmon: " + SALMON_QUANT, 420, 625);
    text("Mackerel: " + MACKEREL_QUANT, 620, 625);
    text("Squid: " + SQUID_QUANT, 820, 625);
    fill(240);
    textSize(30);
    text("Total: " + TOTAL, width/2, 700);
  }
  void addFish() {
    if(salmin.mouseOver() && SALMON_QUANT > 0) SALMON_QUANT--;
    else if(salplus.mouseOver()) SALMON_QUANT++;
    else if(mackmin.mouseOver() && MACKEREL_QUANT > 0) MACKEREL_QUANT--;
    else if(mackplus.mouseOver()) MACKEREL_QUANT++;
    else if(squimin.mouseOver() && SQUID_QUANT > 0) SQUID_QUANT--;
    else if(squiplus.mouseOver()) SQUID_QUANT++;
    TOTAL = SALMON_QUANT*SALMON_PRICE + MACKEREL_QUANT*MACKEREL_PRICE + SQUID_QUANT*SQUID_PRICE;
  }
  void reset() {
    TOTAL = SALMON_QUANT = MACKEREL_QUANT = SQUID_QUANT = 0;
  }
  boolean mouseOver() {
    if(mouseX > 100 && mouseX < 600 && mouseY > 100 && mouseY < 600)
      return true;
    return false;
  }
}
//-------------------------------------------------------------------------------------------------//
class Notes{
  PImage note;
  PVector loc;
  boolean OPEN_UP, SALMON_GOOD, MACK_GOOD, SQUID_GOOD;
  int sal, mac, squ;
  Notes() {
    //800,600
    note = loadImage("notepad.jpg");
    loc = new PVector(width/2, height/2);
    OPEN_UP = false;
  }
  void display() {
    noStroke();
    if(OPEN_UP) {
      fill(10, 150);
      rect(0, 0, width, height);
      imageMode(CENTER);
      image(note, loc.x, loc.y);
      imageMode(CORNER);
      fill(10);
      textSize(20);
      text("Buy " + sal + " salmon", 650, 250);
      text("Buy " + mac + " mackerel", 650, 300);
      text("Buy " + squ + " squid", 650, 350);
    }
    else {
      //need to make icon
      fill(100,100,0);
      rect(width- 50, 10, 20, 30);
    }
  }
  void openClose() {
    if(!OPEN_UP)
      OPEN_UP = true;
    else OPEN_UP = false;
  }
  void setNums(int sa, int m, int sq) {
    sal = sa;
    mac = m;
    squ = sq;
  }
}
//-------------------------------------------------------------------------------------------------//
//Time is money
class Company{
  String name;
  int balance, earnings;
  float TUNA_AMOUNT, TUNA_QUALITY;
  
  Company(String n) {
    name = n; 
    balance = 0;
    TUNA_AMOUNT = TUNA_QUALITY = 0;
    earnings = 5000;
  }
  //get rid of old tuna and replace it with freshly bought one
  void restock(Tuna t) {
    TUNA_AMOUNT = t.weight;
    TUNA_QUALITY = t.quality;
    earnings = 0;
  }
  void buy(int amount) {
    balance-=amount; 
  }
  void makeEarnings(int e) {
    earnings+=e;
  }
  void sellTuna(int a) {
    TUNA_AMOUNT-=a; 
  }
}
//-------------------------------------------------------------------------------------------------//
class Person{
  String name;
  int LOCX, DIALOGUE_NUM, INTRO_NUM, DAY_NUM;
  //450, 600
  PImage img;
  boolean LEAVE;
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
    image(img, LOCX, 5);
  }
}
//-------------------------------------------------------------------------------------------------//
class Buyer extends Person{
  Float BID_CHANCE, RATE;
   Buyer() {
     name = "Boyr";
     DIALOGUE_NUM = 4;
     INTRO_NUM = 2;
     DAY_NUM = 4;
     LEAVE = false;
     img = loadImage("buyer.jpg");
     LOCX = img.width;
     fixTransparency();
     BID_CHANCE = 100.0;
     RATE = 1.0;
   }
}
//-------------------------------------------------------------------------------------------------//
//Big Boss
class Boss extends Person{
  Float happiness;
  Company comp;
  int AFTER_NUM, reqSal, reqMack, reqSquid;
  Boss(String n) {
    name = "Boss";
    happiness = 70.0;
    img = loadImage("newboss.jpg");
    img.resize(450,600);
    LOCX = -img.width;
    DIALOGUE_NUM = 21;
    INTRO_NUM = 4;
    DAY_NUM = 12;
    AFTER_NUM = 21;
    LEAVE = false;
    comp = new Company(n);
    fixTransparency();
    reqSal = int(random(0,4));
    reqMack = int(random(0,4));
    reqSquid = int(random(0,4));
  }
  boolean checkHappy() {
   if(happiness < 40) return false;
   return true; 
  }
  void otherFishHappy(int sa, int m, int sq) {
    if(sa == reqSal) happiness+=.3;
    else happiness -=.3;
    if(m == reqMack) happiness+=.3;
    else happiness -=.3;
    if(sq == reqSquid) happiness+=.3;
    else happiness -=.3;
  }
  int salesHappy(int c) {
    if(c > comp.earnings) {
      happiness-=1;
      return 0;
    }
    else {
      happiness+=2;
      return 1;
    }
  }
  int qualityHappy(float q) {
    if(q < 2) {
      happiness-=1;
      return 0;
    }
    else if(q >= 2 && q < 4) {
      happiness+=2;
      return 1;
    }
    else {
      happiness+=3;
      return 2;
    }
  }
  void reset() {
    reqSal = int(random(0,4));
    reqMack = int(random(0,4));
    reqSquid = int(random(0,4));
  }
}
//-------------------------------------------------------------------------------------------------//
class Customer{
  int prefQuality, qCost, buyAmount, spend;
  Customer() {
    prefQuality = abs(round(randomGaussian() * 2));
    if(0 <= prefQuality && prefQuality < 2) qCost = 10;
    else if(2 <= prefQuality && prefQuality < 4) qCost = 15;
    else qCost = 20;
  }
  int visit(float t_quality) {
    if(t_quality >= prefQuality) {
      if(prefQuality == 0) buyAmount = 1;
      else buyAmount = prefQuality;
      spend = buyAmount * qCost;
      return spend;
    }
    return 0;
  }
  void reset() {
    prefQuality = abs(round(randomGaussian() * 2));
    if(0 <= prefQuality && prefQuality < 2) qCost = 10;
    else if(2 <= prefQuality && prefQuality < 4) qCost = 15;
    else qCost = 20; 
  }
}
//-------------------------------------------------------------------------------------------------//
//quality > quantity
class Tuna{
  Float quality;
  int weight, fat, size;
  boolean LOOK_AT;
  PVector loc;
  String locCaught;
  
  Tuna(PVector l, int s, String lc) {
    fat = round(random(3,20));
    weight = abs(int(randomGaussian() * 150 + fat * 5));
    quality = abs(randomGaussian() * 2) + fat/20;
    LOOK_AT = false;
    size = s;
    loc = l;
    locCaught = lc;
  }
  void draw() {
    noStroke();
    if(!LOOK_AT) {
      fill(0,0,200);
      ellipse(loc.x, loc.y, size, size); 
      if(this.mouseOver()) {
        fill(240, 200);
        if(mouseX+200 > width) {
          rect(mouseX - 200, mouseY, 200, 100);
          fill(10);
          textSize(20);
          text("Weight: " + this.weight + "\n" + "Caught: " + this.locCaught, mouseX - 195, mouseY+10, 200, 100);
        }
        else{
          rect(mouseX, mouseY, 200, 100);
          fill(10);
          textSize(20);
          text("Weight: " + this.weight + "\n" + "Caught: " + this.locCaught, mouseX+5, mouseY+10, 200, 100);
        }        
      }
    }
  }
  boolean mouseOver() {
    if(mouseX >= loc.x && mouseX <= loc.x + size 
    && mouseY >= loc.y && mouseY <= loc.y + size) 
      return true;
    return false;
  }
  void reset(int f, int w, int q) {
    fat = round(random(3,20));
    weight = abs(round(randomGaussian() * 150 + fat * 5));
    quality = abs(randomGaussian() * 2);
    LOOK_AT = false;
  }
  String print() {
     return "Weight: " + weight + " Fat: " + fat + " Quality: " + quality;
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
    col = color(r, g, b);
    over = color(r+100, g+100, b+100);
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
//-------------------------------------------------------------------------------------------------//
class SmallButton{
  String text;
  PVector location;
  color col, over;
  int size;
  SmallButton(String t, PVector l, int r, int g, int b) {
    text = t;
    location = l;
    col = color(r, g, b);
    over = color(r+100, g+100, b+100);
    size = 30;
  }
  void draw() {
    if(mouseX >= location.x && mouseX <= location.x + size 
    && mouseY >= location.y && mouseY <= location.y + size)
      fill(over);
    else
      fill(col);
    stroke(col);
    strokeWeight(4);
    ellipse(location.x, location.y, size, size);
    fill(240);
    textAlign(CENTER);
    text(text, location.x, location.y+10);
  }
  boolean mouseOver() {
    if(mouseX >= location.x && mouseX <= location.x + size 
    && mouseY >= location.y && mouseY <= location.y + size) 
      return true;
    return false;
  }
}
//-------------------------------------------------------------------------------------------------//
class Timer{
  int secondLimit, currentSec, currentMin, startMin, timeLimitSec, timeLimitMin, timeLeft, newSize;
  boolean COUNTDOWN, TIME_UP;
  PVector loc, size;
  color red, yellow, green, currentCol;
  Timer(int s, PVector l) {
    secondLimit = s;
    COUNTDOWN = TIME_UP = false;
    loc = l;
    size = new PVector(170, 40);
    newSize = 100;
    red = color(250, 0, 0);
    yellow = color(250, 250, 0);
    currentCol = green = color(0, 250, 0);
  }
  void run() {
    if(!COUNTDOWN) {
      timeLimitSec = second() + secondLimit;
      startMin = minute();
      COUNTDOWN = true; 
    }
    if(!TIME_UP) {
      currentSec = second();
      currentMin = minute();
      if(currentMin !=  startMin && timeLimitSec >= 60)
         timeLeft = timeLimitSec - currentSec - 60;
      else 
        timeLeft = timeLimitSec - currentSec;
      currentCol = lerpColor(red, green, timeLeft*.1);
      newSize= (int)(size.x * (timeLeft*.1)*2);
      if(timeLeft <= 0)
        TIME_UP = true;
    }
  }
  void display() {
    stroke(240);
    fill(240);
    rect(loc.x, loc.y, size.x, size.y, 3);
    fill(currentCol);
    noStroke();
    rect(loc.x, loc.y, newSize, size.y, 3);
  }
  void reset() {
    currentCol = green;
    newSize = int(size.x);
    TIME_UP = COUNTDOWN = false;
  }
}