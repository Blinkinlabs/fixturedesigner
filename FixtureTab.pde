
int fixtureRow;
int fixtureOffset;
int fixtureLength;

void setupFixtureTab() {
  int tabOffset = width - 200;
  
  cp5.addTab("Fixtures")
   .setActive(true)
   .activateEvent(true)
   .setId(FIXTURES_TAB)
   ;
   
  int yOffset = 30;
   
  cp5.addButton("loadFixtures")
     .setBroadcast(false)
     .setPosition(tabOffset,yOffset)
     .setSize(80,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("loadFixtures").moveTo("Fixtures");
  
  cp5.addButton("saveFixtures")
     .setBroadcast(false)
     .setPosition(tabOffset + 90,yOffset)
     .setSize(80,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("saveFixtures").moveTo("Fixtures");
  
  yOffset += 30;
  cp5.addTextfield("fixtureFilename")
     .setPosition(tabOffset,yOffset)
     .setSize(170,20)
     .setAutoClear(false)
     .setValue("fixtures")
     ;
  cp5.getController("fixtureFilename").moveTo("Fixtures");
   
  yOffset += 50;
  cp5.addButton("newLed")
     .setBroadcast(false)
     .setPosition(tabOffset,yOffset)
     .setSize(80,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("newLed").moveTo("Fixtures");
  
  cp5.addButton("newLedStrip")
     .setBroadcast(false)
     .setPosition(tabOffset + 90, yOffset)
     .setSize(80,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("newLedStrip").moveTo("Fixtures");
  
  yOffset += 40;
  cp5.addButton("deleteFixture")
     .setBroadcast(false)
     .setPosition(tabOffset,yOffset)
     .setSize(80,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("deleteFixture").moveTo("Fixtures");
  
  yOffset += 40;
  cp5.addSlider("fixtureRow")
   .setPosition(tabOffset,yOffset)
   .setRange(0,LEDscape_rows-1)
   ;
   cp5.getController("fixtureRow").moveTo("Fixtures");

  yOffset += 20;
  cp5.addSlider("fixtureOffset")
   .setPosition(tabOffset,yOffset)
   .setRange(0,LEDscape_cols-1)
   ;
   cp5.getController("fixtureOffset").moveTo("Fixtures");   

  yOffset += 20;
  cp5.addSlider("fixtureLength")
   .setPosition(tabOffset,yOffset)
   .setRange(0,LEDscape_cols-1)
   ;
   cp5.getController("fixtureLength").moveTo("Fixtures");
   
}

void selectFixture(Fixture fixture) {
  if(fixture instanceof Led) {
    Led led = (Led)fixture;
    cp5.getController("fixtureRow").setValue(led.m_row);
    cp5.getController("fixtureOffset").setValue(led.m_offset);
  }
  else if(fixture instanceof LedStrip) {
    LedStrip led = (LedStrip)fixture;
    cp5.getController("fixtureRow").setValue(led.m_row);
    cp5.getController("fixtureOffset").setValue(led.m_offset);
    cp5.getController("fixtureLength").setValue(led.m_length);
  }
}

public void newLed(int theValue) {
  g_fixtures.add(new Led(30, 30, 0, 0)); 
}

public void newLedStrip(int theValue) { 
  g_fixtures.add(new LedStrip(30, 30, 60, 60, 0, 0, 60)); 
}

public void deleteFixture(int theValue) {
  if(g_selectedFixture == null) {
    return;
  } 
  for (int i = 0; i < g_fixtures.size(); i++) {
    if(g_fixtures.get(i) == g_selectedFixture) {
      g_fixtures.remove(i);
      g_selectedFixture = null;
    }
  }
}

public void loadFixtures(int theValue) {
  String filename = cp5.get(Textfield.class,"fixtureFilename").getText() + ".json";
  g_fixtures = loadFixturesFromJson(filename);
}

public void saveFixtures(int theValue) {
  String filename = cp5.get(Textfield.class,"fixtureFilename").getText() + ".json";
  println(filename);
  saveFixturesToJson(filename, g_fixtures);
}

void fixtureRow(int row) {
  if(g_selectedFixture == null) {
    return;
  }
  
  if(g_selectedFixture instanceof Led) {
    Led led = (Led)g_selectedFixture;
    led.m_row = row;
  }
  else if(g_selectedFixture instanceof LedStrip) {
    LedStrip led = (LedStrip)g_selectedFixture;
    led.m_row = row;
  }
}

void fixtureOffset(int offset) {
  if(g_selectedFixture == null) {
    return;
  }
  
  if(g_selectedFixture instanceof Led) {
    Led led = (Led)g_selectedFixture;
    led.m_offset = offset;
  }
  else if(g_selectedFixture instanceof LedStrip) {
    LedStrip led = (LedStrip)g_selectedFixture;
    led.m_offset = offset;
  }
}

void fixtureLength(int len) {
  if(g_selectedFixture == null) {
    return;
  }
  
  if(g_selectedFixture instanceof LedStrip) {
    LedStrip led = (LedStrip)g_selectedFixture;
    led.m_length = len;
  }
}
