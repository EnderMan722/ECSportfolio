// Ender Hale | Timer - Stopwatch | March 25 2026

import processing.sound.*;

boolean timeStart;
boolean paused = false;

char screen = 't';

String inputDigits = "";
boolean countdownInput = true;
boolean countdownInitialized = false;

int countdownElapsed = 0;

int lastTime;
int lastCountdownTime;

String timeDisplay, secondDisplay;

int stopwatchElapsed = 0;

int stopwatchHour, stopwatchMinute, stopwatchSecond, stopwatchMilisecond;
int countdownMinute, countdownSecond;

Button one, two, three, four, five, six, seven, eight, nine, zero;
Button btnStart, btnReset, btnPause, btnPlus, btnMinus, btnSwitchMode, btnSnooze;

SoundFile alarm;

// ✅ alarm state
boolean alarmActive = false;
boolean snoozePressed = false;
int lastMeowTime = 0;

void setup() {
  size(1000, 500);

  alarm = new SoundFile(this, "scream.mp3");

  btnStart = new Button("Start", 300, height-100, 75, 40);
  btnReset = new Button("Reset", 500, height-100, 75, 40);
  btnPause = new Button("Pause", 400, height-100, 75, 40);
  btnPlus = new Button("+10 Seconds", 620, height-100, 100, 40);
  btnMinus = new Button("-10 Seconds", 750, height-100, 100, 40);
  btnSwitchMode = new Button("Switch", 750, 200, 55, 50);

  btnSnooze = new Button("Snooze", 650, height-100, 100, 40);

  one   = new Button("1", 420, 180, 50, 50);
  two   = new Button("2", 500, 180, 50, 50);
  three = new Button("3", 580, 180, 50, 50);

  four  = new Button("4", 420, 260, 50, 50);
  five  = new Button("5", 500, 260, 50, 50);
  six   = new Button("6", 580, 260, 50, 50);

  seven = new Button("7", 420, 340, 50, 50);
  eight = new Button("8", 500, 340, 50, 50);
  nine  = new Button("9", 580, 340, 50, 50);

  zero  = new Button("0", 500, 420, 50, 50);

  lastTime = millis();
  lastCountdownTime = millis();
}

void draw() {
  background(255);

  switch(screen) {
  case 't':
    timeScreen();
    break;
  case 's':
    stopwatchScreen();
    break;
  case 'c':
    countdownTimerScreen();
    break;
  }

  // STOPWATCH
  if (timeStart && screen == 's') {
    int current = millis();
    int delta = current - lastTime;

    stopwatchElapsed += delta;
    lastTime = current;

    stopwatchHour = stopwatchElapsed / 3600000;
    int remainder = stopwatchElapsed % 3600000;

    stopwatchMinute = remainder / 60000;
    remainder %= 60000;

    stopwatchSecond = remainder / 1000;
    stopwatchMilisecond = (remainder % 1000) / 10;
  }

  // COUNTDOWN
  if (timeStart && screen == 'c') {
    int current = millis();
    int delta = current - lastCountdownTime;

    if (delta >= 1000) {
      int secondsPassed = delta / 1000;
      lastCountdownTime = current;

      countdownElapsed -= secondsPassed * 1000;

      if (countdownElapsed <= 0) {
        countdownElapsed = 0;
        timeStart = false;

        // ✅ start alarm
        alarmActive = true;
        snoozePressed = false;
        lastMeowTime = millis();

        alarm.play();
      }

      countdownMinute = countdownElapsed / 60000;
      int remainder = countdownElapsed % 60000;
      countdownSecond = remainder / 1000;
    }
  }

  // ✅ LOOP ALARM EVERY 3 SECONDS
  if (alarmActive && !snoozePressed) {
    if (millis() - lastMeowTime >= 2000) {
      alarm.play();
      lastMeowTime = millis();
    }
  }
}

