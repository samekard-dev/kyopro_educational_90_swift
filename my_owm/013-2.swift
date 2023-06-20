func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var conn = [[(n: Int, cost: Int)]](repeating: [], count: n)

for _ in 0..<m {
    let input = readInts()
    conn[input[0] - 1].append((n: input[1] - 1, cost: input[2]))
    conn[input[1] - 1].append((n: input[0] - 1, cost: input[2]))
}

//ヒープソートの変形
var value: [Int] = [] //value[i]は、街iの値
var pos: [Int] = [] //pos[i]は、街iがheapのどこにあるか
var heap: [Int] = []
var result: [Int] = []

func initialize(n: Int) {
    value = [Int](repeating: Int.max, count: n)
    pos = [Int](repeating: 0, count: n) //pos[i]は、街iがheapのどこにあるか
    heap = [Int](repeating: 0, count: n)
    result = [Int](repeating: Int.max, count: n)

    for i in 0..<n {
        pos[i] = i
        heap[i] = i
    }
}

func change(a: Int, b: Int) {
    let cityA = heap[a]
    let cityB = heap[b]
    pos[cityA] = b
    pos[cityB] = a
    heap[a] = cityB
    heap[b] = cityA
}

func pop() {
    change(a: 0, b: heap.count - 1)
    heap.removeLast()
    if heap.count > 0 {
        down(n: 0)
    }
}

func down(n: Int) {
    var baseValue = value[heap[n]]
    var target: Int? = nil
    if 2 * n + 1 <= heap.count - 1 {
        let opValue = value[heap[2 * n + 1]] //opposite
        if opValue < baseValue {
            target = 2 * n + 1
            baseValue = opValue
        }
    }
    if 2 * n + 2 <= heap.count - 1 {
        let opValue = value[heap[2 * n + 2]]
        if opValue < baseValue {
            target = 2 * n + 2
            baseValue = opValue
        }
    }
    if let target = target {
        change(a: n, b: target)
        down(n: target)
    }
}

func up(n: Int) {
    if n == 0 {
        return
    }
    let p = (n - 1) / 2
    if value[heap[p]] > value[heap[n]] {
        change(a: n, b: p)
        up(n: p)
    }
}

func exe(start: Int) {
    initialize(n: n)
    value[start] = 0
    up(n: pos[start])
    
    while heap.count != 0 {
        let popN = heap[0]
        result[popN] = value[popN]
        pop()
        for nn in conn[popN] {
            if value[popN] + nn.cost < value[nn.n] {
                value[nn.n] = value[popN] + nn.cost
                up(n: pos[nn.n])
            }
        }
    }
}

var answer = [Int](repeating: 0, count: n)

exe(start: 0)

for i in 0..<n {
    answer[i] = result[i]
}

exe(start: n - 1)

for i in 0..<n {
    answer[i] += result[i]
}

for i in 0..<n {
    print(answer[i])
}
