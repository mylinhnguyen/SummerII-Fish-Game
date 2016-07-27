//People, Buyer, Boss, Customer
//-------------------------------------------------------------------------------------------------//
class User{
  IntList userInput;
  int SELECTED_TUNA, BOUGHT_PRICE, OTHER_PRICE, salNum, mackNum, squidNum;
  User() {
    userInput = new IntList(); 
    SELECTED_TUNA = BOUGHT_PRICE = OTHER_PRICE = salNum = mackNum = squidNum = 0;
  }
  void buyFish(int s, int m, int sq, int t) {
    salNum = s;
    mackNum = m;
    squidNum = sq;
    OTHER_PRICE = t;
  }
  void reset() {
    SELECTED_TUNA = BOUGHT_PRICE = OTHER_PRICE = salNum = mackNum = squidNum = 0; 
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
  Boss() {
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
    comp = new Company();
    fixTransparency();
    reqSal = int(random(0,4));
    reqMack = int(random(0,4));
    reqSquid = int(random(0,4));
  }
  void displayHappy() {
    stroke(10);
    if(happiness >= 85.0) {
      fill(0,250,0);
      ellipse(1120, 50, 50, 50);
      fill(10);
      ellipse(1110, 42, 5, 5);
      ellipse(1130, 42, 5, 5);
      noFill();
      curve(1105, 20 ,1110, 57, 1130, 57, 1135, 20);
    }
    else if(happiness < 85.0 && happiness >=70) {
      fill(250,250,0);
      ellipse(1120, 50, 50, 50);
      fill(10);
      ellipse(1110, 42, 5, 5);
      ellipse(1130, 42, 5, 5);
      line(1105, 55, 1135, 55);
    }
    else if(happiness < 70 && happiness >= 50) {
      fill(255,200,0);
      ellipse(1120, 50, 50, 50);
      fill(10);
      ellipse(1110, 42, 5, 5);
      ellipse(1130, 42, 5, 5);
      noFill();
      curve(1105, 90 ,1110, 60, 1130, 60, 1135, 90);
    }
    else {
      fill(250,0,0);
      ellipse(1120, 50, 50, 50);
      fill(10);
      ellipse(1110, 42, 5, 5);
      ellipse(1130, 42, 5, 5);
      line(1112, 35, 1103, 30);
      line(1128, 35, 1137, 30);
      noFill();
      curve(1105, 90 ,1110, 60, 1130, 60, 1135, 90);
    }
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