abstract class Fixture {
  PApplet parent;
  
  void draw() {};
  
  void render(PGraphics frame) {};
  
  boolean isMouseOver() {return false;}
  
  void mousePressedEvent(int x, int y) {};
  void mouseDragEvent(int x, int y) {};
  void mouseReleasedEvent(int x, int y) {};
};

boolean mouseCollideCircle(float x, float y, float d) {
  return (
    (mouseX > x - d/2)
    &&(mouseX < x + d/2)
    &&(mouseY > y - d/2)
    &&(mouseY < y + d/2));
}

List<Fixture> loadFixturesFromJson(String fileName) {
  List<Fixture> fixtures = new LinkedList<Fixture>();
  JSONArray entries = loadJSONArray(fileName);
  
  for (int i = 0; i < entries.size(); i++) {
    JSONObject fixture = entries.getJSONObject(i); 

    String type = fixture.getString("type");
    println(type);
    
    if(type.equals("led")) {
      float x = fixture.getFloat("x");
      float y = fixture.getFloat("y");
      int row = fixture.getInt("row");
      int offset = fixture.getInt("offset");
      fixtures.add(new Led(x, y, row, offset)); 
    }
    else if(type.equals("ledStrip")) {
      float x1 = fixture.getFloat("x1");
      float y1 = fixture.getFloat("y1");
      float x2 = fixture.getFloat("x2");
      float y2 = fixture.getFloat("y2");
      int row = fixture.getInt("row");
      int offset = fixture.getInt("offset");
      int len = fixture.getInt("length");
      fixtures.add(new LedStrip(x1, y1, x2, y2, row, offset, len)); 
    }
  }
  return fixtures;
}

void saveFixturesToJson(String fileName, List<Fixture> fixtures) {
  
  JSONArray output = new JSONArray();

  for (int i = 0; i < fixtures.size(); i++) {

    JSONObject entry = new JSONObject();
    
    if(fixtures.get(i) instanceof Led) {
      Led led = (Led)fixtures.get(i);
      entry.setString("type", "led");
      entry.setFloat("x", led.m_x);
      entry.setFloat("y", led.m_y);
      entry.setInt("row", led.m_row);
      entry.setInt("offset", led.m_offset);
    }
    else if(fixtures.get(i) instanceof LedStrip) {
      LedStrip led = (LedStrip)fixtures.get(i);
      entry.setString("type", "ledStrip");
      entry.setFloat("x1", led.m_x1);
      entry.setFloat("y1", led.m_y1);
      entry.setFloat("x2", led.m_x2);
      entry.setFloat("y2", led.m_y2);
      entry.setInt("row", led.m_row);
      entry.setInt("offset", led.m_offset);
      entry.setInt("length", led.m_length);
    }
//    else if(type.equals("ledStrip")) {
//      
//      fixture.setInt("id", i);
//      fixture.setString("species", species[i]);
//      fixture.setString("name", names[i]);
//      float x1 = fixture.getFloat("x1");
//      float y1 = fixture.getFloat("y1");
//      float x2 = fixture.getFloat("x2");
//      float y2 = fixture.getFloat("y2");
//      int row = fixture.getInt("row");
//      int offset = fixture.getInt("offset");
//      int len = fixture.getInt("length");
//      fixtures.add(new LedStrip(x1, y1, x2, y2, row, offset, len)); 
//    }
    else {
      continue;
    }

    output.setJSONObject(i, entry);
  }

  saveJSONArray(output, fileName);
}

class Led extends Fixture {
  float m_x;
  float m_y; 
  float m_d;
  
  int m_row;
  int m_offset;
  
  Led(float x, float y, int row, int offset) {
    m_x = x;
    m_y = y;
    m_d = 10;
    m_row = row;
    m_offset = offset;
  } 

  void draw() {
    if(this == g_selectedFixture) {
      stroke(10,200,200,50);
      fill(10,200,200,50);
    }
    else {
      stroke(255,30);
      noFill();
    }
    
    strokeWeight(2);
    
    if(mouseCollideCircle(m_x, m_y, m_d)) {
      fill(0,120,60);
    }

    ellipse(m_x, m_y, m_d, m_d);
  }
  
  boolean isMouseOver() {
    return mouseCollideCircle(m_x, m_y, m_d);
  }
  
  void mouseDragEvent(int x, int y) {
    m_x = x;
    m_y = y;
  }
}

class LedStrip extends Fixture {
  float m_x1;
  float m_y1; 
  float m_x2;
  float m_y2;
  float m_d;
  
  int m_row;
  int m_offset;
  int m_length;
  
  int m_mouseDragPoint;
  
  LedStrip(float x1, float y1, float x2, float y2, int row, int offset, int len) {
    m_x1 = x1;
    m_y1 = y1;
    m_x2 = x2;
    m_y2 = y2;
    m_d = 10;
    m_row = row;
    m_offset = offset;
    m_length = len;
  } 

  void draw() {
    if(this == g_selectedFixture) {
      stroke(10,200,200,50);
    }
    else {
      stroke(255,30);
    }
    
    strokeWeight(10);
    
    line(m_x1, m_y1, m_x2, m_y2);
    
    stroke(255,50);
    strokeWeight(2);
    if(mouseCollideCircle(m_x1, m_y1, m_d)) {
      fill(0,120,60);
    }
    else {
      noFill();
    }
    ellipse(m_x1, m_y1, m_d, m_d);
    
    if(mouseCollideCircle(m_x2, m_y2, m_d)) {
      fill(0,120,60);
    }
    else {
      noFill();
    }
    ellipse(m_x2, m_y2, m_d, m_d);
  }
  
  boolean isMouseOver() {
    return (
      mouseCollideCircle(m_x1, m_y1, m_d)
      || mouseCollideCircle(m_x2, m_y2, m_d));
  }
  
  void mousePressedEvent(int x, int y) {
    if( mouseCollideCircle(m_x1, m_y1, m_d)) {
      m_mouseDragPoint = 1;
    }
    else {
      m_mouseDragPoint = 2;
    }
  };
  
  void mouseDragEvent(int x, int y) {
    if(m_mouseDragPoint == 1) {
      m_x1 = x;
      m_y1 = y;
    }
    else {
      m_x2 = x;
      m_y2 = y;
    }
  }
}
