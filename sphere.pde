import peasy.PeasyCam;
PeasyCam cam;

int NB_ITERATION = 3;


int curent_index = 0;
ArrayList<Point> points;
ArrayList<Triangle> triangles;
ArrayList<Triangle> new_triangles;

long previous;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, width/2, height/2, -300, 400);
  //noFill();
  strokeWeight(1);
  points = new ArrayList<Point>();
  points.add(new Point(1, 0, 0, ++curent_index));
  points.add(new Point(-1, 0, 0, ++curent_index));
  points.add(new Point(0, 1, 0, ++curent_index));
  points.add(new Point(0, -1, 0, ++curent_index));
  points.add(new Point(0, 0, 1, ++curent_index));
  points.add(new Point(0, 0, -1, ++curent_index));

  triangles = new ArrayList<Triangle>();
  triangles.add(new Triangle(points.get(0), points.get(2), points.get(4)));
  triangles.add( new Triangle(points.get(0), points.get(4), points.get(3)));
  triangles.add( new Triangle(points.get(0), points.get(3), points.get(5)));
  triangles.add( new Triangle(points.get(0), points.get(5), points.get(2)));
  triangles.add(new Triangle(points.get(1), points.get(2), points.get(4)));
  triangles.add( new Triangle(points.get(1), points.get(4), points.get(3)));
  triangles.add( new Triangle(points.get(1), points.get(3), points.get(5)));
  triangles.add( new Triangle(points.get(1), points.get(5), points.get(2)));

  for (int i = 0; i < NB_ITERATION; i++) {
    new_triangles = new ArrayList<Triangle>();
    HashMap<String, Point> hm = new HashMap<String, Point>();
    for (Triangle tri : triangles) {

      Point a = getMiddle(tri.a, tri.b, hm);
      Point b = getMiddle(tri.b, tri.c, hm);
      Point c = getMiddle(tri.c, tri.a, hm);

      points.add(a);
      points.add(b);
      points.add(c);

      new_triangles.add( new Triangle(tri.a, a, c));
      new_triangles.add( new Triangle(tri.b, b, a));
      new_triangles.add( new Triangle(tri.c, c, b));
      new_triangles.add( new Triangle(a, b, c));
    }

    triangles = new_triangles;
  }

  for (Point pt : points) {
    //pt.normalize();
  }
  previous = millis();
}

Point getMiddle(Point a, Point b, HashMap<String, Point> hm) {
  String key = String.valueOf(a.index) + "-" +  String.valueOf(b.index);
  Point point = hm.get(key);
  if (point == null) {
    point = new Point((a.x + b.x)/2, (a.y + b.y)/2, (a.z + b.z)/2, ++curent_index);
    point.normalize();
    hm.put(key, point);
  }
  return point;
}

void update() {
  println("update" + millis());
}

void draw() {
  if (millis() - previous > 1000) {
    previous = millis();
    update();
  }

  background(125);

  pushMatrix();
  translate(width/2, height/2, -300);

  for (Triangle tri : triangles) {
    tri.draw();
  }

  popMatrix();
}
