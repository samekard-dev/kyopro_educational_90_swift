func nextPermu(_ a: inout [Int]) -> Bool {
    
    guard a.count >= 2 else {
        return false //nextは存在しない
    }
    
    let last = a.count - 1
    
    //find key place
    var key = -1
    var right = a[last]
    for i in (0..<last).reversed() {
        if a[i] < right {
            key = i
            break
        }
        right = a[i]
    }
    guard key != -1 else {
        return false
    }
    
    /* 例 123654のとき
     last 5
     key 2
     順番交換範囲 3個
     順番交換インデックス 3から5
     */
    
    //keyより右をひっくり返す
    let turn = last - key //交換範囲
    /* 例
     turn1 交換作業なし
     turn2 交換作業1回
     turn3 交換作業1回（真ん中は必要なし）
     turn4 交換作業2回
     */
    
    for i in 0..<turn / 2 {
        let temp = a[last - i]
        a[last - i] = a[key + 1 + i]
        a[key + 1 + i] = temp
    }
    
    //keyより右で、初めにあるkeyより大きいものをkeyと交換
    for i in 1...last - key {
        if a[key + i] > a[key] {
            let temp = a[key]
            a[key] = a[key + i]
            a[key + i] = temp
            break
        }
    }
    return true
}

/*
var order = [1, 2, 3]

repeat {

} while (nextPermu(&order))
*/
