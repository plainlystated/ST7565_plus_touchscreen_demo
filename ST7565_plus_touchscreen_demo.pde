#include <stdint.h>
#include "ST7565.h"
#include "TouchScreen.h"

#define YP A2  // must be an analog pin, use "An" notation!
#define XM A3  // must be an analog pin, use "An" notation!
#define YM 3   // can be a digital pin
#define XP 4   // can be a digital pin

#define LCD_BACKLIGHT 10
#define LCD_SID 9
#define LCD_SCLK 8
#define LCD_RS_A0 7
#define LCD_RST 6
#define LCD_CS 5

const int current_temp_x = 60;
const int current_temp_y = 6;
const int desired_temp_x = 6;
const int desired_temp_y = 6;

ST7565 lcd(LCD_SID, LCD_SCLK, LCD_RS_A0, LCD_RST, LCD_CS);
TouchScreen touchscreen = TouchScreen(XP, YP, XM, YM, 300);

// The setup() method runs once, when the sketch starts
void setup()   {
  Serial.begin(9600);

  // turn on backlight
  pinMode(LCD_BACKLIGHT, OUTPUT);
  digitalWrite(LCD_BACKLIGHT, HIGH);

  // initialize and set the contrast to 0x18
  lcd.begin(0x18);
  lcd.clear();

  lcd.drawrect(desired_temp_x, desired_temp_y, 48, 20, BLACK);
  lcd.drawstring(desired_temp_x + 3, 1, "Desired");
  lcd.drawstring(desired_temp_x + 3, 2, "temp:67");

  lcd.drawrect(current_temp_x, current_temp_y, 48, 20, BLACK);
  lcd.drawstring(current_temp_x + 3, 1, "Current");
  lcd.drawstring(current_temp_x + 3, 2, "temp:69");

  drawButton("Up", 6, 30);
  drawButton("Down", 44, 30);

  lcd.display();
}


void loop()
{
  Point p = touchscreen.getPoint();

  // we have some minimum pressure we consider 'valid'
  // pressure of 0 means no pressing!
  if (p.z > touchscreen.pressureThreshhold) {
    if (buttonPressed(p, 700, 260, 200, 300)) {
      Serial.println("Left button");
    }

    if (buttonPressed(p, 430, 220, 200, 300)) {
      Serial.println("Middle button");
    }

     Serial.print("X = "); Serial.print(p.x);
     Serial.print("\tY = "); Serial.print(p.y);
     Serial.print("\tPressure = "); Serial.println(p.z);
  }

  delay(100);
}

bool buttonPressed(Point p, int x, int y, int width, int height) {
  if ( x < p.x && p.x < (x+width) && y < p.y && p.y < (y+height)) {
    return true;
  } else {
    return false;
  }
}

void drawButton(char* name, int x, int y) {
  lcd.drawrect(x, y, 32, 32, BLACK);
}
