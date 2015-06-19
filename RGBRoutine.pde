class Routine {
  public boolean isDone = false;
  
  void reset() {}
  void draw(PGraphics frame) {}
}


class RGBRoutine extends Routine {
  int color_angle = 0;
  
  void draw(PGraphics frame) {
    background(0);
  
    for (int row = 0; row < frame.height; row++) {
      for (int col = 0; col < frame.width; col++) {
        float r = (((row)*2          + 100.0*col/frame.width   + color_angle  +   0)%100)*(255.0/100);
        float g = (((row)*2          + 100.0*col/frame.width   + color_angle  +  33)%100)*(255.0/100);
        float b = (((row)*2          + 100.0*col/frame.width   + color_angle  +  66)%100)*(255.0/100);
        
        frame.stroke(r,g,b);
        frame.point(col,row);
      }
    }
    
    color_angle = (color_angle+1);//%255;
  }
}

class ColorDrop extends Routine {
  void draw(PGraphics frame) {
    background(0);
  
    float frame_mult = 6;  // speed adjustment
  
    // lets add some jitter
//    modeFrameStart = modeFrameStart - min(0,int(random(-5,12)));
//    long frame = frameCount - modeFrameStart;

    long f = frameCount;
    
    
    for(int row = 0; row < frame.height; row++) {
      float phase = sin((float)((row+f*frame_mult)%frame.height)/frame.height*3.146 + random(0,.6));
      
      float r = 0;
      float g = 0;
      float b = 0;
      
      
      if((row+f*frame_mult)%(6*frame.height) < frame.height) {
        r = 255*phase;
        g = 0;
        b = 0;
      }
      else if((row+f*frame_mult)%(6*frame.height) < frame.height*2) {
        r = 0;
        g = 255*phase;
        b = 0;
      }
      else {
        r = 0;
        g = 0;
        b = 255*phase;
      }
      
      frame.stroke(r,g,b);
      frame.line(0, row, frame.width, row);
    }
  }

}

class Bursts extends Routine {
  int NUMBER_OF_BURSTS = 300;
  Burst[] bursts;

  void setup() {
    bursts = new Burst[NUMBER_OF_BURSTS];
    for (int i = 0; i<NUMBER_OF_BURSTS; i++) {
      bursts[i] = new Burst();
    }
  }

  void reset() {
    setup();
  }
  
  void draw(PGraphics frame)
  {
      frame.background(0,0,20);
  
    for (int i=0; i<NUMBER_OF_BURSTS; i++) {
      bursts[i].draw(frame);
    }
  }
}


class Burst {
  float x;
  float y;
  float xv;
  float yv;
  float d;
  float maxd;
  float speed;
  int intensity;
  
  float r;
  float g;
  float b;

  public Burst()
  {
    init();
  }

  public void reset()
  {
    r = random(128)+128;
    g = random(128)+128;
    b = random(128)+128;
    //r = random(128);
    //g = random(118);
    //b = random(128);
   
    x = random(displayWidth);
    y = random(displayHeight);

    float max_speed = 2;
    xv = random(max_speed) - max_speed/2;
    yv = random(max_speed) - max_speed/2;
    
    maxd = random(6);
    speed = random(5)/10 + 0.4;
    d = 0;
    intensity = 255;
  }

  public void init()
  {
    reset();
  }
  
  public void draw_ellipse(PGraphics frame, float x, float y, float widt, float heigh, color c) {
    while(widt > 1 && heigh > 1) {
      float target_brightness = random(.8,1.5);
      c = color(red(c)*target_brightness, green(c)*target_brightness, blue(c)*target_brightness);
      frame.fill(c);
      frame.stroke(c);
      frame.ellipse(x, y, widt, heigh);
      widt -= 1;
      heigh -= 1;
    }
  }
  
  public void draw(PGraphics frame)
  {    
    // Draw multiple elipses, to handle wrapping in the y direction.
    draw_ellipse(frame,x, y,       d*(.5-.3*y/displayHeight), d*3, color(r,g,b));
    draw_ellipse(frame,x-displayWidth, y, d*(.5-.3*y/displayHeight), d*3, color(r,g,b));
    draw_ellipse(frame,x+displayWidth, y, d*(.5-.3*y/displayHeight), d*3, color(r,g,b));
    
    d+= speed;
    if (d > maxd) {
      // day
      r -= 2;
      g -= 2;
      b -= 2;
      intensity -= 15;
      //night
//      r -= 1;
//      g -= 1;
//      b -= 1;
//      intensity -= 3;
    }
    
    // add speed, try to scale slower at the bottom...
    x +=xv*(displayHeight - y/3)/displayHeight;
    y +=yv*(displayHeight - y/3)/displayHeight;

    if (intensity <= 0) {
      reset();
    }
  }
}

class RainbowColors extends Routine {
  void draw(PGraphics frame) {
    long f = frameCount;
  
  //  print(mouseY*255.0/displayHeight);
  //  print(" ");
    
    colorMode(HSB, 100);
    
    for(int x = 0; x < displayWidth; x++) {
      for(int y = 0; y < displayHeight; y++) {
        if (x < displayWidth/2) {
          stroke((pow(x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        else {
          stroke((pow(displayWidth-x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        point((x+frameCount)%displayWidth,y);
      }
    }
    
    colorMode(RGB, 255);
  }
}
