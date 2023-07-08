func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var arrows: [[Int]] = [[Int]](repeating: [], count: n + 1)
var revArrows: [[Int]] = [[Int]](repeating: [], count: n + 1)

for _ in 1...m {
    let input = readInts()
    arrows[input[0]].append(input[1])
    revArrows[input[1]].append(input[0])
}

var order1: [Int] = []
var done1 = [Bool](repeating: false, count: n + 1)
func dfs1(n: Int) {
    done1[n] = true
    for c in arrows[n] {
        if done1[c] == false {
            dfs1(n: c)
        }
    }
    order1.append(n)
}

for i in 1...n {
    if done1[i] == false {
        dfs1(n: i)
    }
}

let order2 = order1.reversed()
var done2 = [Bool](repeating: false, count: n + 1)
var counter = 0
var ans = 0

func dfs2(n: Int) {
    done2[n] = true
    counter += 1
    for c in revArrows[n] {
        if done2[c] == false {
            dfs2(n: c)
        }
    }
}

for i in order2 {
    if done2[i] == false {
        counter = 0
        dfs2(n: i)
        ans += counter * (counter - 1) / 2
    }
}

print(ans)
