let timerSketch = new p5((p) => {

  let screen = 't';

  let timeStart = false;
  let paused = false;

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

  let alarm;
  let alarmActive = false;
  let snoozePressed = false;
  let lastMeowTime = 0;

  let btnStart, btnReset, btnPause, btnSwitchMode, btnSnooze;

  // ---------------- BUTTON CLASS ----------------
  class Button {
    constructor(label, x, y, w, h) {
      this.label = label;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.buttonColor = 220;
    }

    display() {
      if (this.isMouseOver()) {
        this.buttonColor = 190;
      } else {
        this.buttonColor = 220;
      }

      p.fill(this.buttonColor);
      p.stroke(0);

      p.rect(this.x, this.y, this.w, this.h);

      p.fill(0);
      p.textAlign(p.CENTER, p.CENTER);
      p.textSize(16);
      p.text(this.label, this.x + this.w / 2, this.y + this.h / 2);
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
        p.mouseX > this.x &&
        p.mouseX < this.x + this.w &&
        p.mouseY > this.y &&
        p.mouseY < this.y + this.h
      );
    }
  }

  // ---------------- PRELOAD ----------------
  p.preload = function () {
    alarm = p.loadSound("scream.mp3");
  };

  // ---------------- SETUP ----------------
  p.setup = function () {
    p.createCanvas(1000, 500);
    p.rectMode(p.CORNER);

    btnStart = new Button("Start", 300, 400, 80, 40);
    btnReset = new Button("Reset", 500, 400, 80, 40);
    btnPause = new Button("Pause", 400, 400, 80, 40);
    btnSwitchMode = new Button("Switch", 750, 200, 100, 40);
    btnSnooze = new Button("Snooze", 650, 400, 100, 40);

    lastTime = p.millis();
    lastCountdownTime = p.millis();
  };

  // ---------------- DRAW ----------------
  p.draw = function () {
    p.background(255);

    if (screen === 't') timeScreen();
    if (screen === 's') stopwatchScreen();
    if (screen === 'c') countdownScreen();

    updateStopwatch();
    updateCountdown();
    handleAlarm();
  };

  // ---------------- UPDATES ----------------

  function updateStopwatch() {
    if (timeStart && screen === 's') {
      let current = p.millis();
      let delta = current - lastTime;

      stopwatchElapsed += delta;
      lastTime = current;

      stopwatchHour = p.floor(stopwatchElapsed / 3600000);
      let remainder = stopwatchElapsed % 3600000;

      stopwatchMinute = p.floor(remainder / 60000);
      remainder %= 60000;

      stopwatchSecond = p.floor(remainder / 1000);
      stopwatchMilisecond = p.floor((remainder % 1000) / 10);
    }
  }

  function updateCountdown() {
    if (timeStart && screen === 'c') {
      let current = p.millis();
      let delta = current - lastCountdownTime;

      if (delta >= 1000) {
        let secondsPassed = p.floor(delta / 1000);
        lastCountdownTime = current;

        countdownElapsed -= secondsPassed * 1000;

        if (countdownElapsed <= 0) {
          countdownElapsed = 0;
          timeStart = false;

          alarmActive = true;
          snoozePressed = false;
          lastMeowTime = p.millis();

          if (alarm.isLoaded()) alarm.play();
        }

        countdownMinute = p.floor(countdownElapsed / 60000);
        let remainder = countdownElapsed % 60000;
        countdownSecond = p.floor(remainder / 1000);
      }
    }
  }

  function handleAlarm() {
    if (alarmActive && !snoozePressed) {
      if (p.millis() - lastMeowTime >= 2000) {
        if (alarm.isLoaded()) alarm.play();
        lastMeowTime = p.millis();
      }
    }
  }

  // ---------------- SCREENS ----------------

  function timeScreen() {
    p.textAlign(p.CENTER);
    p.textSize(60);

    let h = p.nf(p.hour(), 2);
    let m = p.nf(p.minute(), 2);
    let s = p.nf(p.second(), 2);

    p.text(h + ":" + m + ":" + s, p.width / 2, p.height / 2);

    btnSwitchMode.display();
  }

  function stopwatchScreen() {
    p.textAlign(p.CENTER);
    p.textSize(60);

    p.text(
      p.nf(stopwatchHour, 2) + ":" +
      p.nf(stopwatchMinute, 2) + ":" +
      p.nf(stopwatchSecond, 2),
      p.width / 2,
      p.height / 2
    );

    btnSwitchMode.display();
    btnStart.display();
    btnReset.display();
    btnPause.display();
  }

  function countdownScreen() {
    p.textAlign(p.CENTER);
    p.textSize(60);

    let displayText = countdownInput
      ? inputDigits
      : p.nf(countdownMinute, 2) + ":" + p.nf(countdownSecond, 2);

    p.text(displayText, p.width / 2, p.height / 2);

    btnSwitchMode.display();
    btnStart.display();
    btnPause.display();
    btnReset.display();

    if (alarmActive) btnSnooze.display();
  }

  // ---------------- INPUT ----------------

  p.mousePressed = function () {

    if (btnStart.clicked(p.mouseX, p.mouseY)) {
      timeStart = true;
      paused = false;

      if (screen === 'c') {
        if (!countdownInitialized) {
          let value = p.int(inputDigits || 0);

          let minutes = p.floor(value / 100);
          let seconds = value % 100;

          countdownElapsed = (minutes * 60000) + (seconds * 1000);
          countdownInitialized = true;
        }

        lastCountdownTime = p.millis();
        countdownInput = false;

        alarmActive = false;
        snoozePressed = false;
      } else {
        lastTime = p.millis();
      }
    }

    else if (btnReset.clicked(p.mouseX, p.mouseY)) {
      timeStart = false;

      stopwatchElapsed = 0;
      stopwatchHour = 0;
      stopwatchMinute = 0;
      stopwatchSecond = 0;

      countdownElapsed = 0;
      inputDigits = "";
      countdownInitialized = false;
      countdownInput = true;

      alarmActive = false;
      snoozePressed = false;
    }

    else if (btnPause.clicked(p.mouseX, p.mouseY)) {
      timeStart = false;
      paused = true;
    }

    else if (btnSwitchMode.clicked(p.mouseX, p.mouseY)) {
      if (screen === 't') screen = 's';
      else if (screen === 's') screen = 'c';
      else screen = 't';
    }

    else if (btnSnooze.clicked(p.mouseX, p.mouseY)) {
      snoozePressed = true;
      alarmActive = false;
    }
  };

});
