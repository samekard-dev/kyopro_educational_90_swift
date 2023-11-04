func readInt() -> Int {
    Int(readLine()!)!
}

func readIntArray() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]

var roads: [[(d: Int, c: Int)]] = [[(Int, Int)]](repeating: [], count: n + 1)
for _ in 0..<m {
    let abc = readIntArray()
    roads[abc[0]].append((abc[1], abc[2]))
    roads[abc[1]].append((abc[0], abc[2]))
}

var answer = [Int](repeating: 0, count: n + 1)

//1から各ポイントへの最短時間を求める
var fromEdge = [Int](repeating: Int.max, count: n + 1)
fromEdge[1] = 0
var seed: [(Int)] = [1]
var seedIndex = 0
var seedCount = 1
execute()

for i in 1...n {
    answer[i] = fromEdge[i]
}

//Nから各ポイントへの最短時間を求める
fromEdge = [Int](repeating: Int.max, count: n + 1)
fromEdge[n] = 0
seed = [n]
seedIndex = 0
seedCount = 1
execute()

for i in 1...n {
    answer[i] += fromEdge[i]
}

func execute() {
    while seedIndex < seedCount {
        let from = seed[seedIndex]
        let currentValue = fromEdge[from]
        for dc in roads[from] {
            let to = dc.d
            let cost = dc.c
            if currentValue + cost < fromEdge[to] {
                fromEdge[to] = currentValue + cost
                seed.append(to)
                seedCount += 1
            }
        }
        seedIndex += 1
    }
}

for i in 1...n {
    print(answer[i])
}
