import java.util.*;
import controlP5.*;

int LEDscape_rows = 32;
int LEDscape_cols = 256;

ControlP5 cp5;

List<Fixture> g_fixtures;

Fixture g_selectedFixture;
boolean mouseDrag = false;

void setup() {
  size(1280, 800);
  cp5 = new ControlP5(this);
       
  setupFixtureTab();
  
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("Patterns")
     .setId(2)
     ;
  
  g_fixtures = loadFixturesFromJson("fixtures.json");
} 

void draw() {
  background(0);
  
  for (Fixture f : g_fixtures) {
    f.draw();
  }
  
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
}


void mousePressed() {
  for (Fixture f : g_fixtures) {
    if(f.isMouseOver()) {
      g_selectedFixture = f;
      g_selectedFixture.mousePressedEvent(mouseX, mouseY);
      mouseDrag = true;
      
      selectFixture(g_selectedFixture);
    }
  }
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

