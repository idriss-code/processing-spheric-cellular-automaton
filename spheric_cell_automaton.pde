import peasy.PeasyCam;
import controlP5.*;

ControlP5 cp5;
PeasyCam cam;

int NB_ITERATION = 5;

int curent_index = 0;
ArrayList<Point> points;
ArrayList<Triangle> triangles;
ArrayList<Triangle> new_triangles;
long previousTime;

int algo = 0;
int startPos = 0;

enum State {
  SETUP, RUN, }
State state = State.SETUP;

void setup() {
  size(800, 600, P3D);
  //noFill();
  strokeWeight(1);
  initSetup();
}

void initSetup() {
  cp5 = new ControlP5(this);
  int buttonWidth = 200;
  int buttonHeight = 50;
  cp5.addButton("run") .setPosition(width - buttonWidth,height - buttonHeight) .setSize(buttonWidth,buttonHeight);
  cp5.addSlider("NB_ITERATION") .setSize(255,30) .setRange(0,10);
  cp5.addDropdownList("algo") .addItem("Islands",0) .addItem("Seeds",1) .addItem("Brian's Brain",2);;
  cp5.addDropdownList("startPos") .setPosition(0,100) .addItem("random",0) .addItem("solo",1);
}

// button run
void run() {
  state = State.RUN;
  cp5.setAutoDraw(false);
  initSphere();
}

void initSphere() {
  cam = new PeasyCam(this, width/2, height/2, -300, 400);
  points = new ArrayList<Point>();
  points.add(new Point(1, 0, 0, ++curent_index));
  points.add(new Point(-1, 0, 0, ++curent_index));
  points.add(new Point(0, 1, 0, ++curent_index));
  points.add(new Point(0, -1, 0, ++curent_index));
  points.add(new Point(0, 0, 1, ++curent_index));
  points.add(new Point(0, 0, -1, ++curent_index));

  triangles = new ArrayList<Triangle>();
  triangles.add(new Triangle(points.get(0), points.get(2), points.get(4)));
  triangles.add(new Triangle(points.get(0), points.get(4), points.get(3)));
  triangles.add(new Triangle(points.get(0), points.get(3), points.get(5)));
  triangles.add(new Triangle(points.get(0), points.get(5), points.get(2)));
  triangles.add(new Triangle(points.get(1), points.get(2), points.get(4)));
  triangles.add(new Triangle(points.get(1), points.get(4), points.get(3)));
  triangles.add(new Triangle(points.get(1), points.get(3), points.get(5)));
  triangles.add(new Triangle(points.get(1), points.get(5), points.get(2)));

  for (int i=0; i<NB_ITERATION; i++) {
    new_triangles = new ArrayList<Triangle>();
    HashMap<String, Point> hm = new HashMap<String, Point>();
    for(Triangle tri : triangles) {
      Point a = getMiddle(tri.a, tri.b, hm);
      Point b = getMiddle(tri.b, tri.c, hm);
      Point c = getMiddle(tri.c, tri.a, hm);

      points.add(a);
      points.add(b);
      points.add(c);

      new_triangles.add(new Triangle(tri.a, a, c));
      new_triangles.add(new Triangle(tri.b, b, a));
      new_triangles.add(new Triangle(tri.c, c, b));
      new_triangles.add(new Triangle(a, b, c));
    }
    triangles = new_triangles;
  }

  switch(startPos) {
    case 0: randomStart();
    break;
    case 1: soloStart();
    break;
  }
  for(Point pt : points) {
    //pt.normalize();
  }
  previousTime = millis();
}

void randomStart() {
  println("randomStart");
  for(Triangle tri : triangles) {
    tri.state = int(random(0, 3));
  }
}

void soloStart() {
  println("soloStart");
  for(Triangle tri : triangles) {
    tri.state = 0;
  }
  triangles.get(triangles.size() - 1).state = 1;
}
Point getMiddle(Point a, Point b, HashMap<String, Point> hm) {
  String key;
  if (a.index > b.index) {
    key = String.valueOf(a.index) + "-" + String.valueOf(b.index);
  } else {
    key = String.valueOf(b.index) + "-" + String.valueOf(a.index);
  }
  Point point = hm.get(key);
  if (point == null) {
    point = new Point((a.x + b.x)/2,(a.y + b.y)/2,(a.z + b.z)/2, ++curent_index);
    point.normalize();
    hm.put(key, point);
  }
  return point;
}

void update() {
  println("update" + millis());

  for(Triangle tri : triangles) {

    switch(algo) {
      case 0: algo0(tri);
      break;
      case 1: algo1(tri);
      break;
      case 2: algo2(tri);
      break;
    }
  }
  for(Triangle tri : triangles) {
    tri.state = tri.newState;
  }
}

void algo0(Triangle triangle) {
  int coeff = 2;
  int closeNeighbourOn = triangle.getCountNeighbourByState(triangles,1,Dist.CLOSE);
  int distantNeighbourOn = triangle.getCountNeighbourByState(triangles,1,Dist.DISTANT);
  int NeighbourOn = closeNeighbourOn * coeff + distantNeighbourOn;

  if (triangle.state == 1) {
    triangle.newState = NeighbourOn >= 7 ? 1 : 0;
  } else {
    triangle.newState = NeighbourOn >= 8 ? 1 : 0;
  }
}

void algo1(Triangle triangle) {
  int closeNeighbourOn = triangle.getCountNeighbourByState(triangles,1,Dist.CLOSE);
  triangle.newState = closeNeighbourOn == 1 ? 1 : 0;
}

void algo2(Triangle triangle) {
  int closeNeighbourOn = triangle.getCountNeighbourByState(triangles,1,Dist.CLOSE);
  if (triangle.state == 0) {
    triangle.newState = closeNeighbourOn == 1 ? 1 : 0;
  }
  else if (triangle.state == 1) {
    triangle.newState = 2;
  } else {
    triangle.newState = 0;
  }
}

void draw() {
  background(125);
  if (state == State.RUN) {
    if (millis() - previousTime > 1000) {
      previousTime = millis();
      update();
    }
    pushMatrix();
    translate(width/2, height/2, -300);

    for(Triangle tri : triangles) {
      tri.draw();
    }
    popMatrix();
  }
}
