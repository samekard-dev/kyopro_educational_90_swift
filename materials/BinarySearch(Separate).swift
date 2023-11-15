///○○○○○××××××の境目を見つける
///与えられた範囲すべてが○やすべてが×のときにも対応している

func solve(m: Int) -> Bool {
    //下の領域に属するならtrue
    return m / 3 < 10
}

let bottom = 0
let top = 100
var left = bottom - 1 //この値はsolve(_)で調べることはない
var right = top + 1 //この値はsolve(_)で調べることはない
while right - left > 1 {  //最後は隣り合った2つになって抜ける
    let mid = left + (right - left) / 2
    if solve(m: mid) == false {
        right = mid
    } else {
        left = mid
    }
}

///○の右端ならleft、×の左端ならrightを見る
print(left)
