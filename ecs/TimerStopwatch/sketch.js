// Ender Hale | Timer - Stopwatch | p5.js version (fixed)

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

// ---------------- BUTTON CLASS ----------------
class Button {
  constructor(label, x, y, w, h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  display() {
    if (this.isMouseOver()) {
      fill(190);
    } else {
      fill(220);
    }

    stroke(0);
    rect(this.x, this.y, this.w, this.h);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(this.label, this.x + this.w / 2, this.y + this.h / 2);
  }

  clicked(mx, my) {
    return (
      mx > this.x &&
      mx < this.x + this.w &&
      my > this.y &&
      my < this.y + this.h
    );
  }

  isMouseOver() {
    return (
      mouseX > this.x &&
      mouseX < this.x + this.w &&
      mouseY > this.y &&
      mouseY < this.y + this.h
    );
  }
}

// ---------------- PRELOAD ----------------
function preload() {
  alarm = loadSound("scream.mp3");
}

// ---------------- SETUP ----------------
function setup() {
  createCanvas(1000, 500);
  rectMode(CORNER);

  btnStart = new Button("Start", 300, 400, 80, 40);
  btnReset = new Button("Reset", 500, 400, 80, 40);
  btnPause = new Button("Pause", 400, 400, 80, 40);
  btnSwitchMode = new Button("Switch", 750, 200, 100, 40);
  btnSnooze = new Button("Snooze", 650, 400, 100, 40);

  lastTime = millis();
  lastCountdownTime = millis();
}

// ---------------- DRAW ----------------
function draw() {
  background(255);

  if (screen === 't') timeScreen();
  if (screen === 's') stopwatchScreen();
  if (screen === 'c') countdownScreen();

  updateStopwatch();
  updateCountdown();
  handleAlarm();
}

// ---------------- UPDATES ----------------

function updateStopwatch() {
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
}

function updateCountdown() {
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
}

function handleAlarm() {
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
    stopwatchHour = 0;
    stopwatchMinute = 0;
    stopwatchSecond = 0;
    stopwatchMilisecond = 0;

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
