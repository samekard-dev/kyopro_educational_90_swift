///模範回答を改
///書き込み時のLazyに書き込みをシンプルにした。
///書き込み関数に戻り値を追加する必要が出てきたので戻り値を追加。

///遅延セグメント木を使う

///広い範囲のデータと狭い範囲のデータを両立させる構造
///範囲が1から4のとき7つ範囲のデータを持つ。各範囲は1-4 1-2 3-4 1 2 3 4
///1-4のデータをインデックス[1]に収める、以降は上の順番である。(世の中には0から始まるタイプもある。どちらでもよい)
///インデックスkの範囲の左半分はインデックスk*2、右半分はインデックスk*2+1が担当する

///範囲が1-4 1-2 3-4 1 2 3 4の7つのとき
///(このプログラムでは)1-4側を「上」、1 2 3 4側を「下」と表現する

///名前のLazyとは何か
///書き込み処理(実行したら量が多い)を必要が生じるまで先送りにする
///lazy[k]がsleep以外の場合、本来はその範囲全部(下のものも含めて)がlazy[k]の値であるべきだが
///書き込み処理が保留されている状態である
///ただし、lazy[k]の値であるべきというのは書き込まれた時点での話であるので後から無効になることがある

///最小値、最大値のどっちが欲しいかは状況によって違うので初期化時に指定する
///中に入れる値は0以上を想定している
///最大値が欲しいとき
///     最強 Int.max
///     最弱(デフォルト値) 0
///     -1 特殊な意味
///最小値が欲しいとき
///     最弱(デフォルト値) Int.max
///     最強 0
///     -1 特殊な意味

class LazySegmentTree {
    
    static let sleep = -1
    
    let size: Int
    var seg: [Int] //その範囲で一番最大(or最小)の値
    var lazy: [Int] //その範囲(下も含む)はこの値に設定すべき(ただし後から無効になることがある)
    let firstValue: Int
    let compare: (Int, Int) -> Int
    
    init(n: Int, compare: @escaping (Int, Int) -> Int) {
        var s = 1
        while s < n {
            s *= 2
        }
        size = s
        let fv = Int.max - compare(Int.max, 0)
        self.firstValue = fv
        self.compare = compare
        
        seg = [Int](repeating: fv, count: s * 2)
        lazy = [Int](repeating: LazySegmentTree.sleep, count: s * 2)
    }
    
    private func settle(_ k: Int) {
        //kの範囲に未処理データ(lazy[k]がsleep以外)がある場合、自分の場所(k)のみ確定させる
        guard lazy[k] != LazySegmentTree.sleep else {
            return
        }
        if k < size {
            lazy[k * 2] = lazy[k]
            lazy[k * 2 + 1] = lazy[k]
        }
        seg[k] = lazy[k]
        lazy[k] = LazySegmentTree.sleep
    }
    
    ///tl,tr:更新したい範囲
    ///x:更新したい値
    ///k:範囲を表すインデックス
    ///l,r:そのkが担当する範囲
    ///下への書き込みはlazyを使ってサボっても良いが、上に対しては本来の値を返す。
    private func update(tl: Int, tr: Int, x: Int, k: Int, l: Int, r: Int) -> Int {
        settle(k)
        if tr <= l || r <= tl {
            //重なり部分がないとき
            return seg[k]
        }
        if tl <= l && r <= tr {
            //更新したい範囲が、扱う範囲(kの範囲)を完全に覆っている
            //lazyを書き込む
            lazy[k] = x
            return x
        }
        let lc = update(tl: tl, tr: tr, x: x, k: k * 2, l: l, r: (l + r) / 2)
        let rc = update(tl: tl, tr: tr, x: x, k: k * 2 + 1, l: (l + r) / 2, r: r)
        seg[k] = compare(lc, rc)
        return seg[k]
    }
    
    ///tl,tr:調べたい範囲
    ///k:範囲を表すインデックス
    ///l,r:そのkが担当する範囲
    private func check(tl: Int, tr: Int, k: Int, l: Int, r: Int) -> Int {
        settle(k)     
        if tr <= l || r <= tl {
            //重なり部分がないとき
            return firstValue
        }        
        if tl <= l && r <= tr {
            //更新したい範囲が、扱う範囲(kの範囲)を完全に覆っている
            return seg[k]
        }
        let lc = check(tl: tl, tr: tr, k: k * 2, l: l, r: (l + r) / 2)
        let rc = check(tl: tl, tr: tr, k: k * 2 + 1, l: (l + r) / 2, r: r)
        return compare(lc, rc)
    }
    
    func update(tl: Int, tr: Int, x: Int) {
        _ = update(tl: tl, tr: tr, x: x, k: 1, l: 0, r: size)
    }
    
    func check(tl: Int, tr: Int) -> Int {
        return check(tl: tl, tr: tr, k: 1, l: 0, r: size)
    }
}

//ここから典型90問の29

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readInts()
let w = wn[0]
let n = wn[1]

let lst = LazySegmentTree(n: w) { max($0, $1) }

for _ in 0..<n {
    let input = readInts()
    //与えられるのは 1から始まる値だが1下げて使用する
    //例えば1から5のときは0..<5として扱う。
    let height = lst.check(tl: input[0] - 1, tr: input[1]) + 1
    lst.update(tl: input[0] - 1, tr: input[1], x: height)
    print(height)
}


