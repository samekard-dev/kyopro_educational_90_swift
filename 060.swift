func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let a = readInts()

var lDown = [Int](repeating: 0, count: n)//その場所から左の最大左下降はいくつか
var rDown = [Int](repeating: 0, count: n)//その場所から右の最大右下降はいくつか

var progLDown = [Int](repeating: Int.max, count: n + 1)
progLDown[0] = 0
var progRDown = [Int](repeating: Int.max, count: n + 1)
progRDown[0] = 0
//progLDown[t] < a[i] <= progLDown[t + 1]のときiの左にはt個の下り坂が形成されている

//左への下り坂の情報を左から調べる。
for i in 0..<n {
    var l = 0
    var r = n
    while l + 1 < r {
        let mid = (l + r) / 2
        if a[i] <= progLDown[mid] {
            r = mid
        } else {
            l = mid
        }
    }
    lDown[i] = l
    progLDown[r] = a[i]
}

//右への下り坂の情報を右から調べる
for i in (0..<n).reversed() {
    var l = 0
    var r = n
    while l + 1 < r {
        let mid = (l + r) / 2
        if a[i] <= progRDown[mid] {
            r = mid
        } else {
            l = mid
        }
    }
    rDown[i] = l
    progRDown[r] = a[i]
}

var ans = 0
for i in 0..<n {
    ans = max(ans, lDown[i] + rDown[i] + 1)
}
print(ans)

