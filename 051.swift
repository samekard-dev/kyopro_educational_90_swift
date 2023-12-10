import Foundation //exit文用

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nkp = readInts()
let n = nkp[0]
let k = nkp[1]
let p = nkp[2]

let a = readInts()

if n == 1 {
    if a[0] <= p {
        print(1)
    } else {
        print(0)
    }
    exit(0)
}

let mid = n / 2

var a1 = [[Int]](repeating: [], count: mid + 1)
var a2 = [[Int]](repeating: [], count: n - mid + 1)

for i in 0..<(1 << mid) {
    var cnt1 = 0
    var cnt2 = 0
    for j in 0..<mid {
        if i & 1 << j != 0 {
            cnt1 += a[j]
            cnt2 += 1
        }
    }
    a1[cnt2].append(cnt1)
}

for i in 0..<(1 << (n - mid)) {
    var cnt1 = 0
    var cnt2 = 0
    for j in 0..<(n - mid) {
        if i & 1 << j != 0 {
            cnt1 += a[mid + j]
            cnt2 += 1
        }
    }
    a2[cnt2].append(cnt1)
}


for i in 0..<a1.count {
    a1[i].sort(by: <)
}

for i in 0..<a2.count {
    a2[i].sort(by: <)
}

var ans = 0

for s1 in 0...k {
    let s2 = k - s1
    if s1 < a1.count && s2 < a2.count {
        var iA1 = a1[s1].count - 1
        var iA2 = 0
        while iA1 >= 0 && iA2 < a2[s2].count {
            if a1[s1][iA1] + a2[s2][iA2] <= p {
                iA2 += 1
            } else {
                ans += iA2
                iA1 -= 1
            }
        }
        if iA2 == a2[s2].count {
            ans += (iA1 + 1) * iA2
        }
    }
}

print(ans)
