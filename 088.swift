func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readInts()
let n = nq[0]
let qN = nq[1]

let a = readInts()

var ngPair = [[Int]](repeating: [], count: n)
for _ in 0..<qN {
    let ng = readInts()
    ngPair[ng[0] - 1].append(ng[1] - 1)
}

var foundTwo = false
var foundOne: [Int : [Int]] = [:]
var answer: [[Int]] = []
var temp: [Int] = []
var ngFlag = [Int](repeating: 0, count: n)

func dfs(pos: Int, value: Int) {
    if foundTwo {
        return
    }
    if pos == n {
        //カードはn-1まで。そのひとつ先がn。
        if let first = foundOne[value] {
            answer.append(first)
            answer.append(temp)
            foundTwo = true
        } else {
            foundOne[value] = temp
        }
        return
    }
    
    //Not Choose
    dfs(pos: pos + 1, value: value)
    
    //Choose
    if ngFlag[pos] == 0 {
        temp.append(pos)
        for i in ngPair[pos] {
            ngFlag[i] += 1
        }
        dfs(pos: pos + 1, value: value + a[pos])
        for i in ngPair[pos] {
            ngFlag[i] -= 1
        }
        temp.removeLast()
    }
}

dfs(pos: 0, value: 0)

for a in answer {
    print(a.count)
    print(a.map{ String($0 + 1) }.joined(separator: " "))
}
