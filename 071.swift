func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nmk = readInts()
let n = nmk[0] //ノード数
let m = nmk[1] //矢印の数
let k = nmk[2] //答の数

var arrow = [[Int]](repeating: [], count: n + 1) //矛先
var hold = [Int](repeating: 0, count: n + 1) //突き刺さっている数

for _ in 0..<m {
    let input = readInts()
    arrow[input[0]].append(input[1])
    hold[input[1]] += 1
}

//追加可能なノードのリスト
var zeroList = [(pre: Int, next: Int)](repeating: (pre: -1, next: -1), count: n + 1) 
zeroList[0].pre = 0
zeroList[0].next = 0

func addZeroList(i: Int) {
    let l = zeroList[0].pre
    zeroList[i].pre = l
    zeroList[i].next = 0
    zeroList[l].next = i
    zeroList[0].pre = i
}

func insZeroList(i: Int, after a: Int) {
    let n = zeroList[a].next
    zeroList[i].pre = a
    zeroList[i].next = n
    zeroList[a].next = i
    zeroList[n].pre = i
}

func delZeroList(i: Int) {
    let p = zeroList[i].pre
    let n = zeroList[i].next
    zeroList[p].next = n
    zeroList[n].pre = p
}

for i in 1...n {
    if hold[i] == 0 {
        addZeroList(i: i)
    }
}

enum Result {
    case progress
    case halt
}

var answer: [[Int]] = []

//作成中の配列。完成したら答に追加される
var candidate = [(value: Int, from: Int)](repeating: (value: -1, from: -1), count: n)

func search(depth: Int) -> Result {
    if zeroList[0].pre == 0 {
        return .halt
    }
    var current = zeroList[0].pre //一番最後から始めて、前へ移動する
    while current != 0 {
        candidate[depth].value = current
        candidate[depth].from = zeroList[current].pre
        delZeroList(i: current)
        for destination in arrow[current] {
            hold[destination] -= 1
            if hold[destination] == 0 {
                addZeroList(i: destination)
            }
        }
        if depth + 1 == n {
            answer.append(candidate.map { $0.value })
            if answer.count == k {
                return .halt
            }
        } else {
            let result = search(depth: depth + 1)
            if result == .halt {
                return .halt
            }
        }
        for destination in arrow[current] {
            //見つけたものとデリートするものが対応していないが
            //全体で5個あるならデリートするのも5個で、全体でつじつまをあわせる
            if hold[destination] == 0 {
                delZeroList(i: zeroList[0].pre)
            }
            hold[destination] += 1
        }
        insZeroList(i: current, after: candidate[depth].from)
        current = zeroList[current].pre
    }
    return .progress
}

_ = search(depth: 0)

if answer.count != k {
    print(-1)
} else {
    for a in answer {
        print(a.map { "\($0)" }.joined(separator: " "))
    }
}
