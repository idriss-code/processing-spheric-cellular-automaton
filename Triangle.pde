class Triangle {

  Point a;
  Point b;
  Point c;

  int state = 0;

  ArrayList<Triangle> closeNeighbours = null;
  ArrayList<Triangle> distantNeighbours = null;

  Triangle(Point a, Point b, Point c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }

  void draw() {
    fill(state * 255);
    beginShape();
    vertex(a.x *100, a.y*100, a.z*100);
    vertex(b.x*100, b.y*100, b.z*100);
    vertex(c.x*100, c.y*100, c.z*100);
    endShape(CLOSE);
  }

  ArrayList<Triangle> getNeighbours(ArrayList<Triangle> triangles, int commonPts) {
    ArrayList<Triangle> ret = new ArrayList<Triangle>();
    for (Triangle t : triangles) {
      if(commonPoints(t) == commonPts) {
        ret.add(t);
      }
    }
    return ret;
  }

  ArrayList<Triangle> getCloseNeighbours(ArrayList<Triangle> triangles) {
    if(closeNeighbours == null) {
      closeNeighbours = getNeighbours(triangles,2);
    }
    return closeNeighbours;
  }

  ArrayList<Triangle> getDistantNeighbours(ArrayList<Triangle> triangles) {
    if(distantNeighbours == null) {
      distantNeighbours = getNeighbours(triangles,1);
    }
    return distantNeighbours;
  }

  ArrayList<Point> getAllPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(a);
    points.add(b);
    points.add(c);
    return points;
  }

  int commonPoints(Triangle t2) {
    int count = 0;
    for (Point p1 : this.getAllPoints()) {
      for (Point p2 : t2.getAllPoints()) {
        if(p1.index == p2.index) {
          count ++;
        }
      }
    }
    return count;
  }

}
