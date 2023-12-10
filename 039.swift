func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

var e = [[Int]](repeating: [], count: n)
var a = [Int](repeating: -1, count: n - 1)
var b = [Int](repeating: -1, count: n - 1)

for i in 0...n - 2 {
    let ab = readInts()
    e[ab[0] - 1].append(ab[1] - 1)
    e[ab[1] - 1].append(ab[0] - 1)
    a[i] = ab[0] - 1
    b[i] = ab[1] - 1
}

var counter = [Int](repeating: 0, count: n)

func dfs(pos: Int, pre: Int) {
    counter[pos] = 1
    for i in e[pos] {
        if i == pre {
            continue
        }
        dfs(pos: i, pre: pos)
        counter[pos] += counter[i]
    }
}

dfs(pos: 0, pre: -1)

var ans = 0
for i in 0...n - 2 {
    let r = min(counter[a[i]], counter[b[i]])
    ans += r * (n - r)
}
print(ans)
