import controlP5.*;
import processing.pdf.*;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentAdapter;
import java.awt.Insets;
import java.awt.Rectangle;

ControlP5 controlP5;
ControlWindow controlWindow;
ColorPicker backColor;

Hist3d hist3d;

boolean antialias = false;
boolean background = true;
boolean exponential = true;
boolean seamless = false;
boolean sorted = true;

boolean doSavePDF = false; // for PDF export

int nbObj = 512;  // initial number of objects
int type;         // to memorize the type of objects

ArrayList<Forme> objList;

Range sizeRange;
Range rotRange;
Range hueRange;
Range satRange;
Range briRange;
Range opaRange;

void setup() {
  noLoop();
  
  hist3d = new Hist3d();

  /* Window configuration */
  size(600, 600);
  frame.setResizable(true);
  frame.addComponentListener(new ComponentAdapter() { 
   public void componentResized(ComponentEvent e) { 
     if(e.getSource()==frame) {
       Rectangle bounds = frame.getBounds();
       Insets insets = frame.getInsets();
       int width = bounds.width - insets.left - insets.right;
       int height = bounds.height - insets.top - insets.bottom;
       println("resize frame : " + width + " x " + height);
       randomize(width,height);
     } 
   } 
 });

  /* A list to retain the objects */
  objList = new ArrayList(nbObj);

  /* User Interface */
  controlP5 = new ControlP5(this);  
  controlP5.setAutoDraw(false);
  controlWindow = controlP5.addControlWindow("controlP5window",50,50,450,250);
  controlWindow.hideCoordinates();
  controlWindow.setBackground(color(40));
  controlWindow.setTitle("DeadLeaves Parameters");

  /* Objects parameters */
  Slider s = controlP5.addSlider("nbObj",0,2048,20,20,350,10);
  s.setCaptionLabel("# Objects");
  s.moveTo(controlWindow);
  
  sizeRange = controlP5.addRange("size", 0, 512, 0, 256, 20, 40, 350, 10);
  sizeRange.moveTo(controlWindow);

  rotRange = controlP5.addRange("rotation", -360, 360, -180, 180, 20, 60, 350, 10);
  rotRange.setCaptionLabel("rotation (deg)");
  rotRange.moveTo(controlWindow);

  Radio r = controlP5.addRadio("type",20,110);
  r.moveTo(controlWindow);
  r.add("Ellipses",Forme.ELLIPSE);
  r.add("Rectangles",Forme.RECT);
  r.add("Circles",Forme.CIRCLE);
  r.add("Squares",Forme.SQUARE);
  r.add("Triangles",Forme.TRIANGLE);
  r.add("Stars",Forme.STAR);

  controlP5.addToggle("background",100,90,20,20).moveTo(controlWindow);
  controlP5.addToggle("antialias",100,130,20,20).moveTo(controlWindow);
  controlP5.addToggle("seamless",100,170,20,20).moveTo(controlWindow);
  controlP5.addToggle("exponential",145,170,20,20).moveTo(controlWindow);
  controlP5.addToggle("sorted",200,170,20,20).moveTo(controlWindow);
  
  backColor = controlP5.addColorPicker("back",170,85,50,20);
  backColor.moveTo(controlWindow);

  /* Color parameters */
  colorMode(HSB);  
  hueRange = controlP5.addRange("hue", 0, 255, 0, 255, 240, 110, 150, 10);
  hueRange.moveTo(controlWindow);
  satRange = controlP5.addRange("saturation", 0, 255, 0, 255, 240, 130, 150, 10);
  satRange.moveTo(controlWindow);
  briRange = controlP5.addRange("brightness", 0, 255, 0, 255, 240, 150, 150, 10);
  briRange.moveTo(controlWindow);
  opaRange = controlP5.addRange("opacity", 0, 255, 0, 255, 240, 170, 150, 10);
  opaRange.moveTo(controlWindow);

  /* Other controls */
  controlP5.addButton("randomize",0,20,220,80,19).moveTo(controlWindow);
  controlP5.addButton("export_PNG",0,120,220,80,19).moveTo(controlWindow);
  controlP5.addButton("export_PDF",0,220,220,80,19).moveTo(controlWindow);

  /* Create initial population */
  for(int i = 0; i < nbObj; i++) {
    addForme();
  }

}

synchronized void draw() {
  if(antialias) smooth(); else noSmooth();
  beginPDF();
  if(background)
    background(backColor.getColorValue());
  ArrayList<Forme> tmp = objList;
  if(sorted) {
    tmp = new ArrayList(objList);
    Collections.sort(tmp);
  }
  for(Forme f : tmp) {
    if(seamless)
      f.drawSeamless();
    else
      f.draw();
  }
  println("draw " + objList.size() + " objects");
  hist3d.setImage(get());
  endPDF();
}

