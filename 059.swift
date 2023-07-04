func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nmq = readInts()
let n = nmq[0]
let m = nmq[1]
let q = nmq[2]

var arrows: [(f: Int, t: Int)] = []
for _ in 0..<m {
    let input = readInts()
    arrows.append((f: input[0], t: input[1]))
}
arrows.sort { $0.f < $1.f }
var a: [Int] = []
var b: [Int] = []
for _ in 0..<q {
    let input = readInts()
    a.append(input[0])
    b.append(input[1])
}

let iEnd = (q - 1) / 64 //63->0 64->0 65->1 66->1
let jEnd = (q - 1) % 64 //63->62 64->63 65->0 66->1
for i in 0...iEnd {
    let je = i == iEnd ? jEnd : 63
    var dp = [Int](repeating: 0, count: n + 1)
    for j in 0...je {
        dp[a[i * 64 + j]] |= 1 << j
    }
    for arrow in arrows {
        dp[arrow.t] |= dp[arrow.f]
    }
    for j in 0...je {
        if dp[b[i * 64 + j]] & 1 << j != 0 {
            print("Yes")
        } else {
            print("No")
        }
    }
}
