//人も区間も0-index

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var time: [[Int]] = [] //time[人][区間]
for _ in 0..<n {
    time.append(readInts())
}

let m = readInt()
var chain = [[Bool]](repeating: [Bool](repeating: true, count: n), count: n)
for _ in 0..<m {
    let pair = readInts()
    chain[pair[0] - 1][pair[1] - 1] = false
    chain[pair[1] - 1][pair[0] - 1] = false
}

struct Pattern: Hashable {
    var all: Int
    var last: Int
}
var data = [[Pattern : Int]](repeating: [:], count: n)
//data[0][**] 区間0の情報
//data[1][**] 区間1の情報

//data[2][Pattern(all: 7, last: 2)] 区間0から区間2を0,1,2の人が走り、最後の走者は2だったときの最短時間

for i in 0..<n { //i:人
    data[0][Pattern(all: 1<<i, last: i)] = time[i][0]
}

for i in 1..<n { //i:区間
    for (p, t) in data[i - 1] {
        for new in 0..<n { //new:人
            if p.all & 1<<new == 0 && chain[p.last][new] {
                let newAll = p.all | 1<<new
                let current = data[i][Pattern(all: newAll, last: new)] ?? Int.max
                data[i][Pattern(all: newAll, last: new)] = min(current, t + time[new][i])
            } else {
                continue
            }
        }
    }
}

var ans = Int.max
for d in data[n - 1] {
    ans = min(ans, d.value)
}
if ans == Int.max {
    print("-1")
} else {
    print(ans)
}
