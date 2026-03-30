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

    fill(this.buttonColor);
    stroke(0);

    ellipseMode(CENTER);
    ellipse(this.x, this.y, this.w, this.h);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(this.label, this.x, this.y - 2);
  }

  clicked(mx, my) {
    return (
      mx > this.x - this.w / 2 &&
      mx < this.x + this.w / 2 &&
      my > this.y - this.h / 2 &&
      my < this.y + this.h / 2
    );
  }

  isMouseOver() {
    return (
      mouseX > this.x - this.w / 2 &&
      mouseX < this.x + this.w / 2 &&
      mouseY > this.y - this.h / 2 &&
      mouseY < this.y + this.h / 2
    );
  }
}
