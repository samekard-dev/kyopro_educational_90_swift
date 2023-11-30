func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let abc = readInts()
let a = abc[0]
let b = abc[1]
let c = abc[2]

var ans = Int.max
for i in 0...9999 {
    for j in 0...9999 - i {
        let v = n - (a * i + b * j)
        if v < 0 {
            break //break j loop
        }
        if v % c != 0 {
            continue
        }
        let r = i + j + v / c
        if r > 9999 {
            continue
        }
        ans = min(ans, r)
    }
}

print(ans)
