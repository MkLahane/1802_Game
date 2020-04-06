class Button {
  PVector pos;
  float sizeX;
  float sizeY;
  String value;
  boolean hover = false; 
  Button(String _value, PVector _pos, float _sizeX, float _sizeY) {
    sizeX = _sizeX;
    sizeY = _sizeY;
    pos = _pos.get();
    value = _value;
  } 
  void show(color col) {
    if (hover) {
      fill(col, 150);
    } else {
      fill(col);
    } 
    stroke(0);
    strokeWeight(2);
    rect(pos.x, pos.y, sizeX, sizeY);
    fill(0);
    textFont(buttonFont);
    if (hover) {
      textSize(30);
    } else {
      textSize(20);
    } 
    textAlign(CENTER);
    text(value, pos.x + sizeX / 2, pos.y + sizeY / 2 + 10);
  } 
  void checkHover(float mX, float mY) {
    if (pressed(mX, mY)) {
      hover = true;
    } else {
      hover = false; 
    } 
  } 
  boolean pressed(float mX, float mY) {
    return (mX >= pos.x && mX <= pos.x + sizeX && mY >= pos.y && mY <= pos.y + sizeY);
  } 
} 
