import peasy.PeasyCam;
PeasyCam cam;

int NB_ITERATION = 0;


int curent_index = 0;
ArrayList<Point> points;
ArrayList<Triangle> triangles;
ArrayList<Triangle> new_triangles;

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
    for (Triangle tri : triangles) {
      Point a = new Point((tri.a.x + tri.b.x)/2, (tri.a.y + tri.b.y)/2, (tri.a.z + tri.b.z)/2, ++curent_index);
      Point b = new Point((tri.b.x + tri.c.x)/2, (tri.b.y + tri.c.y)/2, (tri.b.z + tri.c.z)/2, ++curent_index);
      Point c = new Point((tri.c.x + tri.a.x)/2, (tri.c.y + tri.a.y)/2, (tri.c.z + tri.a.z)/2, ++curent_index);

      a.normalize();
      b.normalize();
      c.normalize();

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

  StringList strlist = new StringList();

  for (Point pt : points) {
    strlist.append(pt.toStrObj());
  }

  for (Triangle tri : triangles) {
    strlist.append(tri.toStrObj());
  }



  saveStrings("sphere.obj", strlist.toArray());
}

void draw() {
  background(125);

  pushMatrix();
  translate(width/2, height/2, -300);

  for (Triangle tri : triangles) {
    tri.draw();
  }

  popMatrix();
}
