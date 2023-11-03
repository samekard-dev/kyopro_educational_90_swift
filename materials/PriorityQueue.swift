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
