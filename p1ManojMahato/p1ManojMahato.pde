import java.util.Date;
import processing.sound.*;

final String[] days = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
final String[] monts = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Ago", "Oct", "Nov", "Dec"};
final int BLUE_COLOR = color(154, 202, 255);
final int BLACK_COLOR = color(33, 33, 33);
SoundFile buttonSound;
SoundFile runningSound;
SoundFile doneSound;
PFont font;
Date date;

ArrayList<Page> listPages;
int menu = 0;

void setup() {
  size(400, 720);
  font = createFont("Helvetica", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  buttonSound = new SoundFile(this, "button.mp3");
  runningSound = new SoundFile(this, "running.mp3");
  doneSound = new SoundFile(this, "done.wav");
  init();
}

void init() {
  date = new Date();
  listPages = new ArrayList();
  listPages.add(new Home());
}

void draw() {
  background(33, 33, 33);
  listPages.get(menu).Show();
}

void ButtonEvent(Button b) {
  listPages.get(menu).Event(b);
} 

void mousePressed() {
  listPages.get(menu).mousePressed();
}

void mouseReleased() {
  listPages.get(menu).mouseReleased();
}

void keyPressed() {
  if (key=='r') {
    init();
  }
}

class Button {

  // Properties
  int width;
  int height;
  int posX;
  int posY;
  String title;
  int textSize;
  int textLeading;
  boolean pressed = false;
  boolean enable = true;
  boolean disabled = false;

  // Colors
  int text = color(255);
  int border = color(255);
  int background = BLACK_COLOR;

  Button(String t, int w, int h, int x, int y) {
    title = t;
    width = w;
    height = h;
    posX = x;
    posY = y;
    textSize = 21;
    textLeading = 20;
  }

  boolean MouseHover() {
    if (mouseX>posX && mouseX<posX+width) {
      if (mouseY>posY && mouseY<posY+height) {
        return true;
      }
    }
    return false;
  }

  void mousePressed() {
    if (disabled || !enable)return;
    if (MouseHover()) {
      pressed=true;
      buttonSound.play();
    } else {
      pressed=false;
    }
  }

  void mouseReleased() {
    if (disabled || !enable)return;
    if (pressed && MouseHover()) {
      ButtonEvent(this);
    }
    pressed=false;
  }

  void Show() {
    if (!enable)return;
    push();
    translate(posX, posY);
    stroke(border);
    if (!pressed) {
      fill(background);
    } else {
      fill(text);
    }
    rect(0, 0, width, height, 5);

    translate(width/2, height/2);
    textAlign(CENTER, CENTER);
    if (!pressed) {
      fill(text);
    } else {
      fill(background);
    }
    textSize(textSize);
    textLeading(textLeading);
    text(title, 0, -2);
    pop();
  }
}

class Home extends Page {
  boolean progress = false;
  int hours;
  String meridiem = "AM";

  int time = 0;
  int startTime = millis();
  int currentTime = millis();
  int pauseTime = 0;
  boolean pause = false;
  boolean done = false; 
  int levelPower = 10;

  int mode = 0;
  String modeTitle = "Express Cook";

  Home() {

    // 0
    listButtons.add(new Button("1", 85, 50, 60, 290));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("2", 85, 50, 160, 290));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("3", 85, 50, 260, 290));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);

    listButtons.add(new Button("4", 85, 50, 60, 355));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("5", 85, 50, 160, 355));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("6", 85, 50, 260, 355));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);

    listButtons.add(new Button("7", 85, 50, 60, 420));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("8", 85, 50, 160, 420));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("9", 85, 50, 260, 420));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);

    listButtons.add(new Button("Set\nClock", 85, 50, 60, 485));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    listButtons.add(new Button("0", 85, 50, 160, 485));
    getLastButton().text = BLACK_COLOR;
    getLastButton().background = color(255);
    listButtons.add(new Button("Power\nLevel", 85, 50, 260, 485));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    // 12

    // 12
    listButtons.add(new Button("POP CORN", 130, 60, 60, 290));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    listButtons.add(new Button("POTATO", 130, 60, 210, 290));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;

    listButtons.add(new Button("REHEAT", 130, 60, 60, 365));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    listButtons.add(new Button("DEFROST", 130, 60, 210, 365));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;

    listButtons.add(new Button("SOFTEN", 130, 60, 60, 440));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    listButtons.add(new Button("COOK TIME", 130, 60, 210, 440));
    getLastButton().text = BLUE_COLOR;
    getLastButton().border = BLUE_COLOR;
    // 18

    for (Button btn : getRangeButtons(12, 18)) {
      btn.enable = false;
    }

    listButtons.add(new Button("Preset", 110, 60, 20, height-10-80));
    getLastButton().text=BLUE_COLOR;
    getLastButton().border=BLUE_COLOR;
    getLastButton().background = BLACK_COLOR;
    getLastButton().textLeading=25;
    listButtons.add(new Button("STOP\n/Cancel", 110, 60, width/3+12, height-10-80));
    getLastButton().border=color(255, 0, 0);
    getLastButton().background=color(255, 0, 0);
    getLastButton().textLeading=25;
    listButtons.add(new Button("START\n/+30 Sec.", 110, 60, width/3*2+5, height-10-80));
    getLastButton().text=BLACK_COLOR;
    getLastButton().border=color(255);
    getLastButton().background=color(255);
    getLastButton().textLeading=25;
  }

  void Show() {
    if (!pause) {
      currentTime = millis();
    }

    if (!progress && !done) {
      fill(255);
      textSize(15);
      text(days[date.getDay()]+" "+monts[month()-1]+" "+day()+" "+year(), width/2, 80);

      hours = hour();
      if (hours>12) {
        hours-=12;
        meridiem = "PM";
      } else {
        meridiem = "AM";
      }
      String hT;
      String mT;
      if (hours<10) {
        hT = "0"+hours;
      } else {
        hT = ""+hours;
      }
      if (minute()<10) {
        mT = "0"+minute();
      } else {
        mT = ""+minute();
      }

      textSize(50);
      text(hT+":"+mT, width/2, 110);

      textSize(18);
      text(meridiem, width/2+80, 115);
      text("PL - "+levelPower, width/2, 145);
    } else if (done) {
      ellipseMode(CENTER);
      noStroke();

      fill(BLUE_COLOR);
      ellipse(width/2, 80, 90, 90);

      fill(BLACK_COLOR);
      ellipse(width/2, 80, 80, 80);

      pushStyle();
      stroke(BLUE_COLOR);
      strokeWeight(5);
      line(width/2-20, 80, width/2-5, 95);
      line(width/2-5, 95, width/2+25, 70);
      
      popStyle();

      fill(255);
      textSize(22);
      text("Done!", width/2, 150);

      fill(255);
      textSize(14);
      text("Time cook complete.", width/2, 175);
    } else {
      ellipseMode(CENTER);
      noStroke();

      fill(255);
      ellipse(width/2, 120, 150, 150);

      push();
      translate(width/2, 120);
      rotate(radians(-90));
      fill(BLUE_COLOR);
      arc(0, 0, 150, 150, map(currentTime, startTime, time, 0, TWO_PI), TWO_PI);
      pop();

      fill(BLACK_COLOR);
      ellipse(width/2, 120, 130, 130);

      int h = ((time-currentTime)/1000)/60;
      int s = ((time-currentTime)/1000)%60;
      String hT;
      String sT;
      if (h<10) {
        hT = "0"+h;
      } else {
        hT = ""+h;
      }
      if (s<10) {
        sT = "0"+s;
      } else {
        sT = ""+s;
      }
      fill(255);
      textSize(40);
      text(hT+":"+sT, width/2, 115);
      
      if (time<currentTime) {
        progress=false;
        done=true;
        doneSound.play();
        stopOven();
      }

      if (pause) {
        textSize(18);
        text("Paused", width/2, 145);
      }
      textSize(16);
      text("PL - " + levelPower, width/2, 90);
    }

    fill(255);
    textSize(16);
    text(modeTitle, width/2, 260);
    super.Show();
  }
  
  void runOven() {
    progress=true;
    done=false;
    pause=false;
    if(!runningSound.isPlaying()){
      runningSound.play();
    }
  }
  
  void stopOven() {
    if(runningSound.isPlaying()){
      runningSound.stop();
    }
  }

  void Event(Button b) {
    try {
      int v = Integer.parseInt(b.title);
      if (v==0)return;
      time = v * 60 * 1000 + 1000 + millis();
      startTime = millis();
      levelPower = 10;
      runOven();
      return;
    }
    catch(Exception e) {
    }

    switch(b.title) {
    case "POP CORN":
      levelPower = 10;
      time = 4 * 1000 * 60 + 1000 + millis();
      startTime = millis();
      runOven();
      break;
    case "POTATO":
      levelPower = 6;
      time = 5 * 1000 * 60 + 1000 + millis();
      startTime = millis();
      runOven();
      break;
    case "REHEAT":
      levelPower = 4;
      time = 2 * 1000 * 60 + 1000 + millis();
      startTime = millis();
      runOven();
      break;
    case "DEFROST":
      levelPower = 3;
      time = 2 * 1000 * 60 + 1000 + millis();
      startTime = millis();
      runOven();
      break;
    case "SOFTEN":
      levelPower = 4;
      time = 2 * 1000 * 60 + 1000 + millis();
      startTime = millis();
      runOven();
      break;
    case "COOK TIME":
      mode = 0;
      break;
    case "Preset":
      if (mode==0) {
        mode=1;
        modeTitle = "Convenience Cooking";
        for (Button btn : getRangeButtons(0, 12)) {
          btn.enable = false;
        }
        for (Button btn : getRangeButtons(12, 18)) {
          btn.enable = true;
        }
        gettButton(18).text = BLACK_COLOR;
        gettButton(18).background = BLUE_COLOR;
      } else {
        mode=0;
        modeTitle = "Express Cook";
        for (Button btn : getRangeButtons(0, 12)) {
          btn.enable = true;
        }
        for (Button btn : getRangeButtons(12, 18)) {
          btn.enable = false;
        }
        gettButton(18).text = BLUE_COLOR;
        gettButton(18).background = BLACK_COLOR;
      }
      break;
    case "Set\nClock":
      break;
    case "STOP\n/Cancel":
      if (!pause && !done && progress) {
        pauseTime=millis();
        pause=true;
        stopOven();
      } else {
        progress=false;
        done=false;
        pause=false;
        stopOven();
        time = 0;
        startTime = 0;
        levelPower = 10;
      }
      break;
    case "START\n/+30 Sec.":
      if (pause) {
        time += millis()-pauseTime;
        startTime += millis()-pauseTime;
        runOven();
      } else {
        if (!progress) {
          levelPower = 10;
          time = 30000 + 1000 + millis();
          startTime = millis();
          runOven();
        } else {
          if (time+30000<startTime+60000*60-1) {
            time += 30000;
          } else {
            startTime=millis();
            time=startTime+60000*60-1;
          }
        }
      }
      break;
    case "Power\nLevel":
      levelPower--;
      if (levelPower<1) {
        levelPower=10;
      }
      break;
    }
  }
}

abstract class Page {

  ArrayList<Button> listButtons = new ArrayList();

  void Show() {
    for (Button b : listButtons) {
      b.Show();
    }
  }

  Button getLastButton() {
    return listButtons.get(listButtons.size()-1);
  }
  
  Button gettButton(int index) {
    return listButtons.get(index);
  }

  ArrayList<Button> getRangeButtons(int start, int end) {
    ArrayList<Button> lB = new ArrayList();
    for (int i=start; i<end; i++) {
      lB.add(listButtons.get(i));
    }
    return lB;
  }

  abstract void Event(Button b);

  void mousePressed() {
    for (Button b : listButtons) {
      b.mousePressed();
    }
  }

  void mouseReleased() {
    for (Button b : listButtons) {
      b.mouseReleased();
    }
  }
}
