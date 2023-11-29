func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

var e = [[Int]](repeating: [], count: n + 1)

for _ in 1...n - 1 {
    let edge = readInts()
    e[edge[0]].append(edge[1])
    e[edge[1]].append(edge[0])
}

var col = [Int](repeating: -1, count: n + 1)
var count1 = 0
var count2 = 0

func dfs(pos: Int, cur: Int) {
    col[pos] = cur
    if cur == 1 {
        count1 += 1
    } else {
        count2 += 1
    }
    for i in e[pos] {
        if col[i] == -1 {
            dfs(pos: i, cur: 3 - cur)
        }
    }
}

dfs(pos: 1, cur: 1)

var printVal = count1 >= count2 ? 1 : 2
var printCounter = 0
for i in 1...n {
    if col[i] == printVal {
        print(i, terminator: " ")
        printCounter += 1
        if printCounter == n / 2 {
            break
        }
    }
}
