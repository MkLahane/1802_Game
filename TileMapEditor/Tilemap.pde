class Tilemap {
  Tile[] dropzones;
  float camX;
  float camY;
  float camW;
  float camH; 
  int rows;
  int cols; 
  Tile[][] grid;
  float tileWidth;
  float tileHeight;
  float currentTileWidth;
  float currentTileHeight; 
  Tile currentSelectedDropzone; 
  Tilemap(int _rows, int _cols) {
    dropzones = new Tile[5];
    for (int i = 0; i < dropzones.length; i++) {
      dropzones[i] = new Tile(0, i, 10, 815, 150, 100);
    } 
    grid = new Tile[rows][cols]; 
    camX = 0;
    camY = 0;
    camW = 1100;
    camH = 800; 
    rows = _rows;
    cols = _cols; 
    currentSelectedDropzone = null; 
    tileWidth = 50;
    tileHeight = 50;
    currentTileWidth = tileWidth;
    currentTileHeight = tileHeight; 
    float tw = camW / cols;
    float th = camH / rows;
    grid = new Tile[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        grid[i][j] = new Tile(i, j, 0, 0, currentTileWidth, currentTileHeight);
      }
    }
  } 
  Tilemap(int _rows, int _cols, float _tileWidth, float _tileHeight) {
    dropzones = new Tile[5];
    for (int i = 0; i < dropzones.length; i++) {
      dropzones[i] = new Tile(0, i, 10, 815, 150, 100);
    } 
    grid = new Tile[rows][cols]; 
    camX = 0;
    camY = 0;
    camW = 1100;
    camH = 800; 
    rows = _rows;
    cols = _cols; 
    currentSelectedDropzone = null; 
    tileWidth = _tileWidth;
    tileHeight = _tileHeight;
    currentTileWidth = tileWidth;
    currentTileHeight = tileHeight; 
    float tw = camW / cols;
    float th = camH / rows;
    grid = new Tile[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        grid[i][j] = new Tile(i, j, 0, 0, currentTileWidth, currentTileHeight);
      }
    }
  }
  void render() {
    int minRow = max(floor(camY / currentTileHeight), 0);
    int minCol = max(floor(camX / currentTileWidth), 0); 

    int maxRow = min(floor((camY + camH) / currentTileHeight), rows);
    int maxCol = min(floor((camX + camW) / currentTileWidth), cols); 

    for (int i = minRow; i < maxRow; i++) {
      for (int j = minCol; j < maxCol; j++) {
        grid[i][j].tileShow(camX, camY, currentTileWidth, currentTileHeight);
      }
    } 
    for (Tile tile : dropzones) {
      tile.dropzoneTileImg(); 
      tile.dropzoneShow();
    }
    noFill();
    stroke(0);
    strokeWeight(2);
    rect(0, 0, camW, camH);
  } 
  void handleInputs(float mX, float mY) {
    for (Tile tile : dropzones) {
      if (mouseInRect(mX, mY, tile.x, tile.y, tile.w, tile.h)) {
        tile.hover = true;
      } else {
        tile.hover = false;
      }
    }
  } 
  void getDroppedImage(String filePath, float mX, float mY) {
    for (Tile tile : dropzones) {
      if (mouseInRect(mX, mY, tile.x, tile.y, tile.w, tile.h)) {
        ArrayList<Character> filenamechars = new ArrayList();
        for (int i = filePath.length() - 1; i >= 0; i--) {
          char ch = filePath.charAt(i);
          if (ch == '\\') {
            break;
          } 
          filenamechars.add(ch);
        }
        String filename = "";
        for (int i = filenamechars.size() - 1; i >= 0; i--) {
          filename += filenamechars.get(i);
        } 
        tile.tileImg = loadImage(filePath);
        tile.tileImg.save(filename);
        if (currentSelectedDropzone != null) {
          currentSelectedDropzone.selected = false;
        } 
        currentSelectedDropzone = tile; 
        currentSelectedDropzone.tileImgName = filename;
        currentSelectedDropzone.selected = true;
      }
    }
  } 
  boolean checkIfValid(float mX, float mY) {
    for (Tile tile : dropzones) {
      float d = dist(tile.removeX, tile.removeY, mX, mY);
      if (d <= tile.removeR) {
        if (tile.tileImg != null) {
          if (currentSelectedDropzone == tile) {
            currentSelectedDropzone = null;
            tile.selected = false;
          } 
          tile.tileImg = null;
          return false;
        } else {
          return false;
        }
      }
      if (mouseInRect(mX, mY, tile.x, tile.y, tile.w, tile.h)) {
        if (tile.tileImg == null) {
          return true;
        } else {
          if (currentSelectedDropzone != null) {
            currentSelectedDropzone.selected = false;
          } 
          currentSelectedDropzone = tile; 
          currentSelectedDropzone.selected = true;
          return false;
        }
      }
    } 
    return false;
  } 
  void selectedAnyTile(float mX, float mY) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (mouseInRect(camX + mX, camY + mY, grid[i][j].x, grid[i][j].y, currentTileWidth, currentTileHeight)) {
          if (mouseButton == LEFT) {
            if (currentSelectedDropzone != null) {
              grid[i][j].tileImg = currentSelectedDropzone.tileImg; 
              grid[i][j].tileImgName = currentSelectedDropzone.tileImgName;
              grid[i][j].hasBackgroundImage = false; 
              return;
            }
          } else {
            grid[i][j].tileImg = null;
            grid[i][j].tileImgName = "";
            if (backgroundImage != null) {
              grid[i][j].tileImg = backgroundImage;
              grid[i][j].tileImgName = backgroundImageName;
            } 
            grid[i][j].hasBackgroundImage = false; 
            //currentSelectedDropzone = null;
          }
        }
      }
    }
  } 
  void camMove(char k) {
    int dirY = 0;
    int dirX = 0;
    if (k == 'a') {
      dirX = -1;
    } else if (k == 'd') {
      dirX = 1;
    } 
    if (k == 'w') {
      dirY = -1;
    } else if (k == 's') {
      dirY = 1;
    }
    camX += dirX * 10;
    camY += dirY * 10;
    if (camX < 0) {
      camX = 0;
    } 
    if (camY < 0) {
      camY = 0;
    }
  }
  void zoom(float sVal) {
    currentTileWidth += 5 * sVal;
    currentTileHeight += 5 * sVal;
    if (currentTileWidth < 32) {
      currentTileWidth = 32;
    } else if (currentTileWidth > 150) {
      currentTileWidth = 150;
    } 
    if (currentTileHeight < 32) {
      currentTileHeight = 32;
    } else if (currentTileHeight > 150) {
      currentTileHeight = 150;
    } 
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        grid[i][j].x = j * currentTileWidth;
        grid[i][j].y = i * currentTileHeight;
        grid[i][j].w = currentTileWidth;
        grid[i][j].h = currentTileHeight;
      }
    }
  }
  void makeBackground() {
    if (currentSelectedDropzone != null) {
      if (currentSelectedDropzone.tileImg != null) {
        for (int i = 0; i < rows; i++) {
          for (int j = 0; j < cols; j++) {
            if (grid[i][j].tileImgName != "" && !grid[i][j].hasBackgroundImage) {
              continue;
            } 
            grid[i][j].tileImgName = currentSelectedDropzone.tileImgName;
            grid[i][j].tileImg = currentSelectedDropzone.tileImg;
            grid[i][j].hasBackgroundImage = true;
          }
        }
        backgroundImage = currentSelectedDropzone.tileImg;
        backgroundImageName = currentSelectedDropzone.tileImgName;
      }
    }
  }
  void selectTiles(float rX, float rY, float rW, float rH) {
    rX += tilemap.camX;
    rY += tilemap.camY; 
    int minRow = max(floor(camY / currentTileHeight), 0);
    int minCol = max(floor(camX / currentTileWidth), 0); 

    int maxRow = min(floor((camY + camH) / currentTileHeight), rows);
    int maxCol = min(floor((camX + camW) / currentTileWidth), cols); 
    for (int i = minRow; i < maxRow; i++) {
      for (int j = minCol; j < maxCol; j++) {
        float tX = grid[i][j].x; 
        float tY = grid[i][j].y;
        if (mouseInRect(tX, tY, rX, rY, rW, rH)) {
          grid[i][j].selected = true;
        } else {
          grid[i][j].selected = false; 
        } 
      } 
    } 
  } 
} 


boolean mouseInRect(float mX, float mY, float tX, float tY, float w, float h) {
  return (mX >= tX && mX < tX + w && mY >= tY && mY < tY + h);
} 
