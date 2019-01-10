import java.util.*;
import java.io.*;

final int w = 800;
final int h = 400;
final int minColorOffset = 20;
final int minGrayOffset = 30;
public int prevR = 1000;
public int prevG = 1000;
public int prevB = 1000;


void setup () {
  noStroke();
  /*
  try {
    Scanner sc = new Scanner(new File("Flag_Bot/palette.txt")); 
    while (sc.hasNextLine()) {
      palette.add(sc.next());
      sc.nextLine();
    }
    sc.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  */
  rectMode(CORNERS);
  size(800,400);  
  Flag f = new Flag(); 
  save("output.png");
  exit();
}


class Flag {
  float seychelles;
  boolean vertStripes;
  boolean lTriOutcome;
  boolean symetrical;
  boolean southOccupied;
  boolean bars;
  int numStripes;
  int numSeychellesStripes;
  int starLocation;
  float lTri;
  float starStyle;
  boolean border;
  
  Flag() {
    numStripes = 0;
    numSeychellesStripes = 0;
    Random rand = new Random();
    seychelles = rand.nextFloat();
    lTri = rand.nextFloat();
    vertStripes = rand.nextBoolean();
    symetrical = rand.nextBoolean();
    numStripes = 1 + rand.nextInt(4);
    starStyle = rand.nextFloat();
    lTriOutcome = (lTri < .4 && !vertStripes && seychelles < 0.95);
    starLocation = -1;
    bars = (rand.nextBoolean() &&  numStripes == 1 && lTri > .4 && seychelles < 0.95);
    //border = true;//(rand.nextBoolean() && rand.nextBoolean() && rand.nextBoolean());
    
    
    
    if (vertStripes && numStripes == 4) numStripes --;
    if (seychelles < 0.95) {
      this.drawStripes();
    }
    else this.drawSeychelles();
    
    if (lTriOutcome) this.drawLTri();
    
    if (bars) {bars();}
    
    if (starStyle < .2) {
      singleStar();
    }
    else if (starStyle < .3) {
      ringOfStars();
    }
    else if (starStyle < .4 && (numStripes == 2 || seychelles >= .95) && !lTriOutcome) {
      constellation();
    }
    
    if (border) {border();}
 
  }
  
  void drawStripes() {
    int i = 0;
    int iterations = numStripes;
    if (vertStripes) {
      if (symetrical && numStripes > 2) {
        ArrayList<Integer> outerColor = getNextColor();
        fill(outerColor.get(0),outerColor.get(1),outerColor.get(2));
        rect(((float)i/numStripes)*w,0,(float)(i+1)/numStripes*w,h);
        i++;
        iterations--;
        fill(outerColor.get(0),outerColor.get(1),outerColor.get(2));
        rect(((float)iterations/numStripes)*w,0,(float)(iterations+1)/numStripes*w,h);
      }
      if (numStripes == 4 && symetrical) {
        ArrayList<Integer> rgb = getNextColor();
        fill(rgb.get(0),rgb.get(1),rgb.get(2));
        rect(((float)i/numStripes)*w,0,(float)(i+2)/numStripes*w,h);
      }
      else {
        while (i < iterations) {
          ArrayList<Integer> rgb = getNextColor();
          fill(rgb.get(0),rgb.get(1),rgb.get(2));
          rect(((float)i/numStripes)*w,0,(float)(i+1)/numStripes*w,h);
          i++;
        }
      }
      
    }
    else {
      if (symetrical && numStripes > 2) {
        ArrayList<Integer> outerColor = getNextColor();
        fill(outerColor.get(0),outerColor.get(1),outerColor.get(2));
        rect(0,(float)i/numStripes*h,w,(float)(i+1)/numStripes*h);
        i++;
        iterations--;
        fill(outerColor.get(0),outerColor.get(1),outerColor.get(2));
        rect(0,(float)iterations/numStripes*h,w,(float)(iterations+1)/numStripes*h);
      }
      if (numStripes == 4 && symetrical) {
        ArrayList<Integer> rgb = getNextColor();
        fill(rgb.get(0),rgb.get(1),rgb.get(2));
        rect(0,(float)i/numStripes*h,w,(float)(i+2)/numStripes*h);
      }
      else {
        while (i < iterations) {
          ArrayList<Integer> rgb = getNextColor();
          fill(rgb.get(0),rgb.get(1),rgb.get(2));
          rect(0,(float)i/numStripes*h,w,(float)(i+1)/numStripes*h);
          i++;
          } 
        }
      }
  }
  
  void drawSeychelles() {
    Random rand = new Random();
    boolean oneDiag = rand.nextBoolean(); 
    numSeychellesStripes = 3+rand.nextInt(5);
    if (oneDiag) numSeychellesStripes = 3;
    for (int i = 0; i < numSeychellesStripes; i++) {
      drawSeychellesStripes(i,numSeychellesStripes);
    }
  }
  
