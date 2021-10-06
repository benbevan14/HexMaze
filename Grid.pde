import java.util.Stack;

class Grid {
    
    int size;
    float hexSize;
    HashMap<String, Hex> hexes;
    boolean finished;
    boolean open;
    boolean closed;
    float[] inverseMatrix;
    
    // recursive backtracker
    Stack<Hex> stack;
    Hex current = null;
    
    Grid(int size) {
        this.size = size;
        hexSize = 750 / ((float) (Math.sqrt(3) * (2 * this.size + 1)));
        hexes = new HashMap<String, Hex>();
        finished = false;
        closed = true;
        open = false;
        
        for (int i = -this.size; i < this.size + 1; i++) {
            for (int j = -this.size; j < this.size + 1; j++) {
                if (Math.abs(i + j) < this.size + 1) {
                    hexes.put(i + " " + j, new Hex(i, j, hexSize));   
                }
            }
        }
        
        // initialise the matrix for getting a hex from a pixel position
        inverseMatrix = new float[4];
        inverseMatrix[0] = (float) Math.sqrt(3.0) / 3.0;
        inverseMatrix[1] = 1./3;
        inverseMatrix[2] = 0;
        inverseMatrix[3] = 2./3;
        
        // initialise the stack with the first hex for the recursive backtracker
        stack = new Stack<Hex>();
        stack.push(hexes.get("0 0"));
        hexes.get("0 0").visited = true;
    }
    
    void join(String a, String b, boolean value) {
        Hex one = hexes.get(a);
        Hex two = hexes.get(b);
        
        if (two.q > one.q) {
            if (two.r < one.r) {
                one.borders[0] = value;
                two.borders[3] = value;
            } else {
                one.borders[1] = value;
                two.borders[4] = value;
            }
        } else if (two.q == one.q) {
            if (two.r < one.r) {
                one.borders[5] = value;
                two.borders[2] = value;
            } else {
                one.borders[2] = value;
                two.borders[5] = value;
            }
        } else {
            if (two.r > one.r) {
                one.borders[3] = value;
                two.borders[0] = value;
            } else {
                one.borders[4] = value;
                two.borders[1] = value;
            }
        }
    }
    
    void backtracker() {
        if (stack.size() != 0) {
            // remove the current node from the stack
            current = stack.pop();
            ArrayList<Hex> adjacent = new ArrayList<Hex>();
            // get all the neighbours of the current node
            for (String s : current.getNeighbours()) {
                if (hexes.containsKey(s)) {
                    // if a hex is inside the grid and hasn't been visited, add it to the list
                    if (!hexes.get(s).visited) 
                        adjacent.add(hexes.get(s));
                }
            }
            
            // if there's at least one visitable node, join it to the network
            if (!adjacent.isEmpty()) {
                stack.push(current);   
                // select a random adjacent node
                int a = int(random(adjacent.size()));
                String key = adjacent.get(a).key;
                join(current.key, key, false);
                hexes.get(key).visited = true;
                stack.push(hexes.get(key));
            }
        } else {
            finished = true;   
        }
    }
    
    String getHexFromPos(float x, float y) {
        double q = (inverseMatrix[0] * x - inverseMatrix[1] * y) / hexSize;
        double r = (inverseMatrix[2] * x + inverseMatrix[3] * y) / hexSize;
        return roundCoords((float) q, (float) r);
    }
    
    String roundCoords(float x, float z) {
        float y = -x - z;
        int rx = Math.round(x);
        int ry = Math.round(y);
        int rz = Math.round(z);
        
        float xDiff = Math.abs(rx - x);
        float yDiff = Math.abs(ry - y);
        float zDiff = Math.abs(rz - z);
        
        if (xDiff > yDiff && xDiff > zDiff) {
            rx = -ry - rz;   
        } else if (yDiff > zDiff) {
            ry = -rx - rz;   
        } else {
            rz = -rx - ry;   
        }
        
        return rx + " " + rz;
    }
    
    void highlight(float x, float y) {
        String key = getHexFromPos(x, y);
        for (Hex h : hexes.values()) {
            if (h.key.equals(key)) {
                h.highlighted = true;   
            } else {
                h.highlighted = false;  
            }
        }
    }
    
    void open() {
        open = true;
        closed = false;
        for (Hex h : hexes.values()) {
            h.setBorders(false);   
            if (h.q == size || h.r == -size)
                h.borders[0] = true;
            if (h.q == size || h.s == -size)
                h.borders[1] = true;
            if (h.s == -size || h.r == size)
                h.borders[2] = true;
            if (h.r == size || h.q == -size)
                h.borders[3] = true;
            if (h.q == -size || h.s == size)
                h.borders[4] = true;
            if (h.s == size || h.r == -size)
                h.borders[5] = true;
                
             for (int i = 0; i < 6; i++) {
                 h.openState[i] = h.borders[i];   
             }
        }
    }
    
    void close() {
        open = false;
        closed = true;
        for (Hex h : hexes.values()) {
            h.setBorders(true);   
        }
    }
    
    void toggle(float x, float y) {
        String key = getHexFromPos(x, y);
        if (hexes.containsKey(key)) {
            Hex h = hexes.get(key);
            if (h.isClosed()) {
                h.setBorders(h.openState);   
            } else {
                h.setBorders(true);   
            }
        }
    }
    
    void show() {
        for (Hex h : hexes.values()) {
            int tier = Math.max(Math.max(Math.abs(h.q), Math.abs(h.r)), Math.abs(h.s));
            h.drawFilled(h.c);
        }
        for (Hex h : hexes.values()) {
            h.drawHex();
        }
        if (!finished) {
            if (current != null) {
                current.drawFilled(color(255, 255, 255));   
            }
        }
    }    
}
