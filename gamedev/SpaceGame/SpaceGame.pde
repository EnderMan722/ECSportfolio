// Ender Hale | September 23 2025 | SpaceGame
SpaceShip s1;

import processing.sound.*;

ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
ArrayList<Boss> bosses = new ArrayList<Boss>();
ArrayList<BossLaser> bLasers = new ArrayList<BossLaser>();

Timer rockTimer;
Timer puTimer;
Timer levelTimer;
Timer bossShoot;

int score, rocksPassed, level, levelTime, rTime, bTime;
float accuracy, firedLasers, rockCollision;
boolean gameOver, start;

boolean bossLevel, bossSpawned;

PImage startScreen, explosion;

SoundFile boom;
SoundFile shoot;
SoundFile gling;


// ======================== SETUP ========================
void setup() {
  fullScreen();
  background(22);
  frameRate(80);

  s1 = new SpaceShip();

  score = 0;
  rocksPassed = 0;
  level = 1;
  bossLevel = false;
  firedLasers = 0.0;
  rockCollision = 0.0;
  accuracy = 0.0;

  // Timers
  levelTime = 15000;
  rTime = 800;
  bTime = 500;
  rockTimer = new Timer(rTime);
  rockTimer.start();
  puTimer = new Timer(2500);
  puTimer.start();
  levelTimer = new Timer(levelTime);
  levelTimer.start();
  bossShoot = new Timer(bTime);


  // Game State
  gameOver = false;
  start = false;
  startScreen = loadImage("StartScreen.png");

  // Sound and Images
  explosion = loadImage("boom.png");
  boom = new SoundFile(this, "BoomSound.wav");
  shoot = new SoundFile(this, "shoot.wav");
  gling = new SoundFile(this, "powerup.wav");
}


// ======================== DRAW ========================
void draw() {

  // Game State
  if (!start) {
    startScreen();
  } else {
    background(0);

    // Set accuracy
    if (firedLasers > 0) {
      accuracy = (rockCollision/firedLasers) * 100;
    } else {
      accuracy = 0;
    }

    println(accuracy);

    //Check For Spawning bosses
    if ((level == 5 || level == 10 || level == 15 || level == 20)&& !bossSpawned) {
      //Spawning
      bossLevel = true;
      bosses.clear();
      rocks.clear();
      powups.clear();
      bosses.add(new Boss());
      bossSpawned = true;
      levelTimer.stop();
    }




    // Distributes a powerup on a timer
    if (!bossLevel && puTimer.isFinished()) {
      powups.add(new PowerUp());
      puTimer.start();
    }

    // Display and move all powerups
    for (int i = 0; i < powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.display();
      pu.move();

      // Check for intersecting spaceship
      if (pu.intersect(s1)) {
        powups.remove(pu);
        gling.play();
        if (pu.type == 'H') {
          s1.health += int(random(100, 200));
        } else if (pu.type == 'T') {
          s1.turretCount++;
        } else if (pu.type == 'A') {
          s1.laserCount += int(random(100, 300));
        }
        i--;
      }

      // Reached bottom check
      if (pu.reachedBottom()) {
        powups.remove(pu);
        i--;
      }
    }

    // Add Stars
    stars.add(new Star());

    // Distribute rocks on a timer
    if (!bossLevel && rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    // Display Stars
    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      // Reached bottom check
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
    }

    // Display and move Rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);

      // Intersecting spaceship check
      if (s1.intersect(rock)) {
        s1.health -= rock.w;
        if (s1.health < 1) gameOver = true;
        rocks.remove(rock);
        score += rock.w;
        i--;
        continue;
      }

      // Display and move rocks
      rock.display();
      rock.move();
      // Reached bottom check
      if (rock.reachedBottom()) {
        rocks.remove(rock);
        rocksPassed++;
        i--;
      }
    }

    // Display Boss
    for (int i = 0; i < bosses.size(); i++) {
      Boss boss = bosses.get(i);
      boss.display();
      boss.move();
      bossShoot.start();
      if (bossShoot.isFinished()) {

        bossShoot.start();
      }

      if (s1.intersect(boss)) {
        s1.health -= 0.01;
        fill(255, 0, 0);
        text("MOVE!", width/2, height/2);
        i--;
      }


      if (boss.reachedBottom()) {
        bosses.remove(boss);
        gameOver = true;
        bossLevel = false;
        i--;
      }
    }

    // Boss Lasers
    for (int i = bLasers.size()-1; i >= 0; i--) {
      BossLaser bl = bLasers.get(i);
      bl.move();
      bl.display();

      if (bl.reachedEdge()) {
        bLasers.remove(i);
      }

      if (bl.intersect(s1)) {
        s1.health -= 35;
        if (s1.health < 1) gameOver = true;
        bLasers.remove(i);
        i--;
        continue;
      }
    }


    // Distribute boss lasers on timer
    if (frameCount % 60 == 0) {  // shoots once per second
      for (Boss b : bosses) {
        b.shoot();
      }
    }







    // Display and remove lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      laser.display();
      laser.move();

      // Rock Collision
      for (int j = 0; j < rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {
          //Change accuracy
          rockCollision++;
          //Make Rock Smaller
          r.w -= 30;
          //Check if rock is removed
          if (r.w < 5) {
            //Remove rocks and add score and lasers
            rocks.remove(j);
            j--;
            score += 50;
            s1.laserCount += 5;
          }
          lasers.remove(i);
          i--;
          break;
        }
      }

      // Boss Collision
      for (int j = 0; j < bosses.size(); j++) {
        Boss b = bosses.get(j);
        if (laser.intersect(b)) {
          //Change accuracy
          rockCollision++;
          //Subtract Boss Health
          b.health -= 3;
          // Remove Lasers
          lasers.remove(i);
          i--;
          //Check When Boss Is Dead
          if (b.health <= 0) {
            bosses.remove(j);
            j--;
            score += 10000;
            level++;
            levelTimer.start();
            s1.turretCount -= 3;
            bossSpawned = false;
            if (s1.turretCount<1) s1.turretCount = 1;
          }
          break;
        }
      }

      if (i >= 0 && laser.reachedTop()) {
        lasers.remove(i);
        i--;
      }
    }

    // Player display and movement
    s1.display();
    s1.move(mouseX, mouseY);


    infoPanel();




    // Game over check
    if (gameOver || rocksPassed > 10) {
      gameOver();
    }




    if (bossLevel==true) {
      fill(225, 0, 0);
      text("BOSS LEVEL! SPAM CLICK!", width-175, height-height+60);
    }


    if (bosses.isEmpty()) {
      bossLevel = false;
    }




    // Level timer
    if (levelTimer.isFinished()) {
      level++;
      rTime = max(200, rTime - 100);
      levelTimer.start();
      rocks.clear();
      lasers.clear();
      powups.clear();
      rocksPassed = 0;
      rockTimer.start();
      puTimer.start();
    }
  }
}



