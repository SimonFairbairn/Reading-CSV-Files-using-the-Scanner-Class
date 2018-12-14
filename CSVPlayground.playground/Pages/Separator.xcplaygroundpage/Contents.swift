//: [Previous](@previous)

import Foundation

let csvString = """
"Apple, Inc.","One Infinite Loop",Cupertino,CA,95014
"Google, Inc.","1600 Amphitheatre Parkway","Mountain View",CA,94043
"""

let lines = csvString.components(separatedBy: .newlines)
var cells : [String] = []
for line in lines {
	cells.append(contentsOf: line.components(separatedBy: ","))
}

print(cells)

//: [Next](@next)
