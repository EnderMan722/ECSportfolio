class Button {
  String label;
  float x, y, w, h;
  float buttonColor;

  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    if(isMouseOver()) {
      buttonColor = 190;
    } else {
      buttonColor = 220;
    }
    fill(buttonColor);
    stroke(0);
    ellipseMode(CENTER);
    ellipse(x, y, w, h);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, x, y-2);
  }

  boolean clicked(int tempX, int tempY) {
    if (tempX > x-w/2 && tempX < x+w/2 && tempY > y-h/2 && tempY < y+h/2) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isMouseOver() {
    if (mouseX > x-w/2 && mouseX < x+w/2 && mouseY > y-h/2 && mouseY < y+h/2) {
      return true;
    } else {
      return false;
    }
  }
}
