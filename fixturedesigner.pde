import java.util.*;
import controlP5.*;

// This should be 127.0.0.1, 58802
String transmit_address = "192.168.2.5";
//String transmit_address = "127.0.0.1";
int transmit_port       = 9999;

LEDDisplay sign;

Routine rgb;

int LEDscape_rows = 32;
int LEDscape_cols = 256;
PGraphics drawBuffer;

PGraphics outputFrame;

ControlP5 cp5;

List<Fixture> g_fixtures;

// State variables
final int FIXTURES_TAB = 1;
final int PATTERNS_TAB = 2;
int g_selectedTab;
Fixture g_selectedFixture;
boolean mouseDrag = false;

void setup() {
  size(1000, 500);
  cp5 = new ControlP5(this);
  
  sign = new LEDDisplay(this, LEDscape_cols, LEDscape_rows, 2, true, transmit_address, transmit_port);
       
  //drawBuffer = createGraphics(1000, 500);
  drawBuffer = createGraphics(70, 70);
  rgb = new RGBRoutine();
  rgb.reset();
       
  setupFixtureTab();
  
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("Patterns")
     .setId(PATTERNS_TAB)
     ;
  
  g_fixtures = loadFixturesFromJson("fixtures.json");
  
  outputFrame = createGraphics(LEDscape_cols, LEDscape_rows);
}

void draw() {
  background(0,0,0);
  stroke(255);
  fill(255);
  if(g_selectedTab == PATTERNS_TAB) {
    ellipse(mouseX, mouseY, 20, 20);
  }
  
  // draw the pattern
  pushMatrix();
    translate(width/2,height/2);
    rotate(frameCount/70.2);
    //scale(2.5);
    scale(12);
    translate(-drawBuffer.width/2,-drawBuffer.height/2);
    drawBuffer.beginDraw();
    drawBuffer.background(0);
    rgb.draw(drawBuffer);
    drawBuffer.endDraw();
    image(drawBuffer, 0,0);
  popMatrix();

  // render the output of the fixtures to LEDscape
  outputFrame.beginDraw();
  outputFrame.background(0);
  outputFrame.loadPixels();
  loadPixels();
  
  
  
  // In fixture design mode, if a fixture is selected, only draw that fixture
  if(g_selectedFixture != null && g_selectedTab == FIXTURES_TAB) {
    updatePixels();
    background(0,0,255);  // TODO: signal to the fixture that it should be white only?
    loadPixels();
    for (Fixture f : g_fixtures) {
      if(g_selectedFixture == f) {
        f.render(outputFrame);
      }
    }
    updatePixels();
    background(0);
    loadPixels();
    
  }
  
  // Otherwise, draw all the fixtures.
  else {
    for (Fixture f : g_fixtures) {
      f.render(outputFrame);
    }
  }
  updatePixels();
  outputFrame.updatePixels();
  outputFrame.endDraw();
  
  noStroke();
  fill(128);
  rect(
    width - outputFrame.width - 12,
    height - outputFrame.height - 12,
    outputFrame.width + 4,
    outputFrame.height + 4
    );
  image(outputFrame, width - outputFrame.width - 10, height - outputFrame.height - 10);
  
  sign.sendData(outputFrame);
  
  // draw the fixtures on the screen
  if(g_selectedTab == FIXTURES_TAB) {
    for (Fixture f : g_fixtures) {
      f.draw();
    }
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    g_selectedTab = theControlEvent.getTab().getId();
  }
}


void mousePressed() {
  for (Fixture f : g_fixtures) {
    if(f.isMouseOver()) {
      g_selectedFixture = f;
      g_selectedFixture.mousePressedEvent(mouseX, mouseY);
      mouseDrag = true;
      
      selectFixture(g_selectedFixture);
      return;
    }
  }
  //g_selectedFixture = null;
}

void mouseDragged() {
  if(mouseDrag) {
    g_selectedFixture.mouseDragEvent(mouseX, mouseY);
  }
}

void mouseReleased() {
  if(mouseDrag) {
    mouseDrag = false;
    g_selectedFixture.mouseReleasedEvent(mouseX, mouseY);
  }
}

