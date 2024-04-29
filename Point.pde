class Point {

  float x;
  float y;
  float z;
  int index;


  Point(float x, float y, float z, int index) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.index = index;
  }

  void normalize() {
    float mag = x * x + y * y + z * z;
    if (mag != 0.0) {
      mag = 1.0 / sqrt(mag);
      x *= mag;
      y *= mag;
      z *= mag;
    }
  }
  
  String toStrObj(){
   return "v " + x + " " + y + " " + z ;
  }
}
