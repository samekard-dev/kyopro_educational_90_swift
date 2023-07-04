import Foundation

let n = Int(readLine()!)!

if n == 1 {
    _ = readLine()
    _ = readLine()
    print(1)
    exit(0)
}

let ss: [Int] = readLine()!.map {
    switch $0 {
        case "R":
            return 0
        case "G":
            return 1
        case "B":
            return 2
        default:
            return -1
    }
}
let tt: [Int] = readLine()!.map {
    switch $0 {
        case "R":
            return 2
        case "G":
            return 1
        case "B":
            return 0
        default:
            return -1
    }
}
var s: [Int] = []
for i in 1..<n {
    s.append((ss[i] - ss[i - 1] + 3) % 3)
}
var t: [Int] = []
for i in 1..<n {
    t.append((tt[i] - tt[i - 1] + 3) % 3)
}

func zAlgorithm(a: [Int]) -> [Int] {
    let n = a.count
    var ans = [Int](repeating: 0, count: n)
    ans[0] = n
    var l = -1 //l: 範囲の開始
    var r = -1 //r: 範囲のひとつ外
    for i in 1..<n {
        //状態1: l == -1 普通の処理
        //状態2: l >= 1 i < r 特殊処理と普通の処理
        //状態3: l >= 1 i >= r 普通の処理
        if l != -1 && i < r {
            //特殊処理
            ans[i] = min(ans[i - l], r - i)
        }
        while i + ans[i] < n && a[ans[i]] == a[i + ans[i]] {
            //普通の処理
            ans[i] += 1
        }
        if ans[i] != 0 && i + ans[i] > r {
            l = i
            r = i + ans[i]
        }
    }
    return ans
}

let n2 = s.count
var ans = 0
let st = zAlgorithm(a: s + t)
for i in n2..<2 * n2 {
    if st[i] == 2 * n2 - i {
        ans += 1
    }
}
let ts = zAlgorithm(a: t + s)
for i in n2 + 1..<2 * n2 { //stとtsで同じものをカウントするのを避けるためスタートをずらす
    if ts[i] == 2 * n2 - i {
        ans += 1
    }
}

print(ans + 2) //+ 2は端の右上と左下の2つ
