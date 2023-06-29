func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

var log2: [Int : Int] = [:]
do {
    var i = 1
    var j = 0
    for _ in 0...20 {
        log2[i] = j
        i *= 2
        j += 1
    }
}

let n = readInt()
//connection
var conn = [(p: Int, c: Set<Int>)](repeating: (p: -1, c: []), count: n + 1)
for _ in 1...n - 1 {
    let edge = readInts()
    conn[edge[0]].c.insert(edge[1])
    conn[edge[1]].c.insert(edge[0])
}
func setP(n: Int, p: Int) {
    conn[n].p = p
    conn[n].c.remove(p)
    for c in conn[n].c {
        setP(n: c, p: n)
    }
}
setP(n: 1, p: -1)

var h = [Int](repeating: -1, count: n + 1)
func setH(n: Int, hh: Int) {
    h[n] = hh
    for c in conn[n].c {
        setH(n: c, hh: hh + 1)
    }
}
setH(n: 1, hh: 0)

var order = [Int](repeating: -1, count: n + 1)
var orderCounter = 0
func setOrder(n: Int) {
    order[n] = orderCounter
    orderCounter += 1
    for c in conn[n].c {
        setOrder(n: c)
    }
}
setOrder(n: 1)

//ancestor:先祖
var acLength = 1
//description
var acDesc = 1 
while acDesc < n - 1 {
    acLength += 1
    acDesc *= 2
}
var ac = [[Int]](repeating: [Int](repeating: 1, count: acLength), count: n + 1)

var pass: [Int] = []

func setAc(n: Int, pass: inout [Int]) {
    var target = 1
    var pos = 0
    while target <= h[n] {
        ac[n][pos] = pass[pass.count - target]
        target *= 2
        pos += 1
    }
    
    pass.append(n)
    for c in conn[n].c {
        setAc(n: c, pass: &pass)
    }
    pass.removeLast()
}
setAc(n: 1, pass: &pass)

func searchAc(n: Int, d: Int) -> Int {
    if d == 0 {
        return n
    }
    let dd = d & (~d + 1) //最後のビット
    return searchAc(n: ac[n][log2[dd]!], d: d - dd)
}

func searchRoot(a: Int, b: Int, level: Int?) -> Int {
    if a == b {
        return a
    }
    let c = min(h[a], h[b])
    var aa = searchAc(n: a, d: h[a] - c)
    var bb = searchAc(n: b, d: h[b] - c)
    if aa == bb {
        return aa
    }
    for i in stride(from: acLength - 1, through: 0, by: -1) {
        if ac[aa][i] != ac[bb][i] {
            aa = ac[aa][i]
            bb = ac[bb][i]
        }
    }
    return ac[aa][0]
}

let q = readInt()
for _ in 0..<q {
    let nodes = Array(readInts().dropFirst(1)).sorted { order[$0] < order[$1] }
    var ans = 0
    for i in 0..<nodes.count {
        ans += h[nodes[i]]
        ans -= h[searchRoot(a: nodes[i], b: nodes[(i + 1) % nodes.count], level: nil)]
    }
    print(ans)
}
