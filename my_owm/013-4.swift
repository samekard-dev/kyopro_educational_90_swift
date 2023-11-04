//Priority Queueにランダムアクセス機能を付けた

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

//ここからrandom access priority queue

enum Pos {
    case unmounted
    case mounted(Int)
    case fixed
}

struct Element {
    var key: Int {
        city
    }
    var city: Int = 0
    var time: Int = 0
}

var pq: [Element] = []
var pos: [Pos] = []

func comparePQ(p: Element, c: Element) -> Bool {
    //変更すべきならtrue
    return p.time > c.time
}

func change(_ a: Int, _ b: Int) {
    let temp = pq[a]
    pq[a] = pq[b]
    pq[b] = temp
    pos[pq[a].city] = .mounted(a)
    pos[pq[b].city] = .mounted(b)
}

func up(_ n: Int) {
    var current = n
    while current != 0 {
        let p = (current - 1) / 2
        if comparePQ(p: pq[p], c: pq[current]) {
            change(p, current)
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
        change(n, target)
        down(target)
    }
}

func pop() -> Element? {
    guard pq.count != 0 else {
        return nil
    }
    let ret = pq[0]
    change(0, pq.count - 1)
    pos[pq[pq.count - 1].key] = .fixed
    pq.removeLast()
    if pq.count != 0 {
        down(0)
    }
    return ret
}

func push(_ d: Element) {
    pq.append(d)
    pos[pq[pq.count - 1].key] = .mounted(pq.count - 1)
    up(pq.count - 1)
}

//ここまでrandom access priority queue

var distance1 = [Int](repeating: Int.max, count: n)
var distanceN = [Int](repeating: Int.max, count: n)

pq = []
pos = [Pos](repeating: .unmounted, count: n)
push(Element(city: 0, time: 0))

while let top = pop() {
    distance1[top.city] = top.time
    for nc in routes[top.city] { //neighbor city
        switch pos[nc.city] {
            case .unmounted:
                push(Element(city: nc.city, time: top.time + nc.time))
            case .mounted(let p):
                if top.time + nc.time < pq[p].time {
                    pq[p].time = top.time + nc.time
                    up(p)
                }
            case .fixed:
                break
        }
    }
}

pq = []
pos = [Pos](repeating: .unmounted, count: n)
push(Element(city: n - 1, time: 0))

while let top = pop() {
    distanceN[top.city] = top.time
    for nc in routes[top.city] { //neighbor city
        switch pos[nc.city] {
            case .unmounted:
                push(Element(city: nc.city, time: top.time + nc.time))
            case .mounted(let p):
                if top.time + nc.time < pq[p].time {
                    pq[p].time = top.time + nc.time
                    up(p)
                }
            case .fixed:
                break
        }
    }
}

for i in 0..<n {
    print(distance1[i] + distanceN[i])
}