void mousePressed() {

  // START
  if (btnStart.clicked(mouseX, mouseY)) {

    if (screen == 'c') {

      if (!countdownInitialized) {

        int value = 0;
        if (inputDigits.length() > 0) {
          value = int(inputDigits);
        }

        int minutes = value / 100;
        int seconds = value % 100;

        countdownElapsed = (minutes * 60000) + (seconds * 1000);

        countdownMinute = minutes;
        countdownSecond = seconds;

        countdownInitialized = true;
      }

      lastCountdownTime = millis();
      countdownInput = false;
      timeStart = true;
      paused = false;

      // reset alarm
      alarmActive = false;
      snoozePressed = false;
    } else {
      timeStart = true;
      paused = false;
      lastTime = millis();
    }
  }

  // RESET
  else if (btnReset.clicked(mouseX, mouseY)) {
    timeStart = false;
    paused = false;

    stopwatchElapsed = 0;
    stopwatchHour = 0;
    stopwatchMinute = 0;
    stopwatchSecond = 0;
    stopwatchMilisecond = 0;

    countdownElapsed = 0;
    countdownMinute = 0;
    countdownSecond = 0;

    countdownInitialized = false;
    inputDigits = "";
    countdownInput = true;

    // reset alarm
    alarmActive = false;
    snoozePressed = false;
  }

  // PAUSE
  else if (btnPause.clicked(mouseX, mouseY)) {
    paused = true;
    timeStart = false;
  }

  // SWITCH MODE
  // SWITCH MODE
  else if (btnSwitchMode.clicked(mouseX, mouseY)) {
    if (screen == 't') screen = 's';
    else if (screen == 's') screen = 'c';
    else if (screen == 'c') screen = 't';

    // Stopwatch layout
    if (screen == 's') {
      btnStart.x = 300;
      btnStart.y = height - 100;

      btnPause.x = 400;
      btnPause.y = height - 100;

      btnReset.x = 500;
      btnReset.y = height - 100;
    }

    // ✅ Countdown layout (MOVE TO LEFT)
    if (screen == 'c') {
      btnStart.x = 100;
      btnStart.y = 250;

      btnPause.x = 100;
      btnPause.y = 300;

      btnReset.x = 100;
      btnReset.y = 350;

      btnSnooze.x = 100;
      btnSnooze.y = 400;
    }
  }

  // SNOOZE
  if (btnSnooze.clicked(mouseX, mouseY)) {
    snoozePressed = true;
    alarmActive = false;
  }

  // NUMBER INPUT
  if (screen == 'c' && countdownInput) {
    if (one.clicked(mouseX, mouseY)) inputDigits += "1";
    else if (two.clicked(mouseX, mouseY)) inputDigits += "2";
    else if (three.clicked(mouseX, mouseY)) inputDigits += "3";
    else if (four.clicked(mouseX, mouseY)) inputDigits += "4";
    else if (five.clicked(mouseX, mouseY)) inputDigits += "5";
    else if (six.clicked(mouseX, mouseY)) inputDigits += "6";
    else if (seven.clicked(mouseX, mouseY)) inputDigits += "7";
    else if (eight.clicked(mouseX, mouseY)) inputDigits += "8";
    else if (nine.clicked(mouseX, mouseY)) inputDigits += "9";
    else if (zero.clicked(mouseX, mouseY)) inputDigits += "0";
  }
}

// ---------------- SCREENS ----------------

void timeScreen() {
  textAlign(CENTER);

  textSize(120);
  timeDisplay = nf(hour(), 2) + ":" + nf(minute(), 2);
  text(timeDisplay, width/2-40, height/2);

  textSize(60);
  secondDisplay = "." + nf(second(), 2);
  text(secondDisplay, width/2 + 140, height/2);

  btnSwitchMode.display();
}

void stopwatchScreen() {
  float spacing = 100;
  textAlign(CENTER);

  textSize(120);

  text(nf(stopwatchHour, 2), width/2-spacing*2, height/2);
  text(":", width/2-spacing*1.25, height/2);

  text(nf(stopwatchMinute, 2), width/2-spacing*0.5, height/2);
  text(":", width/2+spacing*0.2, height/2);

  text(nf(stopwatchSecond, 2), width/2+spacing, height/2);

  textSize(30);
  text(nf(stopwatchMilisecond, 2), width/2 + spacing*1.8, 175);

  btnSwitchMode.display();
  btnStart.display();
  btnReset.display();
  btnPause.display();
  btnPlus.display();
  btnMinus.display();
}

void countdownTimerScreen() {
  textAlign(CENTER);
  textSize(120);

  String displayText;

  if (countdownInput) {
    displayText = inputDigits;
  } else {
    displayText = nf(countdownMinute, 2) + ":" + nf(countdownSecond, 2);
  }

  text(displayText, width/2, height/2 - 125);

  one.display();
  two.display();
  three.display();
  four.display();
  five.display();
  six.display();
  seven.display();
  eight.display();
  nine.display();
  zero.display();

  btnSwitchMode.display();
  btnStart.display();
  btnPause.display();
  btnReset.display();

  // show snooze only when alarm is active
  if (alarmActive) {
    btnSnooze.display();
  }
}
