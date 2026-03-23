let pos, target, catPos;
let cheese, mouseImg, cat;
let explosionGif;

let touching = false;
let flyingCat = false;
let exploded = false;
let waitingForMeow = false;
let gameOver = false;

let chomp, meow, explosion;

// explosion timing
let explosionStartTime = 0;
let explosionDuration = 2000; // adjust to match your gif

function preload() {
  cheese = loadImage("cheese.png");
  mouseImg = loadImage("mouse.png");
  cat = loadImage("cat.png");
  explosionGif = loadImage("explosion.gif");

  chomp = loadSound("chomp.wav");
  meow = loadSound("meow.mp3");
  explosion = loadSound("explosion.mp3");
}

function setup() {
  createCanvas(750, 750);

  pos = createVector(width/2, height/2);
  catPos = createVector(width + 200, height/2);

  cheese.resize(75, 75);
  mouseImg.resize(80, 80);
  cat.resize(300, 300);

  imageMode(CENTER);
  textAlign(CENTER, CENTER);
}

function draw() {
  // ===== GAME OVER SCREEN =====
  if (gameOver) {
    background(0);
    fill(255);
    textSize(50);
    text("GAME OVER", width/2, height/2);
    textSize(20);
    text("Press R to restart", width/2, height/2 + 50);
    return;
  }

  background(220);

  // ===== WAIT FOR MEOW =====
  if (waitingForMeow && !meow.isPlaying()) {
    flyingCat = true;
    waitingForMeow = false;
  }

  // ===== MOUSE FOLLOW =====
  target = createVector(mouseX, mouseY);
  let direction = p5.Vector.sub(target, pos);
  direction.mult(0.05);
  pos.add(direction);

  let angle = direction.heading();

  image(cheese, mouseX, mouseY);

  push();
  translate(pos.x, pos.y);
  rotate(angle - radians(130));
  image(mouseImg, 0, 0);
  pop();

  let d = p5.Vector.dist(pos, target);
  if (d <= 30 && !touching) {
    if (!chomp.isPlaying()) chomp.play();
    touching = true;
  }
  if (d > 30) touching = false;

  // ===== CAT MOVEMENT =====
  if (flyingCat) {
    let catDirection = p5.Vector.sub(target, catPos);
    catDirection.mult(0.1);
    catPos.add(catDirection);

    image(cat, catPos.x, catPos.y);

    let catDist = p5.Vector.dist(catPos, target);
    if (catDist < 120 && !exploded) {
      if (!explosion.isPlaying()) explosion.play();

      exploded = true;
      flyingCat = false;
      explosionStartTime = millis(); // start timer
    }
  }

  // ===== EXPLOSION =====
  if (exploded) {
    image(explosionGif, width/2, height/2, width, height);

    if (millis() - explosionStartTime > explosionDuration) {
      gameOver = true;
    }
  }
}

// ===== KEY PRESS =====
function keyPressed() {
  if (key === 'm' && !gameOver) {
    meow.play();

    catPos = createVector(width + 200, random(height));
    flyingCat = false;
    exploded = false;

    waitingForMeow = true;
  }

  // restart
  if (key === 'r') {
    resetGame();
  }
}

// ===== RESET FUNCTION =====
function resetGame() {
  pos = createVector(width/2, height/2);
  catPos = createVector(width + 200, height/2);

  touching = false;
  flyingCat = false;
  exploded = false;
  waitingForMeow = false;
  gameOver = false;
}

// ===== REQUIRED FOR SOUND =====
function mousePressed() {
  userStartAudio();
}
