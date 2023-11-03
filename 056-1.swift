func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let ns = readInts()
let n = ns[0]
let s = ns[1]

var prices: [(a: Int, b: Int)] = [(Int, Int)](repeating: (0, 0), count: n + 1)

for i in 1...n {
    let p = readInts()
    prices[i] = (a: p[0], b: p[1])
}

var dp = [[Bool]](repeating: [Bool](repeating: false, count: s + 1), count: n + 1)
dp[0][0] = true

for d in 1...n {
    for p in 0...s {
        if p >= prices[d].a && dp[d - 1][p - prices[d].a] {
            dp[d][p] = true
        }
        if p >= prices[d].b && dp[d - 1][p - prices[d].b] {
            dp[d][p] = true
        }
    }
}

if dp[n][s] {
    var fb = [Bool](repeating: false, count: n + 1) //FukuBukuro
    var p = s
    for d in (1...n).reversed() {
        if p - prices[d].a >= 0 && dp[d - 1][p - prices[d].a] {
            fb[d] = true
            p -= prices[d].a
        } else {
            p -= prices[d].b
        }
    }
    print(fb.dropFirst().map({ $0 ? "A" : "B"}).joined())
} else {
    print("Impossible")
}

