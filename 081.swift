func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readInts()
let n = nk[0]
let k = nk[1]
let k2 = k + 1 //差がkなら端から端まで全部でいくつか。例:差が3なら全部で4

var a: [Int] = [] //身長
var b: [Int] = [] //体重

for _ in 0..<n {
    let input = readInts()
    a.append(input[0])
    b.append(input[1])
}

//rとcはインデックスの最大
let r = max(a.max()!, k2) //差が5なら1から6の範囲が最低必要
let c = max(b.max()!, k2)

var sum = [[Int]](repeating: [Int](repeating: 0, count: c + 1), count: r + 1)

for i in 0..<n {
    let temp = sum[a[i]][b[i]]
    sum[a[i]][b[i]] = temp + 1
}

for i in 1...r {
    for j in 1...c {
        let temp1 = sum[i - 1][j]
        let temp2 = sum[i][j]
        sum[i][j] = temp1 + temp2
    }
}

for i in 1...r {
    for j in 1...c {
        let temp1 = sum[i][j - 1]
        let temp2 = sum[i][j]
        sum[i][j] = temp1 + temp2
    }
}

var ans = 0
for i in k2...r {
    for j in k2...c {
        let count = sum[i][j] - sum[i][j - k2] - sum[i - k2][j] + sum[i - k2][j - k2]
        ans = max(ans, count)
    }
}

print(ans)
