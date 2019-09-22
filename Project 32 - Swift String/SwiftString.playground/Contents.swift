import UIKit
import Foundation

//---------------------------------------------------------------------------------------------
/// 1. String are not arrays
//---------------------------------------------------------------------------------------------
// we can loop over them:
let name = "Kevin"
for letter in name {
  print(letter)
}

// but we can't use the array way to get the fourth letter
//name[3]
let letter = name[name.index(name.startIndex, offsetBy: 3)]

// we can also use an extension to add a subscript to String
extension String {
  subscript(i: Int) -> String {
    return String(self[index(startIndex, offsetBy: i)])
  }
}
// now we can use
name[3]

//---------------------------------------------------------------------------------------------
/// 2. Working with strings in Swift
//---------------------------------------------------------------------------------------------
// there are methods for checking whether a string starts with or ends with a substring:
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

// We can add extension methods to String to extend the way prefixing and suffixing works:
extension String {
  // remove a prefix if it exists
  func deletePrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }
  
  // remove a sufix if it exists
  func deleteSuffix(_ suffix: String) -> String {
    guard self.hasSuffix(suffix) else { return self }
    return String(self.dropLast(suffix.count))
  }
}

password.deletePrefix("123")
password.deleteSuffix("345")

// there are methods for making a string uppercased or lowercased and capitalized
let weather = "it's going to rain"
weather.uppercased()
weather.lowercased()
weather.capitalized

// We could add our own specialized capitalization that uppercases only the first letter in our string:
extension String {
  var capitalizedFirst: String {
    guard let firstLetter = self.first else { return "" }
    return firstLetter.uppercased() + self.dropFirst()
  }
}

weather.capitalizedFirst

// A useful method of strings is contains(), which returns true if it contains another string.
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

// that's the same for arrays
let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

// How can we check whether any string in our array exists in our input string?
extension String {
  func containsAny(of array: [String]) -> Bool {
    for item in array {
      if self.contains(item) {
        return true
      }
    }
    return false
  }
}

input.containsAny(of: languages)

// swift has a better built in solution
languages.contains(where: input.contains)

//---------------------------------------------------------------------------------------------
/// 3. Formatting strings with NSAttributedString
//---------------------------------------------------------------------------------------------
// If we want to be able to add formatting like bold or italics, select from different fonts, or add some color we use NSAttributedString.

// Attributed strings are made up of two parts: a plain Swift string, plus a dictionary containing a series of attributes that describe how various segments of the string are formatted.
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
  .foregroundColor: UIColor.white,
  .backgroundColor: UIColor.red,
  .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString1 = NSAttributedString(string: string, attributes: attributes)

// We can format different parts of string
let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

//---------------------------------------------------------------------------------------------
/// Challenge1
//---------------------------------------------------------------------------------------------
// 1. Create a String extension that adds a withPrefix() method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: "pet".withPrefix("car") should return “carpet”.
extension String {
  func withPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return String(prefix+self) }
    return self
  }
}
var str = "pet"
str.withPrefix("car")
str.withPrefix("pe")

//---------------------------------------------------------------------------------------------
/// Challenge2
//---------------------------------------------------------------------------------------------
// 2. Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number. Tip: creating a Double from a String is a failable initializer.
extension String {
  var isNumeric: Bool {
    guard Double(self) == nil else { return true }
    return false
  }
}

"456".isNumeric
"xcv".isNumeric
"2.13".isNumeric
"alpha".isNumeric

//---------------------------------------------------------------------------------------------
/// Challenge3
//---------------------------------------------------------------------------------------------
// 3. Create a String extension that adds a lines property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.
extension String {
  var lines: [String] {
    return self.components(separatedBy: "\n")
  }
}

var testString = "this\nis\na\ntest"
testString.lines
