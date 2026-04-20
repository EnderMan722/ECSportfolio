let mouseGame = new p5((p) => {

  let pos, target, catPos;
  let cheese, mouseImg, cat;
  let explosionGif;

  let touching = false;
  let flyingCat = false;
  let exploded = false;
  let waitingForMeow = false;
  let gameOver = false;

  let chomp, meow, explosion;

  let explosionStartTime = 0;
  let explosionDuration = 2000;

  // ===== PRELOAD =====
  p.preload = function () {
    cheese = p.loadImage("cheese.png");
    mouseImg = p.loadImage("mouse.png");
    cat = p.loadImage("cat.png");
    explosionGif = p.loadImage("explosion.gif");

    chomp = p.loadSound("chomp.wav");
    meow = p.loadSound("meow.mp3");
    explosion = p.loadSound("explosion.mp3");
  };

  // ===== SETUP =====
  p.setup = function () {
    p.createCanvas(750, 750);

    pos = p.createVector(p.width / 2, p.height / 2);
    catPos = p.createVector(p.width + 200, p.height / 2);

    cheese.resize(75, 75);
    mouseImg.resize(80, 80);
    cat.resize(300, 300);

    p.imageMode(p.CENTER);
    p.textAlign(p.CENTER, p.CENTER);
  };

  // ===== DRAW =====
  p.draw = function () {

    if (gameOver) {
      p.background(0);
      p.fill(255);
      p.textSize(50);
      p.text("GAME OVER", p.width / 2, p.height / 2);
      p.textSize(20);
      p.text("Press R to restart", p.width / 2, p.height / 2 + 50);
      return;
    }

    p.background(220);

    if (waitingForMeow && !meow.isPlaying()) {
      flyingCat = true;
      waitingForMeow = false;
    }

    target = p.createVector(p.mouseX, p.mouseY);
    let direction = p5.Vector.sub(target, pos);
    direction.mult(0.05);
    pos.add(direction);

    let angle = direction.heading();

    p.image(cheese, p.mouseX, p.mouseY);

    p.push();
    p.translate(pos.x, pos.y);
    p.rotate(angle - p.radians(130));
    p.image(mouseImg, 0, 0);
    p.pop();

    let d = p5.Vector.dist(pos, target);
    if (d <= 30 && !touching) {
      if (!chomp.isPlaying()) chomp.play();
      touching = true;
    }
    if (d > 30) touching = false;

    if (flyingCat) {
      let catDirection = p5.Vector.sub(target, catPos);
      catDirection.mult(0.1);
      catPos.add(catDirection);

      p.image(cat, catPos.x, catPos.y);

      let catDist = p5.Vector.dist(catPos, target);
      if (catDist < 120 && !exploded) {
        if (!explosion.isPlaying()) explosion.play();

        exploded = true;
        flyingCat = false;
        explosionStartTime = p.millis();
      }
    }

    if (exploded) {
      p.image(explosionGif, p.width / 2, p.height / 2, p.width, p.height);

      if (p.millis() - explosionStartTime > explosionDuration) {
        gameOver = true;
      }
    }
  };

  // ===== KEY PRESS =====
  p.keyPressed = function () {
    if (p.key === 'm' && !gameOver) {
      meow.play();

      catPos = p.createVector(p.width + 200, p.random(p.height));
      flyingCat = false;
      exploded = false;

      waitingForMeow = true;
    }

    if (p.key === 'r') {
      resetGame();
    }
  };

  function resetGame() {
    pos = p.createVector(p.width / 2, p.height / 2);
    catPos = p.createVector(p.width + 200, p.height / 2);

    touching = false;
    flyingCat = false;
    exploded = false;
    waitingForMeow = false;
    gameOver = false;
  }

  // audio unlock
  p.mousePressed = function () {
    p.userStartAudio();
  };

});
