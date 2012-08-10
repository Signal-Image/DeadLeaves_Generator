import peasy.*;

public class Hist3d extends Frame {

  private Hist3dApplet histApp;
  private PImage img;
  private boolean autorotate = true;
  private PeasyCam cam;

  public Hist3d() {
    setBounds(screen.width/2,100,512,512);
    histApp = new Hist3dApplet();
    add(histApp);
    histApp.init();
    show();
    setResizable(false);
    setTitle("Hist3d");
  }

  void setImage(PImage i) {
    img = i;
  }

  void setAutorotate(boolean b) {
    autorotate = b;
  }

  boolean getAutorotate() {
    return autorotate;
  }

  class Hist3dApplet extends PApplet {

    public void setup() {
      size(512, 512, P3D);

      PFont myFont = createFont(PFont.list()[0], 64);
      textFont(myFont);
      textSize(18);

      cam = new PeasyCam(this, 500);
      cam.setMinimumDistance(200);
      cam.setMaximumDistance(700);
      cam.rotateX(PI);
      cam.rotateY(.5);
      cam.setState(cam.getState());
    }

    public void draw() {
      if(autorotate)
        cam.rotateY(.002);    

      background(255);
      smooth(); 
      noFill();
      stroke(128); 
      box(256);

  translate(-128,-128,-128);
  noSmooth();
  drawAxes();
      drawAxes();
      drawPoints(img);
    }

    // draw 3D RGB histogram with Points
    void drawPoints(PImage img) {
      if(img != null && img.pixels != null)
      for(color c : img.pixels) {
        stroke(c);
        point(red(c), green(c), blue(c));
      }
    }
    
    void drawAxes() {
  float[] rot = cam.getRotations();

  pushMatrix();
  translate(-10,-10,-10);
  rotateX(rot[0]);
  rotateY(rot[1]);
  rotateZ(rot[2]);
  fill(0);
  textAlign(CENTER);
  text("O",0,0,0);
  popMatrix();

  pushMatrix();
  translate(265,-10,-10);
  rotateX(rot[0]);
  rotateY(rot[1]);
  rotateZ(rot[2]);
  fill(255,0,0);
  textAlign(CENTER);
  text("R",0,0,0);
  popMatrix();

  pushMatrix();
  translate(-10,265,-10);
  rotateX(rot[0]);
  rotateY(rot[1]);
  rotateZ(rot[2]);
  fill(0,255,0);
  textAlign(CENTER);
  text("G",0,0,0);
  popMatrix();

  pushMatrix();
  translate(-10,-10,265);
  rotateX(rot[0]);
  rotateY(rot[1]);
  rotateZ(rot[2]);
  fill(0,0,255);
  textAlign(CENTER);
  text("B",0,0,0);
  popMatrix();
}

  }
}

