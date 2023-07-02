//1から2の文字を動かすなら境0と境2をつなげる
//4から8の文字を動かすなら境3と境8をつなげる
//境0 字1 境1 字2 境2 字3 境3 字4 ...

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

struct Edge {
    let c: Int
    let l: Int
    let r: Int
}

var edges: [Edge] = []

for _ in 0..<m {
    let input = readInts()
    edges.append(Edge(c: input[0], l: input[1] - 1, r: input[2]))
}
edges.sort { $0.c < $1.c }

var root = (0...n).map({ $0 })
func getRoot(n: Int) -> Int {
    if root[n] == n {
        return n
    }
    root[n] = getRoot(n: root[n])
    return root[n]
}

var counter = 0
var value = 0
for e in edges {
    let r1 = getRoot(n: e.l)
    let r2 = getRoot(n: e.r)
    if r1 != r2 {
        if r1 < r2 {
            root[r2] = r1
        } else if r1 > r2 {
            root[r1] = r2
        }
        counter += 1
        value += e.c
    }
}

if counter == n {
    print(value)
} else {
    print("-1")
}
