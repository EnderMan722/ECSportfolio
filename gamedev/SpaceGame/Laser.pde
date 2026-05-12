class Laser {
  // Member Variables
  float x, y;
  int w, h, speed;
  PImage laser;

  // Constructor
  Laser(float x, float y) {
    this.x = x;
    this.y = y;
    w = 70;
    h = 70;
    speed = 10;
    laser = loadImage("laser.png");
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    image(laser, x, y - 40, w, h);
  }

  void move() {
    y = y - speed;
  }

  boolean reachedTop() {
    return y < -30;
  }

  boolean intersect(Rock r) {
    float d1 = dist(x, y, r.x, r.y);
    return d1 < 50;
  }

  boolean intersect(Boss b) {
    float d2 = dist(x, y, b.x, b.y);
    return d2 < 200;
  }
}
