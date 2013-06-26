class Mover{
  Point point=new Point();
  float number=point.number;
  float pressure=point.pressure;
  int fade=point.fade=10;  //消逝
  float locationx;
  float locationy;
  float red;
  float green;
  float blue;
  int s1=second();
  boolean recordPDF = false;

  int flag=1;//开始标记
  int formResolution = (int)random(15,50);
  int stepSize = 1;//发展剧烈程度
  float distortionFactor = 22;
  float initRadius =random(50,70);//初始半径
  float centerX, centerY;
  float[] x = new float[formResolution];
  float[] y = new float[formResolution];

  boolean filled = false;
  boolean freeze = false;
  int mode=0;
  
  //构造方法
  Mover(/*float x,float y,*/int n,float r,float g,float b){
    mode=0;
    number=n;
    red=r;
    green=g;
    blue=b;
  }
  void display(){
      centerX=locationx;
      centerY=locationy;
      int pel=50;//透明度
      float speed=(int)(random(3,7));//速度
      //加速
      if(pel<60){
         pel+=5;
      }
        // floating towards mouse position
        if (mouseX != 0 || mouseY != 0) {
          centerX += random(-speed,speed);
          centerY += random(-speed,speed);
          stroke((red++)%255,green,blue, pel);
        }
    
        // calculate new points
        for (int i=0; i<formResolution; i++){
          x[i] += random(-stepSize,stepSize);
          y[i] += random(-stepSize,stepSize);
          // ellipse(x[i], y[i], 5, 5);
        }
        strokeWeight(1.25);
        if (filled) fill(random(255));
        else noFill();
    
        if (mode == 0) {
          beginShape();
          // start controlpoint
          curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
          // only these points are drawn
          for (int i=0; i<formResolution; i++){
            curveVertex(x[i]+centerX, y[i]+centerY);
          }
          curveVertex(x[0]+centerX, y[0]+centerY);
      
          // end controlpoint
          curveVertex(x[1]+centerX, y[1]+centerY);
          endShape();
          //mode=1;
          }
          flag=0;
  }
  
  void mouse() {
    //if(mousePressed){
        float angle = radians(360/float(formResolution));
        float radius = initRadius * random(0.5,0.7);
        for (int i=0; i<formResolution; i++){
          x[i] = cos(angle*i) * radius;
          y[i] = sin(angle*i) * radius;
        }
     // }
  }
  
  void keyPressed() {
    if (keyCode == UP) stepSize++;
    if (keyCode == DOWN) stepSize--;
    stepSize = max(stepSize, 1);
    //println("stepSize: " + stepSize);
  }
  
  void keyReleased() {
    if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
    if (key == DELETE || key == BACKSPACE||s1==10) background(0);
  
    if (key == '1') filled = false;
    if (key == '2') filled = true;
    if (key == '3') mode = 0;
  
    // switch draw loop on/off
    if (key == 'f' || key == 'F') freeze = !freeze;
    if (freeze == true) noLoop();
    else loop();
  }
  // timestamp
  String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}

