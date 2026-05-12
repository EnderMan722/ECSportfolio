class BossLaser {
  // Member Variables
  int x, y, w, h, speed;
  float targetAngle;
  PImage bossLaser;

  // Constructor
  BossLaser(int x, int y, SpaceShip s1) {
    this.x = x;
    this.y = y;
    w = 70;
    h = 70;
    speed = 10;
    bossLaser = loadImage("bossLaser.png");
    
    // Find player x and y
    float targetX = s1.x;
    float targetY = s1.y;
    targetAngle = atan2(targetY - y, targetX - x);
  }

  // Member Methods
  void display() {
    pushMatrix();
    translate(x, y-40);
    rotate(targetAngle+HALF_PI);
    imageMode(CENTER);
    image(bossLaser, 0, 0, w, h);
    popMatrix();
  }

  void move() {
    x += cos(targetAngle) * speed;
    y += sin(targetAngle) * speed;
  }

  boolean reachedEdge() {
    if (y<-30) {
      return true;
    } else {
      return false;
    }
  }


  boolean intersect(SpaceShip s1) {
    float d2 = dist(x, y, s1.x, s1.y);
    if (d2<s1.w/2) {
      return true;
    } else {
      return false;
    }
  }
}
