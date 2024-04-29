class Triangle {

  Point a;
  Point b;
  Point c;

  Triangle(Point a, Point b, Point c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }

  void draw() {
    beginShape();
    vertex(a.x *100, a.y*100, a.z*100);
    vertex(b.x*100, b.y*100, b.z*100);
    vertex(c.x*100, c.y*100, c.z*100);
    endShape(CLOSE);
  }
}
