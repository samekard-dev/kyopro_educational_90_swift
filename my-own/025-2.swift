func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nb = readInts()
let n = nb[0]
let b = nb[1]

/*
 m - f(m) = b
 m = b + f(m)
 
 iを「各桁の数字が昇順（同じ可）になっている値」とする
 すべてのiについて
 b + f(i)
 を求める
 この値の数字の出現(2が1個、4が2個..など)がiと同じになるかどうか確かめる。
 */

var ans = 0

var field = [Int](repeating: 0, count: 11)
var count = [Int](repeating: 0, count: 10)

func checkSeed(k: Int) {
    //candidate:候補
    var cand = 1
    for i in 0..<k {
        cand *= field[i]
    }
    cand += b
    guard cand <= n else {
        return
    }
    var candCount = [Int](repeating: 0, count: 10)
    while cand != 0 {
        candCount[cand % 10] += 1
        cand /= 10
    }
    var result = true
    for i in 0..<10 {
        if candCount[i] != count[i] {
            result = false
            break
        }
    }
    if result {
        ans += 1
    }
}

var nk = 0
var nn = n
while nn != 0 {
    nk += 1
    nn /= 10
}

func makeSeed(bottom: Int, k: Int) {
    if k == nk {
        return
    }
    for i in bottom...9 {
        field[k] = i
        count[i] += 1
        checkSeed(k: k + 1)
        makeSeed(bottom: i, k: k + 1)
        count[i] -= 1
    }
}

makeSeed(bottom: 1, k: 0)

if b <= n && String(b).map({ $0 }).contains("0") {
    ans += 1
}

print(ans)
