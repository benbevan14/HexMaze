class Pathfinder {
    
    ArrayList<Hex> openSet;
    ArrayList<Hex> closedSet;
    ArrayList<Hex> path;
    HashMap<String, Hex> hexes;
    boolean finished;
    Hex start, end;
    
    Pathfinder(HashMap<String, Hex> hexes, int size) {
        this.hexes = hexes;
        openSet = new ArrayList<Hex>();
        closedSet = new ArrayList<Hex>();
        path = new ArrayList<Hex>();
        start = hexes.get("" + -size + " " + 0);
        end = hexes.get("" + size + " " + 0);
        openSet.add(start);
        
        for (Hex hex : hexes.values()) {
            int d = distance(hex, end);
            hex.h = d;
        }
    }
    
    void findPath() {
        int winner = 0;
        for (int i = 0; i < openSet.size(); i++) {
            if (openSet.get(i).f < openSet.get(winner).f) {
                winner = i;   
            }
        }
        
        Hex current = openSet.get(winner);
        
        if (current.key.equals(end.key)) {
            System.out.println("Finished");
            finished = true;
        }
        
        openSet.remove(winner);
        closedSet.add(current);
        
        for (Hex hex : current.getConnected()) {
            Hex item = hexes.get(hex.key);
            
            if (!closedSet.contains(item)) {
                int tempG = current.g + 1;
                
                boolean newPath = false;
                if (openSet.contains(item)) {
                    if (tempG < item.g) {
                        item.g = tempG;
                        newPath = true;
                    }
                } else {
                    item.g = tempG;
                    newPath = true;
                    openSet.add(item);
                }
                
                if (newPath) {
                    item.f = item.g + item.h;
                    item.previous = current;
                }
            }
        }
        
        path.clear();
        Hex temp = current;
        path.add(temp);
        while (temp.previous != null) {
            path.add(temp.previous);
            temp = temp.previous;
        }
    }
    
    void show() {
        stroke(255, 0, 0);
        strokeWeight(3);
        strokeCap(ROUND);
        strokeJoin(ROUND);
        noFill();
        beginShape();
        if (finished) {
            curveVertex(end.centre.x, end.centre.y);
        }
        for (int i = 0; i < path.size(); i++) {
            Point a = path.get(i).centre;
            curveVertex(a.x, a.y);
            //line(a.x, a.y, b.x, b.y);
        }
        curveVertex(start.centre.x, start.centre.y);
        endShape();
    }
    
    int distance(Hex a, Hex b) {
        int n1 = Math.abs(a.q - b.q);
        int n2 = Math.abs(a.q + a.r - b.q - b.r);
        int n3 = Math.abs(a.r - b.r);
        return (n1 + n2 + n3) / 2;
    }
}
