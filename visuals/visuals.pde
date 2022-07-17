
import com.hamoid.*;

VideoExport videoExport;

PShader edges;
PShader deform;

PImage [] img = new PImage[38];
PImage logoWhite = new PImage();
PImage logoBlack = new PImage();

boolean invertLogo = false;

float logoScale;
int logoWidth;
int logoHeight;

int shadowOffset;
int colorSelect;
int filterSelect;

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
  size(1920, 1080, P3D);
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
  
  shadowOffset = 5;
  colorSelect = 0;
  filterSelect = 0;
  edges = loadShader("edges.glsl");
  deform = loadShader("deform.glsl");
  deform.set("resolution", float(width), float(height));
  textureWrap(REPEAT);
  
  videoExport = new VideoExport(this);
  videoExport.setQuality(100, 128);
  videoExport.startMovie();
}

void draw() {
  //deform.set("time", millis() / noise(frameCount*3000)*999);
  //deform.set("mouse", 
  //  noise(frameCount*PI/300)*width, 
  //  noise(frameCount*PI/2000)*height
  //  );
  
  background(32);
  
  pushStyle();
  pushMatrix();
  rotateX(noise(frameCount*PI/2000));
  //if (millis() > 11000) 
  //shader(deform);
  translate(0, -100, -200);
  //translate(0, -100, 200);
  image(img[pulse % img.length], width/2, height/2);
  
  popMatrix();
  popStyle();
   
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
  
  //switch(colorSelect) {
  // case 0:
  //   fill(c1);
  //   invertLogo = true;
  // break;
  //  case 1:
  //   fill(c2);
  //   invertLogo = true;
  // break;
  //  case 2:
  //   fill(c3);
  //   invertLogo = true;
  // break;
  //  case 3:
  //   fill(c4);
  //   invertLogo = false;
  // break;   
  //}
  
  fill(c4);
  
  noStroke();
  
  /*
  switch(filterSelect) {
    case 0:
      if (random(100) > 90) filter(THRESHOLD);
    break;
    case 1:
      if (random(100) > 90) filter(GRAY);
    break;
    case 2:
      if (random(100) > 90) filter(INVERT);
    break;
    case 3:
      if (random(100) > 90) filter(POSTERIZE, 2);
    break;
    case 4:
      if (random(100) > 90) filter(POSTERIZE, 5);
    break;
    case 5:
      if (random(100) > 90) filter(ERODE);
    break;
    case 6:
      if (random(100) > 90) filter(DILATE);
    break;
    default:
  }
  */
  translate(0, 0, 200);
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
  
  filter(edges);
  
  videoExport.saveFrame();
}

void oscEvent(OscMessage theOscMessage) {  
  if(theOscMessage.checkAddrPattern("/pulse")==true) {
    //println("pulse received");
    nextTick ();
  } 
}

void mousePressed () {
  nextTick ();
}

void nextTick () {
  pulse++;
  colorSelect = (int) random(4);
  if (random(100) > 90) {
    filterSelect = (int) random(8);
  }
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
