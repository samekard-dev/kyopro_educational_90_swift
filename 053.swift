import Foundation

let golden = (pow(5.0, 1.0 / 2.0) - 1.0) / 2.0

func readInt() -> Int {
    Int(readLine()!)!
}

//入力: 範囲(lからrの距離)
//出力: 選択した場所。lまたはrの位置をを0とする。
func getNext(range: Int) -> Int {
    Int(Double(range) * golden + 0.5)
}

let t = readInt()

loop:
for _ in 1...t {
    
    let n = readInt()
    var values = [Int](repeating: 0, count: n + 2)
    
    //lとrは範囲の外側にセットする
    //1からnがデータ
    var l = 0
    var r = n + 1
    var c = getNext(range: n + 1)
    print("?", c)
    fflush(stdout)
    let cValue = readInt()
    if cValue == -1 {
        break
    }
    values[c] = cValue
    
    while true {
        let lRange = c - l
        let rRange = r - c
        if lRange == 1 && rRange == 1 {
            //lとrは最高値になることはないので真ん中を選択すればよい
            print("!", values[c])
            fflush(stdout)
            break
        }
        
        var new = 0
        if lRange > rRange {
            new = l + getNext(range: lRange)
        } else {
            new = r - getNext(range: rRange)
        }
        print("?", new)
        fflush(stdout)
        let newValue = readInt()
        if newValue == -1 {
            break loop
        }
        values[new] = newValue
        
        //vL vR 真ん中の2つの場所
        var vL = 0 //v: vertex: 頂点
        var vR = 0
        if new < c {
            vL = new
            vR = c
        } else {
            vL = c
            vR = new
        }
        
        //端をカットする
        if values[vL] > values[vR] {
            c = vL
            r = vR
        } else if values[vL] < values[vR] {
            c = vR
            l = vL
        } else {
            //values[vL] == values[vR]のときは間が必ず1つ以上存在する
            l = vL
            r = vR
            c = l + getNext(range: r - l)
            print("?", c)
            fflush(stdout)
            let cValue = readInt()
            if cValue == -1 {
                break loop
            }
            values[c] = cValue
        }
    }
}

/*
 取得する場所の図解
 状況によって左右反対もあり
 1 o
 2 _o
 3 _o_
 4 __o_
 5 ___o_
 6 ___o__
 7 ____o__
 8 _____o__
 9 _____o___
 10 ______o___
 11 ______o____
 12 _______o____
 13 ________o____
 14 ________o_____
 15 _________o_____
 16 __________o_____
 17 __________o______
 18 ___________o______
 19 ___________o_______
 
 */
