class Slider {
  float x;
  float y;
  float value;
  float minValue;
  float maxValue;
  float w;
  boolean pressed; 
  String strValue; 
  Slider(float _x, float _y, float _minValue, float _maxValue, String _strValue) {
    x = _x;
    y = _y;
    minValue = _minValue;
    value = _minValue;
    maxValue = _maxValue; 
    w = 200;
    pressed = false;
    strValue = _strValue;
  } 
  void show(float mX, float mY) {

    if (pressed) {
      
      if (mX < x) {
        mX = x;
      } else if (mX > x + w - 20) {
        mX = x + w;
      } 
      
      value = map(mX, x, x + w, minValue, maxValue);
    } 
    
    fill(255); 
    stroke(0);
    strokeWeight(2);
    rect(x, y, w, 20);
    float xSlider = map(value, minValue, maxValue, x, x + w - 20);
    if (mouseInRect(mX, mY, xSlider, y, 20, 20)) {
      fill(0, 100);
    } else {
      noFill();
    } 
    rect(xSlider, y, 20, 20); 

    fill(0, 100);
    noStroke();
    rect(x, y, xSlider - x, 20);
    textFont(buttonFont);
    textSize(40);
    fill(0);
    text(strValue+int(value), x + w / 2, y - 20);
  } 
  boolean check(float mX, float mY) {
    float xSlider = map(value, minValue, maxValue, x, x + w - 20);
    if (mouseInRect(mX, mY, x, y, w, 20)) {
      //float val = map(mX, x, x + w, minValue, maxValue);
      //value = val;
      pressed = true;
      return true; 
    }
    return false; 
  }
} 
