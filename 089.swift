class Bit {
    var maxValue = 0
    var indexOffset = 0
    var store: [Int]
    
    init(maxValue: Int, first: Int) {
        self.maxValue = maxValue
        self.indexOffset = 1 - first
        store = [Int](repeating: 0, count: maxValue + indexOffset + 1)
        //0-4 で指定するなら first=0 内部では 1-5 に変換されるので要素数6 
        //1-4 で指定するなら first=1 内部ではそのまま 1-4 なので要素数5 
    }
    
    func add(pos: Int, value: Int) {
        var pos2 = pos + indexOffset
        while pos2 <= maxValue {
            store[pos2] += value
            pos2 += pos2 & -pos2 //最終ビットを足す。例 1->2 6->8
        }
    }
    
    func sum(pos: Int) -> Int {
        var pos2 = pos + indexOffset
        var ans = 0
        while pos2 >= 1 {
            ans += store[pos2]
            pos2 -= pos2 & -pos2 //最終ビットを引く。例 5->4 10->8
        }
        return ans
    }
}

let mod = 1000000007

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readInts()
let n = nk[0]
let k = nk[1]

var a = readInts()
var b = Set(a).sorted() //重複を排除
var c: [Int : Int] = [:]
for (key, value) in b.enumerated() {
    c[value] = key + 1
}
let d = a.map { c[$0]! } //例 2, 16, 8, 5 -> 1, 4, 3, 2
let maxValue = b.count

let bit = Bit(maxValue: maxValue, first: 1)

var range = [Int](repeating: 0, count: n)
var l = 0
var r = 0
var current = 0
bit.add(pos: d[l], value: 1)

while true {
    while true {
        if current <= k {
            break
        }
        bit.add(pos: d[l], value: -1)
        current -= bit.sum(pos: d[l] - 1)
        l += 1
    }
    
    range[r] = l
    if r == n - 1 {
        break
    } else {
        r += 1
        current += r - l - bit.sum(pos: d[r])
        bit.add(pos: d[r], value: 1)
    }
}

var counter = [Int](repeating: 0, count: n)
var sumCounter = [Int](repeating: 0, count: n)

for i in 0..<n {
    if i == 0 {
        // 今未未未
        counter[0] = 1
        sumCounter[0] = 1
    } else {
        if range[i] == 0 {
            // 前今今今
            // ー前今今
            // ーー前今 以上がsumCounter[i - 1]の分
            // 今今今今 これが+1の分
            counter[i] = (sumCounter[i - 1] + 1) % mod
        } else if range[i] == 1 {
            // 前今今今
            // ー前今今
            // ーー前今
            counter[i] = sumCounter[i - 1]
        } else {
            // 前ーーーーー
            // ー前ーーーー sumCounter[range[i] - 2]
            // ーー前今今今
            // ーーー前今今
            // ーーーー前今 sumCounter[i - 1]
            counter[i] = (sumCounter[i - 1] - sumCounter[range[i] - 2] + mod) % mod
        }
        sumCounter[i] = (sumCounter[i - 1] + counter[i]) % mod
    }
}

print(counter[n - 1])
