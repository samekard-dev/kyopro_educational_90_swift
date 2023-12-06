/*
 先端と末端の両方にO(1)で要素を追加/削除できる
 途中にアクセスするのはO(N)
 先端と末端はつながっていない
 */

class Cell {
    let x: Int
    let y: Int
    let dir: Int
    var pre: Cell?
    var next: Cell?
    
    init(x: Int, y: Int, dir: Int) {
        self.x = x
        self.y = y
        self.dir = dir
    }
}

class Deque {
    var first: Cell?
    var last: Cell?
    var count = 0
    
    func popFirst() -> Cell? {
        if count == 0 {
            return nil
        } else {
            let ret = first
            if count == 1 {
                first = nil
                last = nil
            } else {
                first = first!.next
                first!.pre = nil
                ret!.next = nil
            }
            count -= 1
            return ret
        }
    }
    
    func popLast() -> Cell? {
        if count == 0 {
            return nil
        } else {
            let ret = last
            if count == 1 {
                first = nil
                last = nil
            } else {
                last = last!.pre
                last!.next = nil
                ret!.pre = nil
            }
            count -= 1
            return ret
        }
    }
    
    func pushFirst(c: Cell) {
        if count == 0 {
            first = c
            last = c
        } else {
            c.next = first
            first!.pre = c
            first = c
        }
        count += 1
    }
    
    func pushLast(c: Cell) {
        if count == 0 {
            first = c
            last = c
        } else {
            c.pre = last
            last!.next = c
            last = c            
        }
        count += 1
    }
}
