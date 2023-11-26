//条件2は「高橋氏以外のものは〜」と解釈して実装

//人と論文を頂点とするグラフを作成する
//人と論文が辺で結ばれる
//人と人の距離は2倍になるので出力時に2で割る。

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

//gの構造は[人、人、人...人、論文、論文、論文...]
var g = [[Int]](repeating: [], count: n + m)

for i in 0..<m {
    _ = readInt()
    for j in readInts() {
        g[j - 1].append(n + i)
        g[n + i].append(j - 1)
    }
}

var current = 0
var dist = [Int](repeating: -2, count: n + m)
dist[0] = 0
var que: [Int] = [0]

while current < que.count {
    let t = que[current]
    for n in g[t] {
        if dist[n] == -2 {
            dist[n] = dist[t] + 1
            que.append(n)
        }
    }
    current += 1
}

for i in 0..<n {
    print(dist[i] / 2)
}