// ======================== MOUSE PRESSED ========================
void mousePressed() {
  if (!start || gameOver) return;

  if (!s1.fire()) return;

  s1.laserCount -= s1.turretCount;
  firedLasers += s1.turretCount;
  shoot.play();

  float spacing = 50;
  float startX = s1.x - ((s1.turretCount - 1) * spacing) /2;

  for (int i = 0; i < s1.turretCount; i++) {
    lasers.add(new Laser(startX + i * spacing, s1.y - 40));
  }
}


// ======================== INFO PANEL ========================
void infoPanel() {
  rectMode(CENTER);
  fill(127, 127);
  rect(width / 2, height-30, width, 50);
  fill(220);
  pushStyle();
  textSize(25);
  text("Score: " + score, 60, height - 35);
  text("Rocks Passed: " + rocksPassed, width - 175, height - 35);
  text("Health: " + s1.health, (width / 2)/2, height-35);
  text("Ammo: " + s1.laserCount, width / 2, height-35);
  text("Turrets: " + s1.turretCount, (width / 2)+((width/2)/2), height-35);
  fill(225);
  textAlign(LEFT);
  text("Level: " + level, 60, 80);
  text("Accuracy: " + accuracy + "%", 60, 150);
  popStyle();
  rectMode(CORNER);
  fill(255);
  rect(s1.x - 50, s1.y + 50, 100, 12);
  fill(255, 0, 0);
  rect(s1.x - 45, s1.y + 52, s1.health / 5.5, 7);
}



// ======================== GAME OVER ========================
void gameOver() {
  background(0);
  boom.play();
  image(explosion, s1.x, s1.y);
  fill(255);
  textSize(50);
  text("Game Over", width / 2, height / 2 - 20);
  textSize(30);
  text("You Received A Score Of: ", width / 2, height / 2 + 50);
  text(score, width / 2 + 190, height / 2 + 50);
  text("Shots Hit: " + rockCollision + "/" + firedLasers, width / 2, height / 2 + 150);
  noLoop();
}



// ======================== START SCREEN ========================
void startScreen() {
  imageMode(CENTER);
  startScreen.resize(1920, 1080);
  image(startScreen, width / 2, height / 2);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("Space Game", width / 2, height / 2 - 40);
  textSize(20);
  text("Click Mouse To Start", width / 2, height / 2 + 20);
  if (mousePressed) start = true;
}
