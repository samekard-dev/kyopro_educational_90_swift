func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let a = readInts().sorted(by: <)

let q = readInt()
for _ in 0..<q {
    let rating = readInt()
    
    func solve(m: Int) -> Bool {
        return a[m] <= rating
    }
    
    let bottom = 0
    let top = a.count - 1
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
    
    var ans = Int.max
    if left >= bottom {
        ans = min(ans, rating - a[left])
    }
    if right <= top {
        ans = min(ans, a[right] - rating)
    }

    print(ans)
}
