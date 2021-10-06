class Hex {
    
    int q, r, s;
    float size;
    String key;
    boolean[] borders;
    Point centre = new Point(0, 0);
    Point[] points;
    Point[] innerPoints;
    boolean visited;
    boolean highlighted = false;
    boolean[] openState;
    int f, g, h;
    Hex previous = null;
    color c = color(0, random(90, 120), 150);
    
    Hex(int q, int r, float size) {
        this.size = size;
        
        this.q = q;
        this.r = r;
        s = -this.q - this.r;
        
        key = this.q + " " + this.r;
        
        borders = new boolean[6];
        setBorders(true);
        
        openState = new boolean[6];
            
        centre = getPosFromHex();
        points = getVertices(1.0f);
        innerPoints = getVertices(0.7f);
        
        visited = false;
        
        f = 0;
        g = 0;
        h = 0;
    }
    
    Point getPosFromHex() {
        float x = (float) ((Math.sqrt(3.0) * q + Math.sqrt(3.0) / 2.0 * r) * size);
        float y = (float) (1.5 * r * size);
        return new Point(x, y);
    }
    
    Point[] getVertices(float scale) {
        Point[] points = new Point[6];
        
        for (int i = 0; i < 6; i++) {
            float angle = 60 * i - 90;
            float rad = (float) (Math.PI / 180 * angle);
            points[i] = new Point((float) (centre.x + size * scale * Math.cos(rad)),
                                  (float) (centre.y + size * scale * Math.sin(rad)));
        }
        
        return points;
    }
    
    String[] getNeighbours() {
        String[] keys = new String[6];
        keys[0] = (q + 1) + " " + (r - 1);
        keys[1] = (q + 1) + " " + (r    );
        keys[2] = (q    ) + " " + (r + 1);
        keys[3] = (q - 1) + " " + (r + 1);
        keys[4] = (q - 1) + " " + (r    );
        keys[5] = (q    ) + " " + (r - 1);
        return keys;
    }
    
    ArrayList<Hex> getConnected() {
        int[] qAdd = {1, 1, 0, -1, -1, 0};
        int[] rAdd = {-1, 0, 1, 1, 0, -1};
        
        ArrayList<Hex> result = new ArrayList<Hex>();
        for (int i = 0; i < 6; i++) {
            if (!borders[i])
                result.add(new Hex(q + qAdd[i], r + rAdd[i], size));
        }
        
        return result;
    }
    
    boolean withinBoundary(int bound) {
        return Math.abs(q) < bound + 1 && Math.abs(r) < bound + 1 && Math.abs(s) < bound + 1;   
    }
    
    void drawHex() {
        drawOutline();
        
        if (isClosed()) {
            drawInner(color(0, 150, 255, 150));
        }
        if (highlighted) {
            fill(255, 255, 255, 100);
            noStroke();
            beginShape();
            for (int i = 0; i < 6; i++) {
                vertex(points[i].x, points[i].y);   
            }
            endShape();
        }
    }
    
    
    void drawOutline() {
        stroke(255, 255, 255);
        strokeWeight(4);
        for (int i = 0; i < 6; i++) {
            if (borders[i]) {
                if (i < 5) {
                    line(points[i].x, points[i].y, points[i + 1].x , points[i + 1].y);   
                } else {
                    line(points[i].x, points[i].y, points[0].x , points[0].y);   
                }
            }
        }
    }
    
    void drawFilled(color c) {
        fill(c);
        noStroke();
        beginShape();
        for (int i = 0; i < 6; i++) {
            vertex(points[i].x, points[i].y);   
        }
        endShape();
    }
    
    void drawInner(color c) {
        fill(c);
        noStroke();
        beginShape();
        for (int i = 0; i < 6; i++) {
            vertex(innerPoints[i].x, innerPoints[i].y);   
        }
        endShape();
    }
    
    void showBorders() {
        for (int i = 0; i < 6; i++) {
            System.out.print(borders[i] + ", ");   
        }
    }
    
    void setBorders(boolean value) {
        for (int i = 0; i < 6; i++) {
            borders[i] = value;   
        }
    }
    
    void setBorders(boolean[] values) {
        for (int i = 0; i < 6; i++) {
            borders[i] = values[i];   
        }
    }
     
    boolean isClosed() {
        for (int i = 0; i < 6; i++) {
            if (borders[i] == false)
                return false;
        }
        return true;
    }
    
    boolean isOpen() {
        for (int i = 0; i < 6; i++) {
            if (borders[i] == true)
                return false;
        }
        return true;
    }
    
}
