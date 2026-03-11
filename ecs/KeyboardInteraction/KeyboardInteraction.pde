// Ender Hale | 2025 | ShapeGame


// Global Variables
import processing.sound.*;
int x, y, w, h, score, tx, ty;
float speed = 5;
float scale;
float tw;
float d;
boolean start = false;
boolean showSloth1 = true;
boolean showMushroom1 = true;
boolean farenough = false;
PImage sloth1, mushroom1, startScreen, background1;
SoundFile chomp;
SoundFile womp;

//Hitbox variables
int slothLeft, slothRight, slothTop, slothBottom;
float targetLeft, targetRight, targetTop, targetBottom;

// Key tracking
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;





// Runs once when the app starts
void setup() {
  size(500, 500);
  background(50, 50, 100);
  frameRate(60);

  //Setting Variablessdsad
  x = 20;
  y = 20;
  score = 0;
  w = 60;
  h = 60;
  tx = int(random(width));
  ty = int(random(height));
  tw = 50;
  scale = 0.03;
  background1 = loadImage("background.png");
  sloth1 = loadImage("sloth.png");
  mushroom1 = loadImage("mushroom.png");
  chomp = new SoundFile(this, "chomp.wav");
  womp = new SoundFile(this, "womp.wav");
}





// Runs on a 30 fps loop
void draw() {
  d = dist(x, y, tx, ty);
  if (start == false) {
    startScreen();
  } else {


    background(background1);
    updateScore();
    target();


    if (showSloth1 == true) {
      imageMode(CENTER);
      sloth1.resize(w, h);
      image(sloth1, x, y);
    }

    if (showMushroom1 == true) {
      imageMode(CENTER);
      image(mushroom1, tx, ty, tw, tw);
    }




    //Draw Circle
    //ellipse(x, y, w, h);

    //Circle hitbox
    slothLeft   = x - w/2;
    slothRight  = x + w/2;
    slothTop    = y - h/2;
    slothBottom = y + h/2;

    //Square Hitbox
    targetLeft   = tx - tw/2;
    targetRight  = tx + tw/2;
    targetTop    = ty - tw/2;
    targetBottom = ty + tw/2;





    //Movement
    if (upPressed) {
      y-=speed;
    }
    if (leftPressed) {
      x-=speed;
    }
    if (downPressed) {
      y+=speed;
    }
    if (rightPressed) {
      x+=speed;
    }

    //Collision Detection
    if (slothRight  >= targetLeft &&
      slothLeft   <= targetRight &&
      slothBottom >= targetTop &&
      slothTop    <= targetBottom) {
      score += 1;
      scale = 0.03 + score * 0.005;
      tw = 50;


      tx = int(random(width-tw));
      ty = int(random(height-tw));
      

      if (chomp.isPlaying()) {
        chomp.stop();
        chomp.play();
      } else {
        chomp.play();
      }
    }




    if (x>width+w/2) {
      x = 0 - w/2;
    }

    if (x<0-w/2) {
      x = width + w/2;
    }


    if (y>height+w/2) {
      y = 0 - w/2;
    }

    if (y<0-w/2) {
      y = width + w/2;
    }
  }
}



//Check If Key Is Being Pressed For Movement
void keyPressed() {
  if (key == 'w' || key == 'W') {
    upPressed = true;
  }
  if (key == 'a' || key == 'A') {
    leftPressed = true;
  }
  if (key == 's' || key == 'S') {
    downPressed = true;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = true;
  }
  if (keyCode == UP) {
    upPressed = true;
  }
  if (keyCode == DOWN) {
    downPressed = true;
  }
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }
}


//Check If Key Is Being Released
void keyReleased() {
  if (key == 'w' || key == 'W') {
    upPressed = false;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = false;
  }
  if (key == 's' || key == 'S') {
    downPressed = false;
  }
  if (key == 'a' || key == 'A') {
    leftPressed = false;
  }
  if (keyCode == UP) {
    upPressed = false;
  }
  if (keyCode == DOWN) {
    downPressed = false;
  }
  if (keyCode == LEFT) {
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
}





void updateScore() {
  textAlign(CENTER);
  fill(127, 127);
  rect(0, 0, width, 30);
  fill(255);
  textSize(30);
  text("Score: " + score, width/2, 25);
}





void target() {

  println(d);
  //shrink mushroom
  tw -= scale;
  if (tw < 1) {
    gameOver();
  }
}




void gameOver() {
  background(0);
  fill(255);
  textSize(50);
  text("Game Over", width/2, height/2-20);
  showSloth1 = false;
  showMushroom1 = false;
  womp.play();
  textSize(30);
  text("You Recieved A Score Of:", width/2, height/2+50);
  text(score, width/2+175, height/2+50);
  noLoop();
}





void startScreen() {
  background(260, 100, 180);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Keyboard Interaction Game", width/2, height/2-40);
  textSize(20);
  text("Press Spacebar To Start", width/2, height/2+20);
  if (keyCode == ' ') {
    start = true;
  }
}
