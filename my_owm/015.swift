func readInt() -> Int {
    Int(readLine()!)!
}

let mod = 1000000000 + 7
let n = readInt()

for k in 1...n {
    var data1 = [Int](repeating: 0, count: n + 1)
    var data2 = [Int](repeating: 0, count: n + 1)
    //data1 : そのボールを選択した時の、そのボール以降の選び方
    //  その1 : そのボールのみ選択する
    //  その2 : そのボールを選択し、+k以降で最低1個選ぶ
    //data2 : そのボールの選択に関係なく、そのボール以降の選び方（ただし最低1個は選ぶ）
    //  その1 : そのボールを選択する
    //  その2 : そのボールは選択しない
    data1[n] = 1
    data2[n] = 1
    for i in (1..<n).reversed() {
        data1[i] = 1
        if i + k <= n {
            data1[i] += data2[i + k]
            if data1[i] >= mod {
                data1[i] -= mod
            }
        }
        data2[i] = data1[i] + data2[i + 1] 
        if data2[i] >= mod {
            data2[i] -= mod
        }
    }
    print(data2[1])
}
