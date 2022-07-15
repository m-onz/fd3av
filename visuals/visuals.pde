
PImage [] img = new PImage[3];

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int pulse = 0;

void setup() {
  size(1024, 768);
  frameRate (20);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  
  for (int i=0; i<img.length; i++) {
    img[i] = loadImage((i+1)+".jpg");
  }
}

void draw() {
  background(0);
  text(""+pulse, width/2, height/2);
  image(img[pulse % 3], 0, 0);
  //filter(INVERT);
  filter(ERODE);
  //filter(DILATE);
  //filter(POSTERIZE, 2);
}

void oscEvent(OscMessage theOscMessage) {  
  if(theOscMessage.checkAddrPattern("/pulse")==true) {
    //println("pulse received");
    pulse++;
  } 
}
