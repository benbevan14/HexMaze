Grid grid;
Pathfinder p;
boolean generating = false;
boolean solving = false;
boolean manual = false;

PFont font;

int gridSize = 10;

void setup() {
    size(800, 800);
    grid = new Grid(gridSize);
    p = new Pathfinder(grid.hexes, gridSize);
    font = createFont("Comic Sans MS", 20, true);
    textFont(font);
    //frameRate(10);
    //print(PFont.list());
}

void draw() {
    background(0, 50, 100);
    //textSize(20);
    fill(255, 255, 255);
    text("Press enter to start generation.", 3, 20);
    text("Press backspace to solve.", 3, 40);
    text("Press m to enter manual mode.", 3, 60);
    translate(width / 2, height / 2);
    grid.highlight(mouseX - width / 2, mouseY - height / 2);
    grid.show();
    p.show();
    if (grid.open) {
        grid.finished = true;   
    }
    if (generating) {
        solving = false;
        if (!grid.finished) {
            grid.backtracker();
            grid.backtracker();
        } else {
            generating = false;   
        }
    }
    if (solving) {
        generating = false;
        if (!p.finished) {
            p.findPath();   
        } else {
            solving = false;
        }
    }
}

void keyPressed() {
    if (key == ENTER) {
        if (!manual) {
            generating = true;
        }
    }
    if (key == BACKSPACE) {
        if (grid.finished) {
            solving = true;   
        }
    }
    if (key == 'o') {
        grid.open();   
        System.out.println("o key pressed");
    }
    if (key == 'm') {
        if (!manual) {
            manual = true;
            grid.open();
        }
    }
    if (key == 'r') {
        reset();   
    }
}

void mousePressed() {
    if (manual && !solving && !p.finished) {
        grid.toggle(mouseX - width / 2, mouseY - height / 2);  
    }
}

void reset() {
    grid = new Grid(gridSize);
    p = new Pathfinder(grid.hexes, gridSize);
    manual = false;
    solving = false;
    generating = false;
}
