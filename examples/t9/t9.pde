import pogopress.*;


// P_2_2_3_02.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * form mophing process by connected random agents
 * two forms: circle and line
 * 
 * MOUSE
 * click               : start a new circe
 * position x/y        : direction and speed of floating
 * 
 * KEYS
 * 1-2                 : fill styles
 * arrow up/down       : step size +/-
 * f                   : freeze. loop on/off
 * Delete/Backspace    : clear display
 * s                   : save png
 * r                   : start pdf recording
 * e                   : stop pdf recording
 */
import java.util.Calendar;
import processing.pdf.*;
import processing.serial.*;
import java.util.ArrayList;  
import java.util.List; 


static final String IP = "127.0.0.1";
static final int PORT = 20000;
private String mDataIn;
int mx;
int my;
int xnum=10;
int ynum=5;
int pointnum=xnum*ynum;

Mover[] movers = new Mover[pointnum];

//********************************************************************************** copy below to outside
//POGOPRESS:
//declear values, do not touch these
//TODO list for Sunday:
//--->
//2013/6/8 imp001:there is possible to accelerate the rate of processdata.
//2013/6/8 imp002:we could encapsulation these program to a class. Or pack to a Jar. Need callback.
//2013/6/8 imp003:we could deal with the situation of 40bytes packet.
//<---
Serial myPort;  // Create object from Serial class
PogoPress pogo;
int val;      // Data received from the serial port
List<Integer> ids = new ArrayList<Integer>();
int[][] result = new int[10][2];
//********************************************************************************** copy above to outside



void setup(){
  //********************************************************************************** copy below to setup()
  //POGOPRESS:
  //add a port, you should change the port in your computer, 
  //and add the id list you need listen

  String portName = myPort.list()[2];
  myPort = new Serial(this, portName, 115200);
  ids.add(17);
  pogo = new PogoPress(this, ids);
  //********************************************************************************** copy above to setup()
  // use fullscreen size 
  size(displayWidth-50, displayHeight-100);
  
  smooth();
  for (int j = 0; j < movers.length; j++) {
    movers[j] = new Mover(/*random(width),random(height),*/j+1,
                          random(255), random(255), random(255));
  }
  //璁剧疆鐐瑰垵濮嬩綅缃�  for(int i=1;i<ynum+1;i++){      //绗琲琛�    for(int j=1;j<xnum+1;j++){    //绗琷鍒�      movers[(i-1)*xnum+j-1].locationy=100*(i-1);//绾靛潗鏍�    }
  }
  for(int i=1;i<xnum+1;i++){     //绗琲鍒�    for(int j=1;j<ynum+1;j++){   //绗琷琛�      movers[(j-1)*xnum+i-1].locationx=100*(i-1);//妯潗鏍�    }
  }
  // init form
  background(255);
}

void draw(){
      noStroke();
      fill(0,8);
      rect(0,0,width,height);
      translate(180,130);
      if(mx>300&&mx<600&&mx>500&&my<800){
        movers[mx-1+(my-1)*xnum].pressure=1;
      }
      for (int n = 0; n < movers.length; n++) {
      stroke(0);
      fill(175);
      //movers[3].pressure=5;
      
        if(movers[n].pressure==1){
          if(movers[n].flag==1){
            movers[n].mouse();
          }
          if(true){
          movers[n].display();
          movers[n].keyPressed();
          movers[n].keyReleased();
          
          }
         }
       }
    for (int n = 0; n < movers.length; n++){
        if(movers[n].fade!=0)movers[n].fade--;
        else movers[n].pressure=0;
    }
}

