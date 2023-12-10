func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var routes = [[(city: Int, time: Int)]](repeating: [], count: n)

for _ in 0..<m {
    let input = readInts()
    routes[input[0] - 1].append((city: input[1] - 1, time: input[2]))
    routes[input[1] - 1].append((city: input[0] - 1, time: input[2]))
}

//ここからpriority queue

struct Element {
    var city: Int = 0
    var time: Int = 0
}

var pq: [Element] = []

func comparePQ(p: Element, c: Element) -> Bool {
    //変更すべきならtrue
    return p.time > c.time
}

func up(_ n: Int) {
    var current = n
    while current != 0 {
        let p = (current - 1) / 2
        if comparePQ(p: pq[p], c: pq[current]) {
            let temp = pq[p]
            pq[p] = pq[current]
            pq[current] = temp
            current = p
        } else {
            break
        }
    }
}

func down(_ n: Int) {
    let c1 = n * 2 + 1
    let c2 = n * 2 + 2
    var target = n
    if c1 < pq.count {
        if comparePQ(p: pq[target], c: pq[c1]) {
            target = c1
        }
    }
    if c2 < pq.count {
        if comparePQ(p: pq[target], c: pq[c2]) {
            target = c2
        }
    }
    if target != n {
        let temp = pq[target]
        pq[target] = pq[n]
        pq[n] = temp
        down(target)
    }
}

func pop() -> Element? {
    guard pq.count != 0 else {
        return nil
    }
    let ret = pq[0]
    pq[0] = pq[pq.count - 1]
    pq.removeLast()
    if pq.count != 0 {
        down(0)
    }
    return ret
}

func push(_ d: Element) {
    pq.append(d)
    up(pq.count - 1)
}

//ここまでpriority queue

var distance1 = [Int](repeating: Int.max, count: n)
var distanceN = [Int](repeating: Int.max, count: n)

pq = []
push(Element(city: 0, time: 0))

/*
 ある街までの行き方が2つある場合は両方ともデータを作成して突っ込む
 距離が近い方のデータが先に出てくるのでその時点で値を確定させる
 距離が遠い方のデータが出てきても値が確定しているからスルーさせる
 */
while let top = pop() {
    guard distance1[top.city] == Int.max else {
        continue
    }
    distance1[top.city] = top.time
    for nc in routes[top.city] { //neighbor city
        push(Element(city: nc.city, time: top.time + nc.time))
    }
}

pq = []
push(Element(city: n - 1, time: 0))

while let top = pop() {
    guard distanceN[top.city] == Int.max else {
        continue
    }
    distanceN[top.city] = top.time
    for nc in routes[top.city] { //neighbor city
        push(Element(city: nc.city, time: top.time + nc.time))
    }
}

for i in 0..<n {
    print(distance1[i] + distanceN[i])
}
