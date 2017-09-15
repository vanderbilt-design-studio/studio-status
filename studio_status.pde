import java.util.Map;
import processing.io.*;

PImage logo; // 1920 x 203

String fontPath = "Roadgeek 2005 Series 4B.ttf";

HashMap<Integer, PFont> fonts = new HashMap<Integer, PFont>();

String[][] names = {{"", "", "Dominic G", "Olivia C"},
                    {"", "Kurt L", "Jonah H.", "Foard N", "Jillian B"},
                    {"", "Nicholas B", "Lin L", "Eric Noonan", "Alex B"},
                    {"", "Lauren B", "Christina H", "Sophia Z", "Taylor P"},
                    {"", "Jeremy D", "Sameer P", "Emily M", "Julian S"},
                    {"Liam K", "Illiya L", "Josh P"},
                    {}};

final color BLUE = color(0,0,181), GREEN = color(0,85, 0), PURPLE = color(121,40,161), 
    BLACK = color(0,0,0), BROWN = color(56,41,3), RED = color(135, 13, 37), ORANGE = color(145, 79, 21);


boolean isGPIOAvailable = true;

void setup() {
  fullScreen();
  logo = loadImage("DSHeader.png", "png");
  for (int i = 20; i <= 400; i += 20) {
    fonts.put(i, createFont(fontPath, i));
  }
  if (isGPIOAvailable) {
    GPIO.pinMode(11, GPIO.INPUT);
    GPIO.pinMode(13, GPIO.INPUT);
    GPIO.pinMode(15, GPIO.INPUT);
  }
  frameRate(2);
}

void draw() {
  background(255, 255, 255);
  image(logo, 0, 0);
  drawOpen(isOpen());
  drawMentorOnDuty();
}

boolean isOpen() {
  int dayOfWeek = dow(day(), month(), year());
  int currentHour = hour();
  boolean isOpen = false;
  if (dayOfWeek == 1 || dayOfWeek == 2 || dayOfWeek == 3 || dayOfWeek == 4) {
    isOpen = currentHour >= 14 && currentHour < 22;
  } else if (dayOfWeek == 5) {
    isOpen = currentHour >= 12 && currentHour < 18;
  } else if (dayOfWeek == 0) {
    isOpen = currentHour >= 4 && currentHour < 8;
  }
  return isOpen && getSwitchValue() != CLOSED;
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
         960, 1080);
  }
}


final int OPENONE = 1, OPENTWO = 2, CLOSED = 0;

int getSwitchValue() {
  return isGPIOAvailable ? (GPIO.digitalRead(13) == GPIO.HIGH ? CLOSED : GPIO.digitalRead(15) == GPIO.HIGH ? OPENTWO : OPENONE) : OPENONE;
}