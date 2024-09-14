func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]
var pos = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
for _ in 0..<m {
    let lr = readInts()
    pos[lr[0] - 1][lr[1] - 1] = 1
}
var sum = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
for l in 0..<n {
    for r in l..<n {
        if r == 0 {
            sum[l][r] = pos[l][r]
        } else {
            let pre = sum[l][r - 1]
            sum[l][r] = pre + pos[l][r]
        }
    }
    if l != 0 {
        for r in l..<n {
            let pre1 = sum[l - 1][r]
            let pre2 = sum[l][r]
            sum[l][r] = pre1 + pre2
        }
    }
}

var ans = 0
for l in 1..<n {
    for r in l..<n {
        if pos[l][r] == 1 {
            ans += sum[l - 1][r - 1] - sum[l][l]
        }
    }
}
print(ans)

