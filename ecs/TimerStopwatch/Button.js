class Button {
  constructor(p, label, x, y, w, h) {
    this.p = p;
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.buttonColor = 220;
  }

  display() {
    let p = this.p;

    if (this.isMouseOver()) {
      this.buttonColor = 190;
    } else {
      this.buttonColor = 220;
    }

    p.fill(this.buttonColor);
    p.stroke(0);

    p.ellipseMode(p.CENTER);
    p.ellipse(this.x, this.y, this.w, this.h);

    p.fill(0);
    p.textAlign(p.CENTER, p.CENTER);
    p.textSize(16);
    p.text(this.label, this.x, this.y - 2);
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
    let p = this.p;

    return (
      p.mouseX > this.x - this.w / 2 &&
      p.mouseX < this.x + this.w / 2 &&
      p.mouseY > this.y - this.h / 2 &&
      p.mouseY < this.y + this.h / 2
    );
  }
}
