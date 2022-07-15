
PImage [] img = new PImage[38];
PImage logoWhite = new PImage();
PImage logoBlack = new PImage();

boolean invertLogo = false;

float logoScale;
int logoWidth;
int logoHeight;

int colorSelect;

color c1 = color(255, 198, 170);
color c2 = color(226, 217, 23);
color c3 = color(51, 187, 110);
color c4 = color(32, 32, 32);

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int pulse = 0;

void setup() {
  size(1024, 768, P3D);
  frameRate (20);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  
  for (int i=0; i<img.length; i++) {
    img[i] = loadImage((i+1)+".jpg");
  } 
  
  logoWhite = loadImage("fakedac-logo-white.tif");
  logoBlack = loadImage("fakedac-logo-black.tif");
  
  logoScale = 9;
  logoWidth = logoWhite.width / (int) logoScale;
  logoHeight = logoWhite.height / (int) logoScale;
  
  imageMode(CENTER);
  
  colorSelect = 0;
}

void draw() {
  background(32);
  text(""+pulse, width/2, height/2);
  image(img[pulse % img.length], width/2, height/2);
  
  //filter(INVERT);
  //filter(ERODE);
  //filter(DILATE);
  //filter(POSTERIZE, 2);
  
  int shadowOffset = 5;
  
  pushMatrix();
  pushStyle();
  //if (random(100)>90) rotateZ(random(1));
  
  fill(11);
  noStroke();
  rect(width/2 - (logoWidth/2) + shadowOffset, height/2 - (logoHeight/2) + shadowOffset, logoWidth, logoHeight);
  
  //fill(32);
  //fill(255, 198, 170);
  //fill(226, 217, 23);
  //fill(51, 187, 110);
  
  switch(colorSelect) {
   case 0:
     fill(c1);
     invertLogo = true;
   break;
    case 1:
     fill(c2);
     invertLogo = true;
   break;
    case 2:
     fill(c3);
     invertLogo = true;
   break;
    case 3:
     fill(c4);
     invertLogo = false;
   break;   
  }
  
  noStroke();
  rect(width/2 - (logoWidth/2), height/2 - (logoHeight/2), logoWidth, logoHeight);

  if (invertLogo) {
    image (logoBlack, width/2, height/2, logoWidth, logoHeight);
  } else {
    image (logoWhite, width/2, height/2, logoWidth, logoHeight);
  }
  
  
  popStyle();
  popMatrix();
  
  //logoScale = noise(frameCount*PI/300)*40;
  //logoWidth = logoWhite.width / (int) logoScale+1;
  //logoHeight = logoWhite.height / (int) logoScale+1;
}

void oscEvent(OscMessage theOscMessage) {  
  if(theOscMessage.checkAddrPattern("/pulse")==true) {
    //println("pulse received");
    pulse++;
    colorSelect = (int) random(4);
  } 
}

void mousePressed () {
  pulse++;
  colorSelect = (int) random(4);
}
