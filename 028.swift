//2次元配列の読み書きは標準的なやり方。これはたしか速度が遅くなるバグ（？）がある。

func readInt() -> Int {
    Int(readLine()!)!
}

func readIntArray() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let range = 1000

let n = readInt()
var f1 = [[Int]](repeating: [Int](repeating: 0, count: range + 1), count: range + 1)
var f2 = [[Int]](repeating: [Int](repeating: 0, count: range), count: range)

for _ in 1...n {
    let area = readIntArray()
    f1[area[1]][area[0]] += 1
    f1[area[3]][area[0]] -= 1
    f1[area[1]][area[2]] -= 1
    f1[area[3]][area[2]] += 1
}

for y in 0..<range {
    var current = 0
    for x in 0..<range {
        current += f1[y][x]
        f2[y][x] = current
    }
}

var piles = [Int](repeating: 0, count: n + 1)

for x in 0..<range {
    var current = 0
    for y in 0..<range {
        current += f2[y][x]
        piles[current] += 1
    }
}

for i in 1...n {
    print(piles[i])
}
