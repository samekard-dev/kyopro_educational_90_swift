func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()
var users: Set<String> = []

for i in 1...n {
	let user = readLine()!
	if users.contains(user) == false {
		print(i)
		users.insert(user)
	} 
}
