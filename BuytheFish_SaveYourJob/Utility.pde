//Button, SmallButton, Timer
//-------------------------------------------------------------------------------------------------//
class GameMenu{
  Button load, save;
  Boolean LOAD, SAVE;
  Button[] buttons = new Button[2];
  GameMenu() {
    load = new Button("Load", new PVector(530, 300), 46, 95, 230);
    save = new Button("Save", new PVector(530, 400), 250, 180, 0);
    buttons[0] = load;
    buttons[1] = save;
    LOAD = SAVE = false;
  }
  void display() {
    noStroke();
    rectMode(CORNER);
    fill(10,150);
    rect(0, 0, width, height);
    if(!LOAD && !SAVE) {
      fill(10);
      rect(450, 225, 300, 250);
      for(Button b : buttons)
        b.draw();
    }
    else if(LOAD && !SAVE) {
      //load game
    }
    else if(!LOAD && SAVE) {
      //save game
    }
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
    if(mouseOver())
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
    if(mouseOver())
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
    if(mouseX >= location.x-size/2 && mouseX <= location.x + size/2 
    && mouseY >= location.y-size/2 && mouseY <= location.y + size/2) 
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