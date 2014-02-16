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
boolean beatOn;

int red=0;
int green = 0;
int blue = 0;

float heightOfBar;

void setup()
{
  size(1200, 600);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(in.left.size(), 44100);
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
}

void draw()
{
  colorMode(RGB);  
  background(0);
  fft.forward(in.left);
  
  strokeWeight(8);
  stroke(red, green, blue);
  
  beatOn = false;
  beat.detect(in.mix);
  if ( beat.isOnset() )
     beatOn = true;
  for(int i = 0; i < fft.specSize(); i++)
  {
    red = 50;
    green = 0;
    blue = 0;
    heightOfBar = fft.getBand(i)*8;
    //amplify all signals on beat detection
    if(beatOn = true)
      heightOfBar *= 2;
    //make the shade of red a function of heightOfBar
    if (heightOfBar > height/1.5)
    {
      red = 255;
    }
    else if (heightOfBar > height/2)
    {
      red = 150;
    }
    else
    {
      red = 100;   
    }
    //The 160 offset gets rid of a lot of extreme peaks you get on the left side
    stroke(red, green, blue);
    line(i-160, height, i-160, height - heightOfBar);
    //line(i-160, height-heightOfBar-10, i-160, height - heightOfBar); //highlight the peaks
    
  }
}

void stop()
{
  minim.stop();
  super.stop();
}
