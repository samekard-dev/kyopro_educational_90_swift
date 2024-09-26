//この問題の方針について調べるときのキーワードは「グランディ数」

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let w = readInts()
let b = readInts()
let whiteBallMax = 50

//青が最大何個になるか。白の個数ごとに違う。白は0個〜whiteBallMax個
var blueBallMax = [Int](repeating: -1, count: whiteBallMax + 1)
blueBallMax[whiteBallMax] = 50
for w in stride(from: whiteBallMax, through: 1, by: -1) {
    blueBallMax[w - 1] = blueBallMax[w] + w
}

/*
 白:青
 50:50
 49:(50 + 50)
 48:(50 + 50 + 49)
 47:(50 + 50 + 49 + 48)
 2:(50 + 50 + ... + 4 + 3)
 1:(50 + 50 + ... + 4 + 3 + 2)
 0:(50 + 50 + ... + 4 + 3 + 2 + 1)
 
 つまり、青の最大数は
 50 + sum(1-50)
 これに0個を表すマスを追加して
 50 + sum(1-50) + 1 = sum(1-51) = 52 * 51 / 2
 よって52 * 51 / 2個のマスが必要
 */

//グランディ数を入れる
var table = [[Int]](repeating: [Int](repeating: -1, count: blueBallMax[0] + 1), count: whiteBallMax + 1)

for w in 0...whiteBallMax {
    //この問題のグランディ数の最大は実験結果より662
    var reachable = [Int](repeating: 0, count: 663)
    var minB = 1
    for b in 0...blueBallMax[w] {
        if w == 0 && b == 0 {
            table[w][b] = 0
            continue
        }
        if w == 0 && b == 1 {
            table[w][b] = 0
            continue
        }
        if b >= 2 {
            if minB < b - b / 2 {
                reachable[table[w][minB]] -= 1
                minB = b - b / 2
            }
            reachable[table[w][b - 1]] += 1
        }
        if w >= 1 {
            reachable[table[w - 1][b + w]] += 1
        }
        var i = 0
        while true {
            if reachable[i] == 0 {
                table[w][b] = i
                break
            }
            i += 1
        }
        if w >= 1 {
            reachable[table[w - 1][b + w]] -= 1
        }
    }
}

var sum = 0
for i in 0..<n {
    sum = sum ^ table[w[i]][b[i]]
}

if sum == 0 {
    //相手に操作させる
    print("Second")
} else {
    //自分が操作する
    print("First")
}


