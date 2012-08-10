class Forme implements Comparable {

  final static int POINT = 0;
  final static int RECT = 1;
  final static int TRIANGLE = 2;
  final static int STAR = 3;
  final static int ELLIPSE = 4;
  final static int CIRCLE = 5;
  final static int SQUARE = 6;

  int t;      // type
  float x, y; // coordinates: X, Y
  float w, h; // size: width, height
  color c;    // color
  float r;    // rotation
  float ch, cs, cb, ca; // hue, saturation, brightness, alpha

  // Constructor
  Forme(int it, float ix, float iy, float iw, float ih, color ic, float ir) {
    t = it;
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    c = ic;
    r = ir;
    
    //color components
    ch = hue(c);
    cs = saturation(c);
    cb = brightness(c);
    ca = alpha(c);
  }

  void draw() {
    pushMatrix();
    translate(x,y);
    rotate(radians(r));
    c = color(ch, cs, cb, ca);
    fill(c); 
    noStroke();

    switch(t) {
    case ELLIPSE: 
      ellipse(0,0,w,h); 
      break;
    case CIRCLE:
      ellipse(0,0,w,w); 
      break;
    case SQUARE:
      rect(-w/2,-w/2,w,w);
      break;
    case RECT:
      rect(-w/2,-h/2,w,h);
      break;
    case TRIANGLE:
      triangle(0,-w,
      w*cos(PI*30/180),
      w*sin(PI*30/180),
      -w*cos(PI*30/180),
      w*sin(PI*30/180));
      break;
    case STAR:
      drawStar(0,0,w/2,w,5);
      break;
    default:
      stroke(c);
      point(x, y);
    }
    popMatrix();
  }

  private void drawStar ( float x, float y, float radius_inner, float radius_outer, int spikes ) { 
    float r = 0.0;
    float res = 360.0/spikes;
    float res_half = res/2;

    beginShape();

    for ( float i = 0; i < 360; i+=res ) {
      r = -HALF_PI + radians( i );
      vertex( x + cos(r) * radius_outer, y + sin(r) * radius_outer );
      r = -HALF_PI + radians( i + res_half );
      vertex( x + cos(r) * radius_inner, y + sin(r) * radius_inner );
    } 

    endShape( CLOSE );
  } 


  void drawSeamless() {
    translate(-width, -height);
    draw();
    translate(width, 0);
    draw();
    translate(width, 0);
    draw();
    translate(-2*width, height);
    draw();
    translate(width, 0);
    draw();
    translate(width, 0);
    draw();
    translate(-2*width, height);
    draw();
    translate(width, 0);
    draw();
    translate(width, 0);
    draw();
    translate(-width, -height);
  }

  void setPosition(float ix, float iy) {
    x = ix;
    y = iy;
  }

  void setSize(float iw, float ih) {
    w = iw;
    h = ih;
  }

  void setType(int it) {
    t = it;
  }

  void setHue(float h) {
    ch = h;
  }

  void setSaturation(float s) {
    cs = s;
  }

  void setBrightness(float b) {
    cb = b;
  }

  void setOpacity(float a) {
    ca = a;
  }

  void setRotation(float ir) {
    r = ir;
  }

  float getMinSize() {
    return min(w,h);
  }

  public int compareTo(Object f) {
    float size = getMinSize();
    float fsize = ((Forme) f).getMinSize();
    if(size < fsize) {
      return 1;
    } 
    else if (size == fsize) {
      return 0;
    } 
    else {
      return -1;
    }
  }
}

