// Ender Hale | Follow the Mouse | Mar 18 2026

PVector pos, target;
PImage cheese, mouseImg;

void setup() {
  size(750, 750);
  pos = new PVector(width/2, height/2);
  cheese = loadImage("cheese.png");
  cheese.resize(75, 75);
  mouseImg = loadImage("mouse.png");
  mouseImg.resize(80, 80);
}

void draw() {
  background(220);

  // PVectors for direction and target
  target = new PVector(mouseX, mouseY);
  PVector direction = PVector.sub(target, pos);
  direction.mult(0.05);
  pos.add(direction);
  
  // Rotation code
  float angle = direction.heading();

  // Spawn Image
  imageMode(CENTER);
  image(cheese, mouseX, mouseY);
  pushMatrix();
  translate(pos.x, pos.y);
  rotate(angle - radians(130));
  image(mouseImg, 0, 0);
  popMatrix();
}