void addForme() {
  objList.add(
    new Forme(
      type,
      random(width),
      random(height), 
      randomFn(sizeRange.lowValue(), sizeRange.highValue()),
      randomFn(sizeRange.lowValue(), sizeRange.highValue()),
      color(
        random(hueRange.lowValue(), hueRange.highValue()),
        random(satRange.lowValue(), satRange.highValue()),
        random(briRange.lowValue(), briRange.highValue()),
        random(opaRange.lowValue(), opaRange.highValue())
      ),
      random(rotRange.lowValue(), rotRange.highValue())
    )
  );
}

void randomize() {
  randomize(width, height);
}

void randomize(int width, int height) {
  updateObjPosition(width, height);
  redraw();
}

void updateObjNumber() {
    if(nbObj == objList.size())
      return;
    else if(nbObj < objList.size()) {
      objList.subList(nbObj,objList.size()).clear();
    } else {
      for(int i = objList.size(); i < nbObj; i++) {
        addForme();
      }
    }
}

void updateObjSize() {
  println("begin change size");
  float min = sizeRange.lowValue();
  float max = sizeRange.highValue();
  for(Forme f: objList) {
    f.setSize(
      randomFn(min,max),
      randomFn(min,max)
    );
  }
  println("end change size");
}

void updateObjPosition(float width, float height) {
  for(Forme f: objList) {
    f.setPosition(random(width), random(height));
  }
}

void updateObjType() {
  for(Forme f : objList) {
    f.setType(type);
  }
}

void updateObjRot() {
  for(Forme f : objList) {
    f.setRotation(random(rotRange.lowValue(), rotRange.highValue()));
  }
}

void updateObjHue() {
  for(Forme f : objList) {
    f.setHue(random(hueRange.lowValue(), hueRange.highValue()));
  }
}

void updateObjSat() {
  for(Forme f : objList) {
    f.setSaturation(random(satRange.lowValue(), satRange.highValue()));
  }
}

void updateObjBri() {
  for(Forme f : objList) {
    f.setBrightness(random(briRange.lowValue(), briRange.highValue()));
  }
}

void updateObjOpa() {
  for(Forme f : objList) {
    f.setOpacity(random(opaRange.lowValue(), opaRange.highValue()));
  }
}

/* Keyboard */

void keyPressed() {
  if(key=='r') {
    randomize();
  }
  if(key=='i') {
    if( controlWindow.isVisible() )
      controlWindow.hide();
    else
      controlWindow.show();
  }
  if(key == ' ') {
    export_PNG();
    export_PDF();
  }
}

/* Events */

synchronized void controlEvent(ControlEvent theControlEvent) {
  String s = theControlEvent.controller().name();
  if(s.equals("size") || s.equals("exponential")) {
    println("change size");
    updateObjSize();
  } else if(s.equals("nbObj")) {
    println("change number of objects");
    updateObjNumber();
  } else if(s.equals("type")) {
    println("change type of objects");
    updateObjType();
  } else if(s.equals("hue")) {
    updateObjHue();
  } else if(s.equals("saturation")) {
    updateObjSat();
  } else if(s.equals("brightness")) {
    updateObjBri();
  } else if(s.equals("opacity")) {
    updateObjOpa();
  } else if(s.equals("rotation")) {
    updateObjRot();
  } else if(s.equals("export_PNG") || s.equals("export_PDF")) {
    return;
  }
  redraw();
}

/* Random distributions */
float randomDisp(float r, float disp) {
  return random(min(0, r - disp), r + disp);
}

float randomFn(float min, float max) {
  if(exponential)
    return randomExp(min, max);
  else
    return random(min, max);
}

float randomExp(float min, float max) {
  float delta = max - min;
  return min + exp(random(-5,0))*delta;
}


/* Exportation */

String date() {
    String s = Integer.toString(10000*year()+100*month()+day())
    + Integer.toString(10000*hour()+100*minute()+second())
      + "-" + Integer.toString(millis());
      return s;
}

void export_PNG() {
  println("export PNG");
  saveFrame("deadLeaves-" + date() + ".png");
}

void export_PDF() {
  println("export PDF");
  doSavePDF = true;
  redraw();
}

void beginPDF() {
  if(doSavePDF)
    beginRecord(PDF, "deadLeaves-" + date() + ".pdf");
}

void endPDF() {
  if(doSavePDF) {
    endRecord();
    doSavePDF=false;
  }
}