void mousePressed(){
    /*
    for (int n = 0; n < movers.length; n++){
        if(movers[n].pressure==0){
          movers[n].pressure=1;
        }
    }
    for (int n = 0; n < movers.length; n++){
        if(movers[n].number%2+(int)random(6)==1){
          movers[n].pressure=0;
        }
    }
    */
    
    /*****************************
    *          鑾峰彇鍧愭爣          *
    *****************************/
    int fadenum=60;//娑堥�蹇參
    mx=mouseX/100;
    my=mouseY/100;
    if(mx>0&&my>0&&mx<11&&my<6){
    movers[mx-1+(my-1)*xnum].pressure=1;
    movers[mx-1+(my-1)*xnum].fade=fadenum;
    }
    //鍛ㄥ洿鐐�    if(mx>0&&my>0&&mx<11&&my<6){
    int i=mx-1+(my-1)*xnum;
      if(movers[i].pressure==1){
        if(i+1<50&&i%xnum!=9){
        movers[i+1].pressure=1;
        movers[i+1].fade=(int)random(fadenum);
        }
        if(i-1>-1&&i%xnum!=0){
        movers[i-1].pressure=1;
        movers[i-1].fade=(int)random(fadenum);
        }
        if(i-11>-1&&i%xnum!=0){
        movers[i-11].pressure=1;
        movers[i-11].fade=(int)random(fadenum);
        }
        if(i-10>-1){
        movers[i-10].pressure=1;
        movers[i-10].fade=(int)random(fadenum);
        }
        if(i-9>-1&&i%xnum!=9){
        movers[i-9].pressure=1;
        movers[i-9].fade=(int)random(fadenum);
        }
        if(i+9<50&&i%xnum!=0){
        movers[i+9].pressure=1;
        movers[i+9].fade=(int)random(fadenum);
        }
        if(i+10<50){
        movers[i+10].pressure=1;
        movers[i+10].fade=(int)random(fadenum);
        }
        if(i+11<50&&i%xnum!=9){
        movers[i+11].pressure=1;
        movers[i+11].fade=(int)random(fadenum);
        }
      }
    }
  
}

//********************************************************************************** copy below to outside
//POGOPRESS:
//add a listener, do not touch these
void serialEvent(Serial myPort) {
  val = myPort.read();
  result = pogo.getPogoData(val);
  for(int i=0;i<10;i++){
  	if(result[i][0]!=0){
    	  showRender(result[i][0],result[i][1]);
  	}
  }
}

//********************************************************************************** copy below to outside and finish it
//POGOPress: the function you should finish. The code below is an example. You just need to deal with the id and index.
void showRender(int id,int index){
    int fadenum=60;//娑堥�蹇參
    mx=(id+index)%10;
    my=(id*index)%5;
    if(mx>0&&my>0&&mx<11&&my<6){
    movers[mx-1+(my-1)*xnum].pressure=1;
    movers[mx-1+(my-1)*xnum].fade=fadenum;
    }
    //鍛ㄥ洿鐐�    if(mx>0&&my>0&&mx<11&&my<6){
    int i=mx-1+(my-1)*xnum;
      if(movers[i].pressure==1){
        if(i+1<50&&i%xnum!=9){
        movers[i+1].pressure=1;
        movers[i+1].fade=(int)random(fadenum);
        }
        if(i-1>-1&&i%xnum!=0){
        movers[i-1].pressure=1;
        movers[i-1].fade=(int)random(fadenum);
        }
        if(i-11>-1&&i%xnum!=0){
        movers[i-11].pressure=1;
        movers[i-11].fade=(int)random(fadenum);
        }
        if(i-10>-1){
        movers[i-10].pressure=1;
        movers[i-10].fade=(int)random(fadenum);
        }
        if(i-9>-1&&i%xnum!=9){
        movers[i-9].pressure=1;
        movers[i-9].fade=(int)random(fadenum);
        }
        if(i+9<50&&i%xnum!=0){
        movers[i+9].pressure=1;
        movers[i+9].fade=(int)random(fadenum);
        }
        if(i+10<50){
        movers[i+10].pressure=1;
        movers[i+10].fade=(int)random(fadenum);
        }
        if(i+11<50&&i%xnum!=9){
        movers[i+11].pressure=1;
        movers[i+11].fade=(int)random(fadenum);
        }
      }
    }
}
//********************************************************************************** copy below to outside and finish it

