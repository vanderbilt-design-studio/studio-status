import java.util.PriorityQueue;
import java.util.Map;
import processing.io.*;
import processing.serial.*;


PShape logo; // 1920 x 203

final String fontPath = "Roadgeek 2005 Series 4B.ttf";

final HashMap<Integer, PFont> fonts = new HashMap<Integer, PFont>();

final String[][] names = {
    {"", "", "Dominic G", "Olivia C", "Foard N"},
    {"", "Juliana Soltys", "Jonah H.", "", "Jillian B"},
    {"", "Eric N", "Lin Liu", "Sameer P", "Alex B"},
    {"", "Lauren B", "Christina H", "Sophia Z", "Taylor P"},
    {"", "Jeremy D", "Illiya", "Emily M", "Nicholcas B"},
    {"Liam K", "Josh P"},
    {}};

final color BLUE = color(0, 67, 123), GREEN = color(0, 95, 77),
            PURPLE = color(157, 0, 113), BLACK = color(0, 0, 0),
            BROWN = color(98, 51, 30), RED = color(199, 0, 43),
            ORANGE = color(255, 104, 2), YELLOW = color(255, 178, 0);

final boolean isGPIOAvailable = true;
boolean isDoorDuinoAvailable = false;

SoftwareServo stripservo;

Serial doorDuino;

void setup() {
  fullScreen();
  logo = loadShape("logo.svg");
  for (int i = 20; i <= 400; i += 20) {
    fonts.put(i, createFont(fontPath, i));
  }
  if (isGPIOAvailable) {
    GPIO.pinMode(17, GPIO.INPUT);
    GPIO.pinMode(27, GPIO.INPUT);
    stripservo = new SoftwareServo(this);
    String[] serial = Serial.list();
    if (serial.length > 0) {
      doorDuino = new Serial(this, serial[0], 600);
      println(serial[0]);
      isDoorDuinoAvailable = true;
    }
  }
  frameRate(10);
}

void draw() {
  background(255, 255, 255);
  drawDesignStudio();
  drawOpen(isOpen());
  drawMentorOnDuty();
  flipOpenStripServo();
}

boolean servoOpen = false;
boolean firstSwitch = true;
void flipOpenStripServo() {
  if (isGPIOAvailable) {
    boolean shouldFlip = false;
    if (firstSwitch) {
      firstSwitch = false;
      shouldFlip = true;
    } else if (isOpen() && !servoOpen) { // TODO: self, xor this pls
      shouldFlip = true;
    } else if (!isOpen() && servoOpen) {
      shouldFlip = true;
    }
    
    if (shouldFlip) {
      if (isOpen()) {
        // stripservo.write(140);
        servoOpen = true;
      } else {
        // stripservo.write(65);
        servoOpen = false;
      }
    }
  }
}

boolean isDoorOpen() {
  if (!isDoorDuinoAvailable) { return true; }
  doorDuino.write((byte)0);
  long timeout = System.currentTimeMillis();
  while (doorDuino.available() == 0 && System.currentTimeMillis() - timeout < 700) {}
  return System.currentTimeMillis() - timeout < 700 ? doorDuino.read() == 1 : true;
}

void drawDesignStudio() {
  shape(logo, 0, 0, 200, 200);
  fill(BLACK);
  textFont(fonts.get(200));
  textAlign(CENTER, TOP);
  text("Design Studio", 960, 0);
}

boolean isOpen() {
  int dayOfWeek = dow(day(), month(), year());
  int currentHour = hour();
  boolean isOpen = false;
  if (currentHour >= 12 && dayOfWeek > -1 && dayOfWeek < 7) {
    int EODhour = names[dayOfWeek].length * 2 + 12;
    int idx = (currentHour - 12)/2;
    if (currentHour < EODhour && names[dayOfWeek].length > idx && idx > -1 && !names[dayOfWeek][idx].isEmpty()) {
      isOpen = true;
    }
  }
  int switchValue = getSwitchValue();
  if (switchValue == OPENONE) {
    return isOpen && isDoorOpen();
  } else if (switchValue == OPENTWO) {
    return isDoorOpen();
  } else {
    return false;
  }
}

// d = day in month
// m = month (January = 1 : December = 12)
// y = 4 digit year
// Returns 0 = Sunday .. 6 = Saturday
int dow(int d, int m, int y) {
  if (m < 3) {
    m += 12;
    y--;
  }
  return (d + int((m + 1) * 2.6) + y + int(y / 4) + 6 * int(y / 100) +
          int(y / 400) + 6) %
         7;
}

void drawOpen(boolean open) {
  fill(open ? GREEN : RED);
  textFont(fonts.get(400));
  textAlign(CENTER, TOP);
  text(open ? "Open" : "Closed", 960, 203);
}

void drawMentorOnDuty() {
  if (isOpen() && getSwitchValue() == OPENONE) {
    fill(BLACK);
    textFont(fonts.get(100));
    textAlign(CENTER, BASELINE);
    text("Mentor on Duty: " +
             names[dow(day(), month(), year())][((hour() - 12) / 2)],
         960, 1075);
  }
}

final int OPENONE = 1, OPENTWO = 2, CLOSED = 0;

int getSwitchValue() {
  return isGPIOAvailable
             ? (GPIO.digitalRead(17) == GPIO.HIGH
                    ? OPENONE
                    : GPIO.digitalRead(27) == GPIO.HIGH ? OPENTWO : CLOSED)
             : OPENONE;
}
