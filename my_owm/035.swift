func readInt() -> Int {
    Int(readLine()!)!
}

func readIntArray() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

//connection
var con = [(p: Int, c: Set<Int>)](repeating: (-1, []), count: n + 1)
for _ in 1..<n {
    let ab = readIntArray()
    con[ab[0]].c.insert(ab[1])
    con[ab[1]].c.insert(ab[0])
}

func setParent(p: Int) {
    for c in con[p].c {
        con[c].p = p
        con[c].c.remove(p)
        setParent(p: c)
    }
}

setParent(p: 1)

var route = [Set<Int>](repeating: [], count: n + 1)

func setRoute(n: Int, p: Int) {
    route[n].formUnion(route[p])
    route[n].insert(n)
    for c in con[n].c {
        setRoute(n: c, p: n)
    }
}

route[1].insert(1)
for c in con[1].c {
    setRoute(n: c, p: 1)
}

let q = readInt()

for _ in 1...q {
    var fromRoot: Set<Int> = []
    var usedNodes: Set<Int> = []
    
    func countUnusedEdges(n: Int, unusedEdges: Int) -> Int {
        if usedNodes.contains(n) {
            return unusedEdges
        }
        var hit = 0
        var next = -1
        for c in con[n].c {
            if fromRoot.contains(c) {
                hit += 1
                next = c
                if hit >= 2 {
                    break
                }
            }
        }
        if hit >= 2 {
            return unusedEdges
        } else {
            return countUnusedEdges(n: next, unusedEdges: unusedEdges + 1)
        }
    }    
    
    let kv = readIntArray()
    for v in kv[1..<kv.count] {
        usedNodes.insert(v)
        fromRoot.formUnion(route[v])
    }
    let unusedEdges = countUnusedEdges(n: 1, unusedEdges: 0)
    print(fromRoot.count - 1 - unusedEdges)
}
