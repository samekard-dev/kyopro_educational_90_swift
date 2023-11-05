func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readInts()
let w = wn[0]
let n = wn[1]

var blocks: [(l: Int, r: Int)] = []
for _ in 0..<n {
    let input = readInts()
    blocks.append((l: input[0], r: input[1]))
}

var posSet: Set<Int> = []
blocks.forEach { (l: Int, r: Int) in
    posSet.insert(l)
    posSet.insert(r)
}
var pos = Array(posSet).sorted(by: <)
var posDict: [Int : Int] = [:]
for (k, v) in pos.enumerated() {
    posDict[v] = k
}
blocks = blocks.map { (l: posDict[$0.l]!, r: posDict[$0.r]!) }

var height = [Int](repeating: 0, count: pos.count)
for b in blocks {
    var highest = 0
    for i in b.l...b.r {
        if height[i] > highest {
            highest = height[i]
        }
    }
    for i in b.l...b.r {
        height[i] = highest + 1
    }
    print(highest + 1)
}
