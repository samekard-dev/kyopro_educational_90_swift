class UnionFind {
    let n: Int
    var par: [Int]
    init(n: Int) {
        self.n = n
        par = []
        (0..<n).forEach { i in
            par.append(i)
        }
    }
    func root(_ x: Int) -> Int {
        if par[x] != x {
            par[x] = root(par[x])
        }
        return par[x]
    }
    func link(x: Int, y: Int) {
        if root(x) < root(y) {
            par[root(y)] = root(x)
        } else if root(y) < root(x) {
            par[root(x)] = root(y)
        }
    }
    func areConnected(x: Int, y: Int) -> Bool {
        return root(x) == root(y)
    }
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let qN = readInt()

var qs: [(t: Int, x: Int, y: Int, v: Int)] = []
for _ in 0..<qN {
    let q = readInts()
    qs.append((t: q[0], x: q[1] - 1, y: q[2] - 1, v: q[3]))
}

var sum = [Int](repeating: 0, count: n)
for q in qs {
    if q.t == 0 {
        sum[q.y] = q.v
    }
}

var potential = [Int](repeating: 0, count: n)
for i in 1..<n {
    potential[i] = sum[i] - potential[i - 1]
}

let uf = UnionFind(n: n)

for q in qs {
    if q.t == 0 {
        uf.link(x: q.x, y: q.y)
    }
    if q.t == 1 {
        if uf.areConnected(x: q.x, y: q.y) == false {
            print("Ambiguous")
        } else {
            if (q.x + q.y) % 2 == 0 {
                print(q.v + (potential[q.y] - potential[q.x]))
            } else {
                print((potential[q.y] + potential[q.x]) - q.v)
            }
        }
    }
}

