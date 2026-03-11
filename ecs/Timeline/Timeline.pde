float hoverAlpha = 0;
float fadeSpeed = 12;
boolean anyHovering = false;
String currentDetail = "";

void setup() {
  size(950, 400);
}

void draw() {
  background(#043277);

  anyHovering = false;

  // Call histEvent in order
  histEvent(90, 320, 150, "8000 BC Altay, China", false, true, false,
    "Skis are long by modern standards, Skiers use a single pole to aid balance. \n Some Chinese academics say the earliest Altay skis date back to 8000 BC, but other scholars say skiing came to the region much later.");
  histEvent(185, 140, 200, "3200 BC Kalvtrask, Sweden", true, true, true,
    "Skis are a long pole with a scoop carved into one end likely served purposes: Steering downhill, shoveling, and as a club for hunting.");
  histEvent(120, 180, 150, "6000 BC Vis, Russia", true, true, false,
    "The oldest ski found to date has an elk head carved on one end that may have functioned as a brake.");
  histEvent(280, 180, 160, "750 AD Kinnula, Finland", true, true, false,
    "Skis are shorter and wider, this intricately carved ski worked well on soft snow in forest terrain.");
  histEvent(300, 320, 140, "1600 AD Norway", false, true, false,
    "Skiers glided on one long smooth board coated with tar and pushed forward on a shorter, fur-bottomed one.");
  histEvent(515, 180, 160, "1800 Telemark, Norway", true, false, false,
    "Foreshadowing modern designs, the shape of these skis, wider at the ends and narrow in the middle, improved control and turning.");
  histEvent(665, 320, 170, "1860s Sierra Nevada, USA", false, true, false,
    "Initially American miners used 10-foot skis to travel in the mountains, and over time they began using longer skis to race each other.");
  histEvent(700, 180, 155, "1890s Europe and U.S.", true, true, false,
    "Skiing evolves as a leisure activity and sport. Hickory and ash skis are the primary equipment.");
  histEvent(865, 320, 80, "Present", false, false, false,
    "The revolution of ultralight construction evolves from the explosion of popularity in backcountry skiing. \n Lighter plastics, carbon fiber and woods such as poplar and paulownia replace heavier materials");

  // Fade logic
  if (anyHovering) {
    hoverAlpha = min(255, hoverAlpha + fadeSpeed);
  } else {
    hoverAlpha = max(0, hoverAlpha - fadeSpeed);
  }

  drawDetailBox();
  drawRef();
}

void drawDetailBox() {
  if (hoverAlpha > 0) {
    rectMode(CENTER);

    // Neutral background only, no outline color reacting to hover
    fill(#0861E6, hoverAlpha);
    noStroke();                   // Remove outline on the detail box
    rect(width/2, height-30, 820, 50, 10);

    // Fade in the detail text
    fill(255, hoverAlpha);
    textAlign(CENTER);
    textSize(14);
    text(currentDetail, width/2, height-33);
  }
}

void drawRef() {
  fill(#ffffff);
  textAlign(CENTER);
  textSize(40);
  text("History Of Skis", width/2, 60);
  textSize(20);
  text("by Ender Hale", width/2, 100);

  // Timeline line
  stroke(0);
  strokeWeight(4);
  line(40, 250, width-30, 250);

  fill(0);
  triangle(910, 240, 930, 250, 910, 260);
  triangle(45, 240, 25, 250, 45, 260);

  // Tick Marks
  strokeWeight(2);
  fill(255); // tick numbers white

  textSize(20);
  line(60, 240, 60, 260); text("8000 BC", 60, 230);
  textSize(13);
  line(130, 240, 130, 260); text("4000 BC", 130, 230);
  line(199, 240, 199, 260); text("0 AD", 199, 230);
  line(269, 240, 269, 260); text("1600", 269, 230);
  line(338, 240, 338, 260); text("1650", 338, 230);
  line(408, 240, 408, 260); text("1700", 408, 230);
  line(478, 240, 478, 260); text("1750", 478, 230);
  line(547, 240, 547, 260); text("1800", 547, 230);
  line(617, 240, 617, 260); text("1850 AD", 617, 230);
  line(686, 240, 686, 260); text("1900 AD", 686, 230);
  line(756, 240, 756, 260); text("1950 AD", 756, 230);
  line(825, 240, 825, 260); text("2000 AD", 825, 230);
  textSize(20);
  line(895, 240, 895, 260); text("Present", 895, 230);
}

void histEvent(int x, int y, int w, String title, boolean top, boolean left, boolean BC, String detail) {
  // Hover detection
  float halfH = 15;
  float halfW = w/2;
  boolean hovering = mouseX > x - halfW && mouseX < x + halfW &&
                     mouseY > y - halfH && mouseY < y + halfH;

  // Draw connector lines first
  stroke(0);
  strokeWeight(2);
  if (BC) {
    line(x, y, x-30, y+110);
  } else {
    line(x, y, left ? x-30 : x+30, top ? y+70 : y-70);
  }

  // Draw box on top
  rectMode(CENTER);
  strokeWeight(hovering ? 4 : 2);
  stroke(hovering ? color(255, 255, 150) : 0);
  fill(hovering ? 220 : 200);
  rect(x, y, w, 30, 10);

  // Only set detail for the **first box hovered**
  if (hovering && !anyHovering) {
    anyHovering = true;
    currentDetail = detail;
  }

  // Draw box text
  fill(255);
  textSize(15);
  textAlign(CENTER);
  text(title, x, y+5);
}
