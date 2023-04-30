let tenNineSeven = 1000000007

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readInts()
let h = hw[0]
let w = hw[1]

var field = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)

for i in 0..<h {
    let input = Array(readLine()!)
    for j in 0..<w {
        if input[j] == "#" {
            field[i][j] = true
        }
    }
}

let put = 1 << w

var dic: [Int : Int] = [:]
dic[0] = 1
for i in 0..<h {
    for j in 0..<w {
        var newDic: [Int : Int] = [Int : Int](minimumCapacity: 100000)
        if field[i][j] {
            for (key, value) in dic {
                newDic[key / 2] = (newDic[key / 2, default: 0] + value) % tenNineSeven
            }
        } else {
            let tl = j == 0 ? 0 : 1 //左上
            let tc = 2 //上
            let tr = j == w - 1 ? 0 : 4 //右上
            let cl = j == 0 ? 0 : put //左
            let komaCheck = tl | tc | tr | cl
            for (key, value) in dic {
                let newKey = key / 2
                if key & komaCheck == 0 {
                    newDic[newKey + put] = (newDic[newKey + put, default: 0] + value) % tenNineSeven
                }
                newDic[newKey] = (newDic[newKey, default: 0] + value) % tenNineSeven
            }
        }
        dic = newDic
    }
}

var sum = 0
for v in dic.values {
    sum += v
    sum %= tenNineSeven
}

print(sum)
