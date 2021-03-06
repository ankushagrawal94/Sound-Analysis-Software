/*
 * @Author:  Ankush Agrawal
 * @Email:   ankushagrawal94@yahoo.com
 * Description: This code reads input from my local micrphone 
 *             and performs an FFT analysis using the Minim library.
 *             It determines frequencies based on this and then 
 *             later amplifies the output based on a beat detection
 *             algorithm within.
 */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
BeatDetect beat;


int red = 0;      //Used to control the red RGB value
int green = 0;    //Used to control the green RGB value
int blue = 0;     //Used to control the blue RGB value
boolean beatDetected;  //Used to keep track of when a beat was detected
float heightOfBar;     //Height of the bar corresponding to each frequency
int baseHeight = 20;   //Default base height of bars
int amplification = 32;//Amplification factor
int numLowBars = 0;    //Keeps track of the number of bars that are below a threshold
int numHighBars = 0;

void setup()
{
  size(1000, 600);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(in.left.size(), 44100);
  beat = new BeatDetect();
}

void draw()
{
  colorMode(RGB);  
  background(0);             //Used to reset the output to a plain screen
  fft.forward(in.left);      //Used to read in and analyze input
  strokeWeight(8);           //The width of each "bar"
  stroke(red, green, blue);  //Assign the color for the bars
  beatDetected = false;      //reset the value
  beat.detect(in.mix);       //check for a beat
  if (beat.isOnset())
     beatDetected = true;    //set beatDetected flag to true
  if(numLowBars > fft.specSize()*.4)
  {
    amplification += 10;
    println("amplification increased");
  }
  if(numHighBars > fft.specSize()*.10)
  {
    amplification -= 10;
    println("amplification decreased");
  }
  numHighBars = 0;
  numLowBars = 0;
  //Work on making the color get progrssively higher as we go to the top
  for(int i = fft.specSize()*1/4; i < fft.specSize()*3/4; i++)
  {
    blue = 100;    //reset the value of red for each iteration of the loop
    heightOfBar = fft.getBand(i) * amplification;
    if(heightOfBar < (.2)*(height))
      numLowBars++;
    if(heightOfBar > (.9)*(height))
      numHighBars++;
    if(beatDetected = true)
      heightOfBar *= 2;                      //amplify all signals on beat detection
    blue = (int)(heightOfBar/4) + 100;        //make the shade of red a function of heightOfBar
    stroke(red, green, blue);
    line(i-fft.specSize()*1/4, height, i-fft.specSize()*1/4, height - heightOfBar);  //The 160 offset gets rid of a lot of extreme peaks you get on the left side
  }
}

void stop()
{
  minim.stop();
  super.stop();
}
