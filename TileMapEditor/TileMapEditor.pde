Tilemap tilemap;
float dropzoneMouseX = -1;
float dropzoneMouseY = -1; 
Button saveButton;
Button loadButton; 
PFont buttonFont; 
boolean loadFile = false; 
Slider rowSlider;
Slider colSlider;
Slider tileWidthSlider;
Slider tileHeightSlider; 
boolean tileMapShouldBeChanged = false; 
Button backgroundButton; 
boolean isThereABackgroundImage = false; 
PImage backgroundImage = null; 
String backgroundImageName = ""; 
boolean drawing = false; 
float rectTopLeftX = -1;
float rectTopLeftY = -1;
float rectW = -1; 
float rectH = -1; 
void setup() {
  size(1500, 900);
  tilemap = new Tilemap(30, 50);
  buttonFont = createFont("Segoe Print", 40);
  saveButton = new Button("Save File", new PVector(width / 2 + 10, 810), 150, 80);
  loadButton = new Button("Load File", new PVector(width / 2 + 10 + saveButton.sizeX + 40, 810), 150, 80);
  backgroundButton = new Button("Background Image", new PVector(1150, 600), 300, 80);
  rowSlider = new Slider(1200, 200, 10, 200, "Rows:");
  colSlider = new Slider(1200, 300, 10, 200, "Cols:");        
  tileWidthSlider = new Slider(1200, 400, 32, 150, "Width:");
  tileHeightSlider = new Slider(1200, 500, 32, 150, "Height:");
}
void draw() {
  background(255);
  tilemap.render();
  tilemap.handleInputs(mouseX, mouseY);
  saveButton.show(color(255, 255, 255));
  loadButton.show(color(255, 255, 255));
  saveButton.checkHover(mouseX, mouseY);
  loadButton.checkHover(mouseX, mouseY); 
  rowSlider.show(mouseX, mouseY);
  colSlider.show(mouseX, mouseY);
  tileWidthSlider.show(mouseX, mouseY);
  tileHeightSlider.show(mouseX, mouseY); 
  backgroundButton.show(color(255, 255, 255));
  backgroundButton.checkHover(mouseX, mouseY);
  if (drawing) {
    rectW = abs(mouseX - rectTopLeftX);
    rectH = abs(mouseY - rectTopLeftY);
    stroke(0);
    strokeWeight(2);
    fill(0, 150);
    rect(rectTopLeftX, rectTopLeftY, rectW, rectH);
  } 
} 

void mouseReleased() {
  if (mouseButton == RIGHT) {
    drawing = false; 
    if (rectTopLeftX > 0 && rectTopLeftY > 0 && rectTopLeftX + rectW < 1100 && rectTopLeftY + rectH < 800) {
      tilemap.selectTiles(rectTopLeftX, rectTopLeftY, rectW, rectH);
    }
    rectTopLeftX = -1;
    rectTopLeftY = -1; 
     
    return; 
  } 
  rowSlider.pressed = false; 
  colSlider.pressed = false;
  tileWidthSlider.pressed = false;
  tileHeightSlider.pressed = false; 
  if (tileMapShouldBeChanged) {
    //tilemap = new Tilemap(int(rowSlider.value), int(colSlider.value), int(tileWidthSlider.value), int(tileHeightSlider.value));
    tilemap.rows = (int)rowSlider.value;
    tilemap.cols = (int)colSlider.value;
    tilemap.tileWidth = floor(tileWidthSlider.value);
    tilemap.tileHeight = floor(tileHeightSlider.value); 
    tilemap.currentTileWidth = tilemap.tileWidth;
    tilemap.currentTileHeight = tilemap.tileHeight;
    tilemap.grid = new Tile[tilemap.rows][tilemap.cols];
    for (int i = 0; i < tilemap.rows; i++) {
      for (int j = 0; j < tilemap.cols; j++) {
        tilemap.grid[i][j] = new Tile(i, j, 0, 0, tilemap.currentTileWidth, tilemap.currentTileHeight);
      }
    }
    tileMapShouldBeChanged = false;
  }
} 


void mousePressed() {
  if (mouseButton == RIGHT) {
    drawing = true; 
    rectTopLeftX = mouseX;
    rectTopLeftY = mouseY; 
    return; 
  } 
  if (mouseX > 1150) {
    boolean t1 = rowSlider.check(mouseX, mouseY);
    boolean t2 = colSlider.check(mouseX, mouseY);
    boolean t3 = tileWidthSlider.check(mouseX, mouseY);
    boolean t4 = tileHeightSlider.check(mouseX, mouseY);
    tileMapShouldBeChanged = t1 || t2 || t3 || t4;
    if (backgroundButton.pressed(mouseX, mouseY)) {
      tilemap.makeBackground();
      
    }
    return;
  } 
  if (saveButton.pressed(mouseX, mouseY)) {
    ArrayList<String> tilemapData = new ArrayList();
    tilemapData.add("Background:"+backgroundImageName); 
    tilemapData.add("Rows:"+tilemap.rows); 
    tilemapData.add("Cols:"+tilemap.cols);
    tilemapData.add("Tile Width:"+tilemap.tileWidth);
    tilemapData.add("Tile Height:"+tilemap.tileHeight);
    for (int i = 0; i < tilemap.rows; i++) {
      for (int j = 0; j < tilemap.cols; j++) {
        tilemapData.add("Tile:{"+i+", "+j+"};"+tilemap.grid[i][j].tileImgName);
      }
    } 
    
    String[] str = tilemapData.toArray(new String[tilemapData.size()]);
    saveStrings("tilemapData.txt", str);
    return;
  } 
  if (loadButton.pressed(mouseX, mouseY)) {
    loadFile = true;
    selectInput("Select a file to process:", "fileSelected");
    return;
  } 

  loadFile = false; 
  dropzoneMouseX = mouseX;
  dropzoneMouseY = mouseY; 
  if (mouseY < 800) {
    tilemap.selectedAnyTile(dropzoneMouseX, dropzoneMouseY);
  } else {
    if (tilemap.checkIfValid(dropzoneMouseX, dropzoneMouseY)) {
      selectInput("Select a file to process:", "fileSelected");
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  tilemap.zoom(e);
} 

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    if (loadFile) {
      String[] data = loadStrings(selection.getAbsolutePath());
      String[] backgroundImageData = data[0].split(":");
      backgroundImageName = backgroundImageData[1];
      backgroundImage = loadImage(backgroundImageName);
      String[] rowsData = data[1].split(":");
      String[] colsData = data[2].split(":");
      String[] imgWidthData = data[3].split(":");
      String[] imgHeightData = data[4].split(":"); 
      int _rows = Integer.parseInt(rowsData[1]);
      int _cols = Integer.parseInt(colsData[1]);
      float _imgWidth = Float.parseFloat(imgWidthData[1]);
      float _imgHeight = Float.parseFloat(imgHeightData[1]);

      tilemap = new Tilemap(_rows, _cols);
      int index = 5;
      for (int i = 0; i < tilemap.rows; i++) {
        for (int j = 0; j < tilemap.cols; j++) { 

          String[] tileData = data[index].split(";");
          if (tileData.length > 1) {
            String tileImgName = tileData[1];
            tilemap.grid[i][j].tileImg = loadImage(tileImgName);
            tilemap.grid[i][j].tileImgName = tileImgName;
          } 
          
          index++;
        }
      }
    } else {
      tilemap.getDroppedImage(selection.getAbsolutePath(), dropzoneMouseX, dropzoneMouseY);
    }
  }
}


void keyPressed() {
  tilemap.camMove(key);
} 
