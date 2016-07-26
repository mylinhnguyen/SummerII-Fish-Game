//Auction, Market, Tuna, Notes
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
    text("Tsukiji Fish", 140, 190);
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
//quality > quantity
class Tuna{
  Float quality;
  int weight, fat;
  boolean LOOK_AT, KING;
  PVector loc;
  String locCaught;
  PShape tuna, crown;
  Tuna(PVector l, String lc) {
    fat = round(random(3,20));
    weight = abs(int(randomGaussian() * 150 + fat * 5));
    quality = abs(randomGaussian() * 2) + fat/20;
    LOOK_AT = false;
    loc = l;
    locCaught = lc;
    Float i = random(0,1);
    if(i < 0.05) KING = true;
    else KING = false;
    tuna = createShape();
    crown = createShape();
    makeShape();
  }
  void makeShape() {
    tuna.beginShape();
      tuna.fill(70,140,200);
      tuna.stroke(70,140,200);
      tuna.strokeWeight(4);
      tuna.vertex(loc.x,loc.y);
      tuna.vertex(loc.x+42,loc.y-25);
      tuna.vertex(loc.x+62,loc.y-26);  
      tuna.vertex(loc.x+67,loc.y-42);
      tuna.vertex(loc.x+92,loc.y-30); 
      tuna.vertex(loc.x+94,loc.y-22);   
      tuna.vertex(loc.x+102,loc.y-20);
      tuna.vertex(loc.x+127,loc.y);
      tuna.vertex(loc.x+152,loc.y-25);
      tuna.vertex(loc.x+142,loc.y);
      tuna.vertex(loc.x+152,loc.y+25);
      tuna.vertex(loc.x+127,loc.y);     
      tuna.vertex(loc.x+102,loc.y+20);
      tuna.vertex(loc.x+62,loc.y+24);
      tuna.vertex(loc.x+42,loc.y+24);
      tuna.vertex(loc.x+2,loc.y+5);
    tuna.endShape(CLOSE);
    crown.beginShape();
    crown.stroke(170,170,0);
      crown.fill(200,200,0);
      crown.vertex(loc.x+35, loc.y-33);
      crown.vertex(loc.x+37, loc.y-48);
      crown.vertex(loc.x+43, loc.y-42);
      crown.vertex(loc.x+46, loc.y-50);
      crown.vertex(loc.x+50, loc.y-43);
      crown.vertex(loc.x+56, loc.y-51);
      crown.vertex(loc.x+58, loc.y-33);
    crown.endShape(CLOSE);
  }
  void draw() {
    noStroke();
    if(!LOOK_AT) {
      shape(tuna, 0, 0);
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
    if(mouseX >= loc.x && mouseX <= loc.x + 150 
    && mouseY >= loc.y-20 && mouseY <= loc.y + 20) 
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
class Notes{
  Newspaper newspaper;
  PImage note;
  PVector loc;
  boolean HAVE_NEWSPAPER, OPEN_UP, SALMON_GOOD, MACK_GOOD, SQUID_GOOD;
  int sal, mac, squ;
  String newsLoc;
  Notes() {
    //800,600
    newspaper = new Newspaper();
    note = loadImage("notepad.jpg");
    loc = new PVector(width/2, height/2);
    HAVE_NEWSPAPER = OPEN_UP = false;
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
      text(newspaper.news.get("Tuna1") + newsLoc, 250, 250, 300, 300);
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
class Newspaper{
  StringDict news;
  PVector size, loc;
  Newspaper() {
    news = new StringDict();
    fillNews();
    size = new PVector(100, 15);
    loc = new PVector(600, 570);
  }
  //void readIn: read in strings from text file
  void fillNews() {
    news.set("Tuna1", "Tuna noticed to have more weight.");
    news.set("Tuna2", "Tuna have slightly higher quality due to better feeding grounds.");
    news.set("Tuna3", "Tuna looking underweight.");
    news.set("Tuna4", "Huge King tuna caught.");
    news.set("Tuna5", "Tuna quality lowers.");
    news.set("Salmon1", "Few salmon caught; price rises.");
    news.set("Salmon2", "Abundance of salmon; price lowers.");
    news.set("Mackerel1", "Few mackerel caught; price rises.");
    news.set("Mackerel2", "Abundance of salmon; price lowers.");
    news.set("Squid1", "Few squid caught; price rises"); 
    news.set("Squid2", "Abundance of squid; price lowers.");
    news.set("Customer1", "A new circus opens in town. Increase in tourist.");
    news.set("Customer2", "A new sushi restaurant opened down the street. Customers want higher quality.");
  }
  void displayIcon() {
    if(mouseOver())
      fill(240);
    else fill(180);
    stroke(10);
    strokeWeight(2);
    rectMode(CORNER);
    rect(loc.x, loc.y, size.x, size.y, 5);
    rect(loc.x, loc.y-10, size.x, size.y, 5);
    rect(loc.x, loc.y-20, size.x, size.y, 5);
    rect(loc.x, loc.y-30, size.x, size.y, 5);
    rect(loc.x, loc.y-40, size.x, size.y, 5);
    line(loc.x + 5, loc.y-36, loc.x+size.x-5, loc.y-35);
    line(loc.x + 5, loc.y-33, loc.x+size.x/3, loc.y-32);
  }
  boolean mouseOver() {
    if((mouseX > loc.x && mouseX < loc.x + size.x) && (mouseY > loc.y- (size.y*5) && mouseY < loc.y))
      return true;
    return false;
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