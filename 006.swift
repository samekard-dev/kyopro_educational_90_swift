let aAscii = Character("a").asciiValue!

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readInts()
let n = nk[0]
let k = nk[1]

let s = Array(readLine()!)

//Swiftの2次元配列は速度の問題があるので1次元配列を用いる
var next = [Int](repeating: 0, count: (n + 1) * 26)
for c in 0..<26 {
    next[(n + 1) * c + n] = n
}
for i in stride(from: n - 1, through: 0, by: -1) {
    for c in 0..<26 {
        next[(n + 1) * c + i] = next[(n + 1) * c + i + 1]
    }
    let c = Int(s[i].asciiValue! - aAscii)
    next[(n + 1) * c + i] = i
}

var answer: [Character] = []
var currentPos = 0
for o in 0..<k { //order
    /*
     1文字目を決める。aはOK? bはOK?...
     2文字目を決める。aはOK? bはOK?...
     :
     
     各処理で残り文字が足りなくなるのを避けるようにする
     */
    let req = k - o //あと何文字必要か
    for c in 0..<26 {
        let nextPos = next[(n + 1) * c + currentPos]
        let amount = n - nextPos //あと何文字後ろにあるか(nextPos含む)
        if amount >= req {
            answer.append(s[nextPos])
            currentPos = nextPos + 1
            break
        }
    }
}

print(answer.map({ String($0) }).joined())
