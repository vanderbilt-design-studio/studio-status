import java.util.PriorityQueue;
import java.util.Map;
import processing.io.*;

class Drawable implements Comparable<Drawable> {
public
  Runnable draw;
public
  float x, y, w, h;
public
  int priority;
public
  Drawable(Runnable draw, float x, float y, float w, float h) {
    this.draw = draw;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  @Override public int compareTo(Drawable rhs) {
    return rhs.priority - this.priority;
  }
}

PriorityQueue<Drawable>
    q = new PriorityQueue<Drawable>();

PShape logo; // 1920 x 203

final String fontPath = "Roadgeek 2005 Series 4B.ttf";

final HashMap<Integer, PFont> fonts = new HashMap<Integer, PFont>();

final String[][] names = {
    {"", "", "Dominic G", "Olivia C"},
    {"", "Kurt L", "Jonah H.", "Foard N", "Jillian B"},
    {"", "Nicholas B", "Lin Liu", "Eric N", "Alex B"},
    {"", "Lauren B", "Christina H", "Sophia Z", "Taylor P"},
    {"", "Jeremy D", "Sameer P", "Emily M", "Julian S"},
    {"Liam K", "Illiya L", "Josh P"},
    {}};

final color BLUE = color(0, 67, 123), GREEN = color(0, 95, 77),
            PURPLE = color(157, 0, 113), BLACK = color(0, 0, 0),
            BROWN = color(98, 51, 30), RED = color(199, 0, 43),
            ORANGE = color(255, 104, 2), YELLOW = color(255, 178, 0);

final boolean isGPIOAvailable = false;

void setup() {
  fullScreen();
  logo = loadShape("logo.svg");
  for (int i = 20; i <= 400; i += 20) {
    fonts.put(i, createFont(fontPath, i));
  }
  if (isGPIOAvailable) {
    GPIO.pinMode(17, GPIO.INPUT);
    GPIO.pinMode(27, GPIO.INPUT);
  }
  frameRate(30);
}

void draw() {
  background(255, 255, 255);
  drawDesignStudio();
  drawOpen(isOpen());
  drawMentorOnDuty();
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
  if (dayOfWeek == 1 || dayOfWeek == 2 || dayOfWeek == 3 || dayOfWeek == 4) {
    isOpen = currentHour >= 14 && currentHour < 22;
  } else if (dayOfWeek == 5) {
    isOpen = currentHour >= 12 && currentHour < 18;
  } else if (dayOfWeek == 0) {
    isOpen = currentHour >= 16 && currentHour < 20;
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
         960, 1075);
  }
}

final int OPENONE = 1, OPENTWO = 2, CLOSED = 0;

int getSwitchValue() {
  return isGPIOAvailable
             ? (GPIO.digitalRead(17) == GPIO.HIGH
                    ? OPENONE
                    : GPIO.digitalRead(27) == GPIO.HIGH ? OPENTWO : CLOSED)
             : OPENTWO;
}
