PImage logo; // 1920 x 203
PFont sourceCodePro;


void setup() {
    size(1920, 1080);
    logo = loadImage("DSHeader.png", "png");
    textFont(createFont("Source-Code-Pro.ttf", 400));
    frameRate(2);
}

void draw() {
    background(255, 255, 255);
    image(logo, 0, 0);
    textAlign(CENTER, CENTER);

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
    drawOpen(isOpen);
}


void drawOpen(boolean open) {

    fill(open ? 0 : 255, open ? 255 : 0, 0);
    text(open ? "Open" : "Closed", 1920/2, (1080-203)/2 + 203);
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
  return (d + int((m+1)*2.6) +  y + int(y/4) + 6*int(y/100) + int(y/400) + 6) % 7;
}