  void drawSeychellesStripes(int itr,int num) {
    PShape tri;
    tri = createShape();
    tri.beginShape();
    ArrayList<Integer> rgb = getNextColor();        
    tri.fill(rgb.get(0),rgb.get(1),rgb.get(2));
    tri.noStroke();
    float spacing = (float)(w+h)/((float)num);
    if (itr*spacing < h && (itr+1)*spacing > h) {
      System.out.println(itr*spacing);
      tri.vertex(0,h);
      tri.vertex(w,h-itr*spacing);
      tri.vertex(w,0);
      tri.vertex(w-((itr+1)*spacing),0);
    }
    else if (itr*spacing < h){
 
      tri.vertex(0,h);
      tri.vertex(w,h-(itr*spacing));
      tri.vertex(w,h-((itr+1)*spacing));
    }
    else if (itr*spacing > h){
      tri.vertex(0,h);
      tri.vertex(w-(itr*spacing),0);
      tri.vertex(w-((itr+1)*spacing),0);
    }
    else if (itr*spacing  == h) {
      tri.vertex(0,h);
      tri.vertex(w,0);
      tri.vertex(w-((itr+1)*spacing),0);
    }

    tri.endShape(CLOSE);
    shape(tri,0,0);
  }
  
  void drawLTri() {
    Random rand = new Random();
    float triWidthFloat = 2.5+rand.nextFloat()+rand.nextFloat();
    ArrayList<Integer> rgb = getNextColor();
    PShape tri;
    tri = createShape();
    tri.beginShape();
    tri.fill(rgb.get(0),rgb.get(1),rgb.get(2));
    tri.vertex(0,0);
    tri.vertex(w/triWidthFloat,h/2);
    tri.vertex(0,h);
    tri.endShape(CLOSE);
    shape(tri,0,0);
  }
  
  
  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  
  void singleStar() {
    fill(255);
    Random rand = new Random();
    if (lTriOutcome) {
      star(w/9,h/2,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
    }
    else if (numStripes == 2 && seychelles < .95) {
      starLocation = rand.nextInt(3);
      switch (starLocation) {
        case 0: star(w/2,h/4,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;
        case 1: star(w/2,h/2,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;
        case 2: star(w/2,3*(h/2),rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;  
      }
    }
    else if (numSeychellesStripes == 3) {
      starLocation = rand.nextInt(3);
      switch (starLocation) {
        case 0: star(w/4,h/3,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;
        case 1: star(w/2,h/2,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;
        case 2: star(3*(w/4),2*(h/3),rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
          break;  
      }
    }
    else star(w/2,h/2,rand.nextInt(20),10+rand.nextInt(20),4+rand.nextInt(6));
  }
  
  void ringOfStars() {
    fill(255);
    Random rand = new Random();
    int cx = w/2;
    int cy = h/2;
    int numStars = 4 + rand.nextInt(12);
    int circleRadius = 50 + rand.nextInt(60);
    int rad1 = 5;
    int rad2 = 10 + rand.nextInt(5);
    int numPoints = 4+rand.nextInt(4);
    float angleDiff = (float)TWO_PI/(float)numStars;
    for (int i = 0; i < numStars; i++) {
      star(cx+circleRadius*cos(i*angleDiff),cy-circleRadius*sin(i*angleDiff),rad1,rad2,numPoints);
    }
  }
  
  void constellation() {
    fill(255);
    Random rand = new Random();
    int numStars = 5 + rand.nextInt(5);
    int constWidth=0;
    int constHeight=0;
    int startX=0;
    int startY=0;
    boolean sameStar = rand.nextBoolean();
    if ((seychelles >= .95 && numSeychellesStripes == 3) || numStripes == 2) {
      if (seychelles >= .95 && numSeychellesStripes == 3) {
        startX=0;
        startY=0;
        constWidth = w;
        constHeight = h;
      }
      else if (numStripes == 2 && vertStripes) {
        starLocation = rand.nextInt(3);
        switch (starLocation) {
          case 0:
            startX=0;
            startY=0;
            constWidth = w;
            constHeight = h;
            break;
          case 1:
            startX=0;
            startY=0;
            constWidth = w/2;
            constHeight = h;
            break;
          case 2:
            startX=w/2;
            startY=0;
            constWidth = w/2;
            constHeight = h;
            break;
        }
      }
      else if (numStripes == 2) {
        starLocation = rand.nextInt(3);
        switch (starLocation) {
          case 0:
            startX=0;
            startY=0;
            constWidth = w;
            constHeight = h;
            break;
          case 1:
            startX=0;
            startY=0;
            constWidth = w;
            constHeight = h/2;
            break;
          case 2:
            startX=0;
            startY=h/2;
            constWidth = w;
            constHeight = h/2;
            break;
        }
      }
    }
    else {
      constWidth=h;
      constHeight=w;
    }
    int rad1 = 12;
    int rad2 = 24 + rand.nextInt(10);
    int numPoints = 4+rand.nextInt(4);
    for (int i = 0; i < numStars;i++) {
      if (sameStar) 
        star(startX + rand.nextInt(constWidth), startY + rand.nextInt(constHeight), rad1,rad2,numPoints);
      else 
        star(startX + rand.nextInt(constWidth), startY + rand.nextInt(constHeight), 5,10 + rand.nextInt(5),4+rand.nextInt(4));
    }
  }
  
  void bars() {
    Random rand = new Random();
    int barStyle = rand.nextInt(6);
    int X = w/4 + rand.nextInt(w/2);
    int Y = h/4 + rand.nextInt(h/2);
    boolean twoTone = rand.nextBoolean() && rand.nextBoolean();
    float thickness = w/15 + (w/15)*rand.nextFloat();
    float twoToneThickness = thickness - 20;//thickness*(float)(4/5);
    ArrayList<Integer> primary = getNextColor();
    ArrayList<Integer> secondary = getNextColor();
    
    switch (barStyle) {
      case 0: //single vertical
        drawBar(X,0,X,h,primary.get(0),primary.get(1),primary.get(2),thickness);
        if (twoTone) {
          drawBar(X,0,X,h,primary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
        }
        break;
      case 1: //single horizontal
        drawBar(0,Y,w,Y,primary.get(0),primary.get(1),primary.get(2),thickness);
        if (twoTone) {
          drawBar(0,Y,w,Y,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
        }
        break;
      case 2: //diag
        drawBar(-20,-10,w+20,h+10,primary.get(0),primary.get(1),primary.get(2),thickness);
        if (twoTone) {
          drawBar(-20,-10,w+20,h+10,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
        }
        break;
      case 3: //double vertical
        drawBar(w-X,0,w-X,h,primary.get(0),primary.get(1),primary.get(2),thickness);
        drawBar(X,0,X,h,primary.get(0),primary.get(1),primary.get(2),thickness);
        if (twoTone) {
          drawBar(w-X,0,w-X,h,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
          drawBar(X,0,X,h,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
        }
        break;
      case 4: //double horizontal
        drawBar(0,h-Y,w,h-Y,primary.get(0),primary.get(1),primary.get(2),thickness);
        drawBar(0,Y,w,Y,primary.get(0),primary.get(1),primary.get(2),thickness);
        if (twoTone) {
          drawBar(0,h-Y,w,h-Y,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
          drawBar(0,Y,w,Y,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
        }
        break;
      case 5: //cross
        if (!(starStyle >=.2 && starStyle < .3))
        {
          drawBar(X,0,X,h,primary.get(0),primary.get(1),primary.get(2),thickness);
          drawBar(0,Y,w,Y,primary.get(0),primary.get(1),primary.get(2),thickness);
          if (twoTone) {
            drawBar(X,0,X,h,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
            drawBar(0,Y,w,Y,secondary.get(0),secondary.get(1),secondary.get(2),twoToneThickness);
          }
           break;
        }
    } 
  }
  
  void drawBar(int startX, int startY, int endX, int endY, int r, int g, int b, float thickness) {
    stroke(r,g,b);
    strokeWeight(thickness);
    line(startX,startY,endX,endY);
    noStroke();
  }
  
  void border() {
    Random rand = new Random();
    float thickness = w/14 + (w/14)*rand.nextFloat();
    ArrayList<Integer> borderColor = getNextColor();
    drawBar(0,0,w,0,borderColor.get(0),borderColor.get(1),borderColor.get(2),thickness);
    drawBar(w,0,w,h,borderColor.get(0),borderColor.get(1),borderColor.get(2),thickness);
    drawBar(w,h,0,h,borderColor.get(0),borderColor.get(1),borderColor.get(2),thickness);
    drawBar(0,h,0,0,borderColor.get(0),borderColor.get(1),borderColor.get(2),thickness);
  }
  
  
  ArrayList<Integer> getNextColor() {
    Random rand = new Random();
    int r,g,b;
    do {
      r = rand.nextInt(256);
      g = rand.nextInt(256);
      b = rand.nextInt(256);
    }
    while (Math.abs(r-prevR) < minColorOffset || Math.abs(g - prevG) < minColorOffset || Math.abs(b-prevB) < minColorOffset);
    if (Math.abs(r-g) < minGrayOffset && Math.abs(g-b) < minGrayOffset) {
      if (r < 96) {r=0;g=0;b=0;}
      else {r=255;g=255;b=255;}
    }
    ArrayList<Integer> rgb = new ArrayList<Integer>();
    rgb.add(r);
    rgb.add(g);
    rgb.add(b);
    prevR = r;
    prevG = g;
    prevB = b;
    return rgb;
  }
}
