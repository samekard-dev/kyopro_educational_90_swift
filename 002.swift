func readInt() -> Int {
    Int(readLine()!)!
}

func hantei(s: [Character]) -> Bool {
    var dep = 0; //depth?
    for c in s {
        if c == "(" {
            dep += 1
        } else if c == ")" {
            dep -= 1
        }
        if dep < 0 {
            return false
        }
    }
    if dep == 0 {
        return true
    } else {
        return false
    }
}

let n = readInt() //1 ≦ n ≦ 20
for i in 0..<(1 << n) { //n = 1なら0..<2
    var candidate: [Character] = []
    for j in (0..<n).reversed() {
        // メモ : (i & (1 << j)) = 0 というのは、i の j ビット目（2^j の位）が 0 であるための条件。
        // 　　　頻出なので知っておくようにしましょう。        
        if i & (1 << j) == 0 {
            candidate.append("(")
        } else {
            candidate.append(")")
        }
    }
    if hantei(s: candidate) {
        print(candidate.map({ String($0) }).joined())
    }
}
