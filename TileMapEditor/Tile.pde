class Tile {
  int i;
  int j;
  float x, y;
  PImage tileImg; 
  float w; 
  float h;
  boolean hover; 
  boolean selected; 
  //for dropzones
  float removeX;
  float removeY;
  float removeR; 
  String tileImgName; 
  boolean hasBackgroundImage;
  Tile(int _i, int _j, float _startX, float _startY, float _w, float _h) {
    tileImg = null; 
    i = _i;
    j = _j; 
    w = _w;
    h = _h;
    selected = false; 
    hover = false; 
    x = _startX + j * w;
    y = _startY + i * h;
    removeX = x + (w * 0.7) + 10;
    removeY = y + 30; 
    removeR = 10;
    tileImgName = "";
    hasBackgroundImage = false; 
  } 
  void dropzoneShow() {
    noFill();
    if (!selected) {
      stroke(0);
    } else {
      noStroke(); 
    } 
    strokeWeight(2);
    rect(x, y, w * 0.5, h * 0.7);
    if (hover && tileImg == null) {
      fill(25, 100);
      rect(x, y, w * 0.5, h * 0.7); 
    } 
    if (selected) {
      fill(255, 170);
      rect(x, y, w * 0.5, h * 0.7);
    } 
    stroke(0);
    ellipse(removeX, removeY, removeR * 2, removeR * 2); 
    float l1X = removeX + cos(PI / 4) * removeR; 
    float l1Y = removeY + sin(PI / 4) * removeR; 
    float l3X = removeX + cos(-PI / 4) * removeR;
    float l3Y = removeY + sin(-PI / 4) * removeR;
    float l2X = l1X - removeR;
    float l4X = l3X - removeR; 
    stroke(0);
    strokeWeight(2);
    
    line(l2X, l1Y, l3X, l3Y);
    line(l1X, l1Y, l4X, l3Y);
  } 
   
  void tileShow(float cX, float cY, float cW, float cH) {
    noFill();
    stroke(0);
    if (!selected) {
      strokeWeight(1);
    } else {
      strokeWeight(2); 
    } 
    if (cW < 20) {
      strokeWeight(1);
    } 
    rect(x - cX, y - cY, w, h);
    //if (hover) {
    //  fill(25, 100);
    //  rect(x - cX, y - cY, w, h); 
    //} 
    if (tileImg != null) {
      image(tileImg, x - cX, y - cY, w, h);
    }
  }
  void dropzoneTileImg() {
    if (tileImg != null) {
      image(tileImg, x + 5, y + 5, w * 0.45, h * 0.6);
    }
  } 
 
} 
