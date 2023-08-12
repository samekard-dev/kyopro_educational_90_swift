func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nw = readInts()
let n = nw[0]
let w = nw[1] //家に入るときに払う金

let aa = readInts() //家にある金

struct Edge {
    let to: Int
    let me: Int
    let all: Int
    var cap: Int
}

struct Dinic {
    var conn: [[Edge]]
    var level: [Int]
    var inter: [Int]
    var q: [Int]
    
    init(size: Int) {
        self.conn = [[Edge]](repeating: [], count: size)
        self.level = [Int](repeating: -1, count: size)
        self.inter = [Int](repeating: -1, count: size)
        self.q = [Int](repeating: -1, count: size)
    }
    
    mutating func addEdge(u: Int, v: Int, c: Int) {
        //meは相手にとって自分は何番目なのか
        let countU = conn[u].count
        let countV = conn[v].count
        conn[u].append(Edge(to: v, me: countV, all: c, cap: c))
        conn[v].append(Edge(to: u, me: countU, all: c, cap: 0))
    }
    
    mutating func bfs(s: Int) {
        var current = 0
        var next = 0
        q[next] = s
        next += 1
        level[s] = 0
        while current < next {
            let v = q[current]
            current += 1
            for c in conn[v] {
                if c.cap == 0 || level[c.to] != -1 {
                    continue
                }
                q[next] = c.to
                next += 1
                level[c.to] = level[v] + 1
            }
        }
    }
    
    mutating func dfs(pos: Int, to: Int, f: Int) -> Int {
        if pos == to {
            return f
        }
        for i in inter[pos]..<conn[pos].count {
            inter[pos] += 1
            let c = conn[pos][i]
            if c.cap > 0 && level[pos] < level[c.to] {
                let z = dfs(pos: c.to, to: to, f: min(f, c.cap))
                if z != 0 {
                    conn[pos][i].cap = c.cap - z
                    //Swiftの2次元配列の読み&書き遅い問題があるので
                    //a[][] -= xxx
                    //という書き方を避ける
                    //そのためallを追加
                    conn[c.to][c.me].cap = c.all - (c.cap - z)
                    return z
                }
            }
        }
        return 0
    }
    
    mutating func maxFlow(s: Int, t: Int) -> Int {
        var ret = 0
        while true {
            for i in 0..<level.count {
                level[i] = -1
            }
            bfs(s: s)
            if level[t] == -1 {
                break
            }
            for i in 0..<inter.count {
                inter[i] = 0
            }
            while true {
                let f = dfs(pos: s, to: t, f: Int.max)
                if f == 0 {
                    break
                }
                ret += f                
            }
        }
        return ret
    }
}

var d = Dinic(size: n + 2)

for (i, a) in aa.enumerated() {
    d.addEdge(u: 0, v: i + 1, c: w)
    d.addEdge(u: i + 1, v: n + 1, c: a)
}

for i in 1...n {
    let input = readInts()
    for k in input[1...] {
        d.addEdge(u: i, v: k, c: Int.max)
    }
}

let aAll = aa.reduce(0, +)

print(aAll - d.maxFlow(s: 0, t: n + 1))
