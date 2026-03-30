// Ender Hale | Timer - Stopwatch | p5.js version

let screen = 't';

let timeStart = false;
let paused = false;

// countdown
let inputDigits = "";
let countdownElapsed = 0;
let countdownInitialized = false;
let countdownInput = true;

let lastTime;
let lastCountdownTime;

let stopwatchElapsed = 0;
let stopwatchHour = 0;
let stopwatchMinute = 0;
let stopwatchSecond = 0;
let stopwatchMilisecond = 0;

let countdownMinute = 0;
let countdownSecond = 0;

// alarm
let alarm;
let alarmActive = false;
let snoozePressed = false;
let lastMeowTime = 0;

// buttons
let btnStart, btnReset, btnPause, btnSwitchMode, btnSnooze;

// simple button class
class Button {
  constructor(label, x, y, w, h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  display() {
    rect(this.x, this.y, this.w, this.h);
    textAlign(CENTER, CENTER);
    text(this.label, this.x + this.w / 2, this.y + this.h / 2);
  }

  clicked(mx, my) {
    return mx > this.x && mx < this.x + this.w &&
           my > this.y && my < this.y + this.h;
  }
}

function preload() {
  alarm = loadSound("scream.mp3");
}

function setup() {
  createCanvas(1000, 500);

  btnStart = new Button("Start", 300, 400, 75, 40);
  btnReset = new Button("Reset", 500, 400, 75, 40);
  btnPause = new Button("Pause", 400, 400, 75, 40);
  btnSwitchMode = new Button("Switch", 750, 200, 80, 40);
  btnSnooze = new Button("Snooze", 650, 400, 100, 40);

  lastTime = millis();
  lastCountdownTime = millis();
}

function draw() {
  background(255);

  if (screen === 't') timeScreen();
  if (screen === 's') stopwatchScreen();
  if (screen === 'c') countdownScreen();

  // stopwatch update
  if (timeStart && screen === 's') {
    let current = millis();
    let delta = current - lastTime;

    stopwatchElapsed += delta;
    lastTime = current;

    stopwatchHour = floor(stopwatchElapsed / 3600000);
    let remainder = stopwatchElapsed % 3600000;

    stopwatchMinute = floor(remainder / 60000);
    remainder %= 60000;

    stopwatchSecond = floor(remainder / 1000);
    stopwatchMilisecond = floor((remainder % 1000) / 10);
  }

  // countdown update
  if (timeStart && screen === 'c') {
    let current = millis();
    let delta = current - lastCountdownTime;

    if (delta >= 1000) {
      let secondsPassed = floor(delta / 1000);
      lastCountdownTime = current;

      countdownElapsed -= secondsPassed * 1000;

      if (countdownElapsed <= 0) {
        countdownElapsed = 0;
        timeStart = false;

        alarmActive = true;
        snoozePressed = false;
        lastMeowTime = millis();

        if (alarm.isLoaded()) alarm.play();
      }

      countdownMinute = floor(countdownElapsed / 60000);
      let remainder = countdownElapsed % 60000;
      countdownSecond = floor(remainder / 1000);
    }
  }

  // alarm loop
  if (alarmActive && !snoozePressed) {
    if (millis() - lastMeowTime >= 2000) {
      if (alarm.isLoaded()) alarm.play();
      lastMeowTime = millis();
    }
  }
}

// ---------------- SCREENS ----------------

function timeScreen() {
  textAlign(CENTER);
  textSize(60);

  let h = nf(hour(), 2);
  let m = nf(minute(), 2);
  let s = nf(second(), 2);

  text(h + ":" + m + ":" + s, width / 2, height / 2);

  btnSwitchMode.display();
}

function stopwatchScreen() {
  textAlign(CENTER);
  textSize(60);

  text(
    nf(stopwatchHour, 2) + ":" +
    nf(stopwatchMinute, 2) + ":" +
    nf(stopwatchSecond, 2),
    width / 2,
    height / 2
  );

  btnSwitchMode.display();
  btnStart.display();
  btnReset.display();
  btnPause.display();
}

function countdownScreen() {
  textAlign(CENTER);
  textSize(60);

  let displayText;

  if (countdownInput) {
    displayText = inputDigits;
  } else {
    displayText = nf(countdownMinute, 2) + ":" + nf(countdownSecond, 2);
  }

  text(displayText, width / 2, height / 2);

  btnSwitchMode.display();
  btnStart.display();
  btnPause.display();
  btnReset.display();

  if (alarmActive) {
    btnSnooze.display();
  }
}

// ---------------- INPUT ----------------

function mousePressed() {
  if (btnStart.clicked(mouseX, mouseY)) {
    timeStart = true;
    paused = false;

    if (screen === 'c') {
      if (!countdownInitialized) {
        let value = int(inputDigits || 0);

        let minutes = floor(value / 100);
        let seconds = value % 100;

        countdownElapsed = (minutes * 60000) + (seconds * 1000);
        countdownInitialized = true;
      }

      lastCountdownTime = millis();
      countdownInput = false;

      alarmActive = false;
      snoozePressed = false;
    } else {
      lastTime = millis();
    }
  }

  else if (btnReset.clicked(mouseX, mouseY)) {
    timeStart = false;

    stopwatchElapsed = 0;

    countdownElapsed = 0;
    inputDigits = "";
    countdownInitialized = false;
    countdownInput = true;

    alarmActive = false;
    snoozePressed = false;
  }

  else if (btnPause.clicked(mouseX, mouseY)) {
    timeStart = false;
    paused = true;
  }

  else if (btnSwitchMode.clicked(mouseX, mouseY)) {
    if (screen === 't') screen = 's';
    else if (screen === 's') screen = 'c';
    else screen = 't';
  }

  else if (btnSnooze.clicked(mouseX, mouseY)) {
    snoozePressed = true;
    alarmActive = false;
  }
}
