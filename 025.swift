import Foundation

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
 この値を昇順（同じ可）にしてiと同じになるかどうか確かめる。
 */

var ans = 0

func checkSeed(seed: String, k: Int) {
    //candidate:候補
    let cand = seed.map{ Int(String($0))! }.reduce(1, *) + b
    guard cand <= n else {
        return 
    }    
    let candChars = String(cand).map{ $0 }
    guard candChars.count == k else {
        return 
    }
    let candSortedStr = candChars.sorted().map{ String($0) }.joined()
    if seed == candSortedStr {
        ans += 1
    }
}

let nk = Int(log10(Double(n))) + 1 //9->1 10->2 99->2 100->3
func makeSeed(str: String, bottom: Int, k: Int) {
    if k == nk {
        return
    }
    for i in bottom...9 {
        let inStr = str + String(i)
        checkSeed(seed: inStr, k: k + 1)
        makeSeed(str: inStr, bottom: i, k: k + 1)
    }
}

makeSeed(str: "", bottom: 1, k: 0)

if b <= n && String(b).map({ $0 }).contains("0") {
    ans += 1
}

print(ans)
