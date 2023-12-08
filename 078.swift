func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var g = [[Int]](repeating: [], count: n)

for _ in 0..<m {
    let e = readInts()
    g[e[0] - 1].append(e[1] - 1)
    g[e[1] - 1].append(e[0] - 1)
}

var answer = 0

for i in 0..<n {
    var cnt = 0
    for j in g[i] {
        if j < i {
            cnt += 1
        }
    }
    if cnt == 1 {
        answer += 1
    }
}

print(answer)

