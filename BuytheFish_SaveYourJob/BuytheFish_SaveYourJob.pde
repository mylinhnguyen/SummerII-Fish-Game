import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

MarketGame mg;
Minim minim, m2, m3;
AudioPlayer player, p2, p3;

void setup() {
  size(1200,800);
  frameRate(30);
  mg = new MarketGame();
  minim = new Minim(this);
  m2 = new Minim(this);
  m3 = new Minim(this);
  player = minim.loadFile("calmness.mp3");
  p2 = m2.loadFile("100840__lonemonk__approx-5000-crowd-noise.wav");
  p3 = m3.loadFile("5s-to-50.mp3");
  player.play();
}
void draw() {
  mg.play();
  audio();
}
void keyPressed() {
  mg.inputKey();
}
void mouseClicked() {
  mg.mouseInput();
}
void audio() {
  if(mg.CURRENT_SCREEN == 4) {
    if(!mg.GAMESTART) {
      if(player.isPlaying()) player.pause(); 
      if(p3.isPlaying()) p3.pause();
      p2.play();
      if(!p2.isPlaying()) {
         p2.rewind();
         p2.play();
         p2.loop();
      }
    }
    else if(mg.GAMESTART){
      if(p2.isPlaying()) p2.pause();
      p3.play();
      if(!p3.isPlaying()) {
        p3.rewind();
        p3.play();
        p3.loop();
      }
    }
  }
  else if(mg.CURRENT_SCREEN == 3 && mg.MORN_TALK) {
    if(p2.isPlaying()) p2.pause();
    if(p3.isPlaying()) p3.pause();
    player.play();
    player.loop();
  }
  else if(mg.CURRENT_SCREEN == 2) {
    player.rewind();
    p2.rewind();
    p3.rewind();
  }
}
//-------------------------------------------------------------------------------------------------//
//↑ ↓ → ←
class MarketGame {
  int CURRENT_SCREEN, DAY, TEXTSTRING, CUSTOMER_COUNT;
  StringList combos, locations;
  StringDict textStrings;
  PFont regular, regular_italic, regular_bold, bornaddict;
  PImage bg, bg1, bg2, bg3, bg6, crowd;
  boolean MORN_TALK, GAMESTART, ALLOW_INPUTS, COUNTED, INTRO, RECEIVED_EARNINGS, AT_TUNA_MARKET, AT_FISH_MARKET, SHOW_BUYER, NEW_DAY_ANIM, STORE_CLOSE, MENU_OPEN, NO_TUNA, FIRE;
  User user;
  Boss b;
  Button start, info, exit;
  Notes notepad;
  Auction auction;
  Market market;
  GameMenu gm;
  Tuna[] tunas = new Tuna[10];
  Customer[] customers = new Customer[100];
  Timer timer;
  MarketGame() {
    CURRENT_SCREEN = 0;
    TEXTSTRING = DAY = 1;
    combos = new StringList();
    locations = new StringList();
    addLocations();
    addCombos();
    FIRE = NO_TUNA = MENU_OPEN = STORE_CLOSE = NEW_DAY_ANIM = SHOW_BUYER = AT_FISH_MARKET = AT_TUNA_MARKET = RECEIVED_EARNINGS = MORN_TALK = GAMESTART = ALLOW_INPUTS = COUNTED = false;
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
    bg6 = loadImage("background6.jpg");
    crowd = loadImage("crowdonly.png");
    user = new User();
    b = new Boss();
    start = new Button("Start", new PVector(width/7, height*.5), 150, 70, 0);
    info = new Button("Info", new PVector(width/10, height*.6), 180, 180, 180);
    exit = new Button("Exit", new PVector(width/7, height*.7), 0, 150, 0);
    notepad = new Notes();
    auction = new Auction();
    market = new Market();
    gm = new GameMenu();
    timer = new Timer(5, new PVector(width/2-85, 500));
    int x = 100;
    int y = 250;
    for(int i = 0; i < tunas.length; i++) {
      tunas[i] = new Tuna(new PVector(x, y), locations.get(int(random(0,locations.size()-1)))); 
      //println(tunas[i].print());
      x+=250;
      if(i == 3 || i == 7) {
        x = 100;
        y+=150;
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
    textStrings.set("Boss15", "Handed over the fish.");
    textStrings.set("Boss16", "\"Hmm...\"");
    textStrings.set("Boss17", "\"The quality could be better, but it'll have to do.\"");
    textStrings.set("Boss18", "\"Looks good. Let's hope it sales.\"");
    textStrings.set("Boss19", "\"This is top quality! I'm sure this will sale for a lot.\"");
    textStrings.set("Boss20", "\"Tomorrow we'll see how well your fish sales.\"");
    textStrings.set("Boss21","\"See you tomorrow.\"");
    textStrings.set("Bossfire", "\"You're fired.\"");
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
    else if(CURRENT_SCREEN == 6)
      GameOverScreen();
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
    start.move();
    info.move();
    exit.move();
  }
  private void GameOverScreen() {
    background(10);
    fill(240);
    textSize(90);
    textAlign(CENTER);
    text("Game Over", width/2, height/2);
    displayText();
  }
  private void SettingScreen() {
    background(bg3);
  }
  private void BossScreen() {
    background(bg2);
    b.move();
    b.draw();
    b.displayHappy();
    drawUI(true);
    drawContinue();
    displayText();
    if(MENU_OPEN) gm.display();
  }
  private void MarketScreen() {
    background(bg6);
    drawUI(false);
    auction.displayIcon();
    market.displayIcon();
    notepad.newspaper.displayIcon();
    image(crowd, 0, 0);
    notepad.display();
    if(auction.WIN) drawWinText();
    if(AT_TUNA_MARKET) {
      background(bg6);
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
          tunas[user.SELECTED_TUNA].LOOK_AT = true;
          auction.totalReset();
          GAMESTART = false;
        }
      if(MENU_OPEN) gm.display();
      }
      if(tunas[user.SELECTED_TUNA].LOOK_AT) drawLoseText();
    }
    else if(AT_FISH_MARKET){
      market.drawMarket();
      drawEnter("buy");
    }
    if(MENU_OPEN) gm.display();
  }
  private void LoadingScreen() {
    background(bg1);
    if(!STORE_CLOSE) drawLoading();
    else drawEnter("continue");
  }
  private void ANewDayScreen() {
    //moon going down and sun coming up animation  
    background(10);
    openStore();
    CURRENT_SCREEN = 2;
  }
  //Backspace 8, Enter 13, Spacebar 32, Left 37, Up 38, Right 39, Down 40, 27 Escape
  //Probably could make this simpler...
  void inputKey() {    
    //Any screen
    if(keyCode == 77 || keyCode == 109) {
      if(!MENU_OPEN) MENU_OPEN = true;
      else MENU_OPEN = false; 
    }
    if(CURRENT_SCREEN == 1 && keyCode == 8) {
      CURRENT_SCREEN = 0;
    }
    //Input keys for Boss Screen
    if(CURRENT_SCREEN == 3 && keyCode == 32) {
      if(b.LEAVE) CURRENT_SCREEN = 5;
      
      if(!MORN_TALK) {
        if((INTRO && TEXTSTRING < b.INTRO_NUM) || (!INTRO && TEXTSTRING < b.DAY_NUM)) {
          if(TEXTSTRING == 10) TEXTSTRING = 12;
          else if(TEXTSTRING == 9) {
            int result = b.salesHappy(user.BOUGHT_PRICE);
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
            //earnings of other fish added before reset
            b.comp.makeEarnings(user.OTHER_PRICE);
            int result = b.qualityHappy(b.comp.TUNA_QUALITY);
            if(result == 0) TEXTSTRING++;
            else if(result == 1) TEXTSTRING+=2;
            else TEXTSTRING+=3;
          }
          else TEXTSTRING++;
        }
        else if(TEXTSTRING == b.DIALOGUE_NUM && b.happiness < 40) {
          FIRE = true;
          CURRENT_SCREEN = 6; 
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
          user.buyFish(market.SALMON_QUANT, market.MACKEREL_QUANT, market.SQUID_QUANT, market.TOTAL);
          AT_FISH_MARKET = false;
         }
       }
       else if(!GAMESTART && AT_TUNA_MARKET && SHOW_BUYER && keyCode == 32) {
         if((INTRO && TEXTSTRING < auction.buyer.INTRO_NUM) || (!INTRO && TEXTSTRING < auction.buyer.DAY_NUM)) {
           TEXTSTRING++;
         }
         else SHOW_BUYER = false;
       }
       else if(AT_TUNA_MARKET && !GAMESTART && !SHOW_BUYER && keyCode == 8) {
         AT_TUNA_MARKET = false; 
       }
       else if(GAMESTART && ALLOW_INPUTS) {
         if(keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode == 40) 
           user.userInput.append(keyCode); 
         //User inputs first digit
         else if(keyCode == 32) {
           auction.compareInput(user.userInput, combos, "");
           user.userInput.clear();
           if(auction.WRONG_INPUT) {
             GAMESTART = false;
             tunas[user.SELECTED_TUNA].LOOK_AT = true;
             auction.totalReset();
             checkTunas();
           }
         }
         //User inputs second digit
         else if(keyCode == 10) {
           auction.compareInput(user.userInput, combos, "Last");
           user.userInput.clear();
           ALLOW_INPUTS = false;
           if(auction.WRONG_INPUT) {
             GAMESTART = false;
             tunas[user.SELECTED_TUNA].LOOK_AT = true;
             auction.totalReset();
             checkTunas();
           }
           auction.miniReset();
           auction.buyerBid(tunas[user.SELECTED_TUNA].quality);
           timer.reset();
           if(auction.WIN) {
             //user buys the fish they chose SELECTED_TUNA
             if(auction.YOUR_BID > b.comp.balance) {
               GAMESTART = false;
               tunas[user.SELECTED_TUNA].LOOK_AT = true;
               auction.totalReset();
               auction.WIN = false;
               checkTunas();
             }
             else {
               b.comp.buy(auction.YOUR_BID);
               user.BOUGHT_PRICE = auction.YOUR_BID;
               AT_TUNA_MARKET = GAMESTART = false;
             }
           }
           ALLOW_INPUTS = true;
         }
       }
       else if((auction.WIN || NO_TUNA) && keyCode == 32) {
         TEXTSTRING = b.DAY_NUM + 1;
         b.comp.restock(tunas[user.SELECTED_TUNA]);
         b.otherFishHappy(user.salNum, user.mackNum, user.squidNum);
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
    if(CURRENT_SCREEN == 6 && keyCode == 10) {
       exit();
    }
  }
  //mouseClicked
  void mouseInput() {
    if(MENU_OPEN) {
      if(gm.load.mouseOver())  gm.LOAD = true;
      else if(gm.save.mouseOver())  gm.SAVE = true;
      if(gm.yes.mouseOver() && gm.SAVE) gm.saveGame();
      else if(gm.no.mouseOver() && gm.SAVE) gm.SAVE = false;
      if(gm.yes.mouseOver() && gm.LOAD) gm.loadGame();
      else if(gm.no.mouseOver() && gm.LOAD) gm.LOAD = false;
    }
    if(CURRENT_SCREEN == 0 && !MENU_OPEN) {
      if(start.mouseOver())
        CURRENT_SCREEN = 3;
      else if(info.mouseOver())
        CURRENT_SCREEN = 1;
      else if(exit.mouseOver()) 
        exit();
      timer.reset();
    }
    if(CURRENT_SCREEN == 4 && !MENU_OPEN) {
      if(!AT_TUNA_MARKET) {
        if(auction.mouseOver() && !auction.WIN && !NO_TUNA)
          SHOW_BUYER = AT_TUNA_MARKET = true;
        else if(market.mouseOver() && !AT_FISH_MARKET) {
          AT_FISH_MARKET = true;
        }
        else if(notepad.newspaper.mouseOver() && !notepad.HAVE_NEWSPAPER) {
          notepad.HAVE_NEWSPAPER = true; 
        }
        else if(AT_FISH_MARKET) {
          market.addFish(); 
        }
        else if(notepad.loan.mouseOver() && !b.GOT_LOAN) {
          b.getLoan(); 
        }
      }
      else if(AT_TUNA_MARKET && !SHOW_BUYER) {
        for(int i = 0; i < tunas.length; i++) {
          if(tunas[i].mouseOver()) {
            ALLOW_INPUTS = GAMESTART = true;
            timer.reset();
            user.SELECTED_TUNA = i;
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
      textFont(regular);
      fill(240);
      textAlign(CENTER);
      text(textStrings.get("Bossfire"), width/2, 500);
  }
  private void checkTunas() {
    int a = 0;
    for(Tuna t: tunas) {
      if(t.LOOK_AT) a++; 
      println(a + " " + tunas.length);
    }
    if(a == tunas.length) NO_TUNA = true;
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
  private void gameover() {
     
  }
  private void nextDay() {
    DAY++;
    user.reset();
    if(INTRO) INTRO = false;
    notepad.HAVE_NEWSPAPER = STORE_CLOSE = auction.WIN = RECEIVED_EARNINGS = b.LEAVE = MORN_TALK = false;
    auction.totalReset();
    TEXTSTRING = b.INTRO_NUM + 1;
    CURRENT_SCREEN = 3;
    for(Tuna t : tunas)
      t.reset(0, 0, 0);
    for(Customer c : customers)
      c.reset();
    b.reset();
    market.reset();
  }
}
//-------------------------------------------------------------------------------------------------//