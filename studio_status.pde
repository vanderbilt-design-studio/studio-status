PImage logo; // 1920 x 203
PFont sourceCodePro400, sourceCodePro80;

String[][] names = {{},
                    {"", "Kurt L", "Jonah H.", "Foard N", "Jillian B"},
                    {"", "Nicholas B", "Lin L", "Eric Noonan", "Alex B"},
                    {"", "Lauren B", "Christina H", "Sophia Z", "Taylor P"},
                    {"", "Jeremy D", "Sameer P", "Emily M", "Julian S"},
                    {"Liam K", "Illiya L", "Josh P"},
                    {"Dominic G", "Olivia C"}};

void setup() {
  size(1920, 1080);
  logo = loadImage("DSHeader.png", "png");
  sourceCodePro80 = createFont("Source-Code-Pro.ttf", 80);
  sourceCodePro400 = createFont("Source-Code-Pro.ttf", 400);
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
  } else if (dayOfWeek == 6) {
    isOpen = currentHour >= 12 && currentHour < 4;
  }
  return isOpen;
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
  fill(open ? 0 : 255, open ? 255 : 0, 0);
  textFont(sourceCodePro400);
  textAlign(CENTER, TOP);
  text(open ? "Open" : "Closed", 960, 203);
}

void drawMentorOnDuty() {
  if (isOpen()) {
    fill(0, 0, 0);
    textFont(sourceCodePro80);
    textAlign(CENTER, BOTTOM);
    text("Mentor on Duty: " +
             names[dow(day(), month(), year())][((hour() - 12) / 2)],
         960, 1080);
  }
}