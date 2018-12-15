//: Playground - noun: a place where people can play


import Cocoa

func scan( _ line : String, separatedBy separator : String = "," ) -> [String] {
	
	guard line.range(of: "\"") != nil else {
		return line.components(separatedBy: separator)
	}
	
	var cells: [String] = []
	var value:NSString?
	var separatorValue : NSString?
	let textScanner = Scanner(string: line)
	while !textScanner.isAtEnd {
		value = nil
		
		textScanner.scanString(" ", into: nil)
		
		// If the next item is a quote...
		if textScanner.scanString("\"", into: nil) {
			// Eat everything up until the next quote (incuding commas)
			textScanner.scanUpTo("\"", into: &value)
			// Disappear the second quote
			textScanner.scanString("\"", into: nil)
			// If there's anything in there, add it to the cells (blanks will be taken care of at the comma)
			if let hasValue = value as String? {
				// print("Adding first item: \(hasValue)")
				cells.append(hasValue)
			}
		}
		
		// If there has been a quoted item OR we're starting with an empty item, then this will be false. If not, then we have an unquoted item.
		if textScanner.scanUpTo(separator, into: &value) {
			// This time we need to keep hold of the scan result, as it will tell us if we're at the end of the line or not
			textScanner.scanString(separator, into: &separatorValue)
			// print("Adding second item: \(value! as String)")
			// Add the unquoted item
			cells.append(value! as String)
			// If the breakItem is not nil AND we're at the end of the line, then that means the last item of this line
			// was a comma. We need to add an empty item to represent the last (empty) cell
			if textScanner.isAtEnd, separatorValue != nil {
				// print("Found item up to end")
				cells.append("")
			}
		} else {
			// Eat the comma
			textScanner.scanString(separator, into: nil)
			// If we've reached this far, and the value is still nil, then either the first item was empty
			// or the string between the quotes was empty. Either way, add a blank item to represent it.
			if value == nil {
				// print("Adding blank item")
				cells.append("")
			}
			// Finally, we just ate a comma. If we're at the end, then that means the last item was a comma and we need to account for that
			if textScanner.isAtEnd {
				cells.append("")
			}
		}
		
	}
	return cells
}




let cellCount = 6
let line1 = "Item1,Item2,Item3,Item4,Item5,Item6"
let line2 = "\"Item1\",,Item3,Item4,,"
let line3 = "\"\",\"\",Item3,Item4,Item5,"
let line4 = "\"\",\"\",\"Item3\",\"Item4\",,Item6"
let line5 = "\"\",\"I,t,e,m,2,\",\"Item3\",\"Item4\",,"
let line6 = "Item1,,\"Item3\",Item4,,"
let line7 = ",\"\",\"Item3\",Item4,,"

let lines = [line1,line2, line3,  line4, line5, line6, line7]

for (idx, line) in lines.enumerated() {
	let cells = scan(line)
	assert(cells.count == cellCount, "Cell count should always be \(cellCount) (Current count: \(cells.count) on line \(idx + 1)")
	for (cellIdx, cell) in cells.enumerated() {
		if line == line1 {
			assert(cell == "Item\(cellIdx + 1)", "Item is not correct")
		}
		if line == line2 {
			switch cellIdx {
			case 1,4,5:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}
		if line == line3 {
			switch cellIdx {
			case 0,1,5:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}
		if line == line4 {
			switch cellIdx {
			case 0,1,4:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}
		if line == line5 {
			switch cellIdx {
			case 0,4,5:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			case 1:
				assert(cell == "I,t,e,m,\(cellIdx + 1),", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}
		if line == line6 {
			switch cellIdx {
			case 1,4,5:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}

		if line == line7 {
			switch cellIdx {
			case 0,1,4,5:
				assert(cell == "", "Item is not correct on line \(idx + 1): \(cell)")
			default:
				assert(cell == "Item\(cellIdx + 1)", "Item is not correct on line \(idx + 1): \(cell)")
			}
		}
	}
	print("Line \(idx + 1) passed OK")
}


