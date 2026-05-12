class PowerUp {
  // Member Variables
  int x, y, w, speed;
  char type;
  color c1;
  //PImage c1;

  // Constructor
  PowerUp() {
    x = int(random(width));
    y = -100;
    w = 50;
    speed = int(random(2, 4));

    //Choosing which graphic
    if (random(10)>6.6) {
      //p1 = loadImage("rock01.png");
      type = 'H';
      c1 = color(255, 20, 20);
    } else if (random(10)>5.0) {
      //p1 = loadImage("amongus.png");
      type = 'T';
      c1 = color(100);
    } else {
      //p1 = loadImage("spaceShip.gif");
      type = 'A';
      c1 = color(20, 22, 222);
    }
  }

  // Member Methods
  void display() {
    fill(c1);
    ellipse(x, y, w, w);
    fill(255);
    textSize(33);
    pushStyle();
    textAlign(CENTER);
    text(type, x, y+10);
    popStyle();
  }

  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+w) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean intersect(SpaceShip s) {
    float d = dist(x, y, s.x, s.y);
    if(d<50) {
      return true;
    } else {
      return false;
    }
  }
}
