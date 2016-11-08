//  SwiftyJSON.swift
//
//  Copyright (c) 2014 Ruoyu Fu, Pinglin Tang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// MARK: - Error

///Error domain
public let ErrorDomain: String = "SwiftyJSONErrorDomain"

///Error code
public let ErrorUnsupportedType: Int = 999
public let ErrorIndexOutOfBounds: Int = 900
public let ErrorWrongType: Int = 901
public let ErrorNotExist: Int = 500
public let ErrorInvalidJSON: Int = 490

// MARK: - JSON Type

/**
JSON's type definitions.

See http://www.json.org
*/
public enum Type :Int{

    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

// MARK: - JSON Base

public struct JSON {

    /**
    Creates a JSON using the data.

    - parameter data:  The NSData used to convert to json.Top level object in data is an NSArray or NSDictionary
    - parameter opt:   The JSON serialization reading options. `.AllowFragments` by default.
    - parameter error: error The NSErrorPointer used to return the error. `nil` by default.

    - returns: The created JSON
    */
    public init(data:Data, options opt: JSONSerialization.ReadingOptions = .allowFragments, error: NSErrorPointer? = nil) {
        do {
            let object: AnyObject = try JSONSerialization.jsonObject(with: data, options: opt)
            self.init(object)
        } catch let aError as NSError {
            if error != nil {
                error??.pointee = aError
            }
            self.init(NSNull())
        }
    }

    /**
     Create a JSON from JSON string
    - parameter string: Normal json string like '{"a":"b"}'

    - returns: The created JSON
    */
    public static func parse(_ string:String) -> JSON {
        return string.data(using: String.Encoding.utf8)
            .flatMap({JSON(data: $0)}) ?? JSON(NSNull())
    }

    /**
    Creates a JSON using the object.

    - parameter object:  The object must have the following properties: All objects are NSString/String, NSNumber/Int/Float/Double/Bool, NSArray/Array, NSDictionary/Dictionary, or NSNull; All dictionary keys are NSStrings/String; NSNumbers are not NaN or infinity.

    - returns: The created JSON
    */
    public init(_ object: AnyObject) {
        self.object = object
    }

    /**
    Creates a JSON from a [JSON]

    - parameter jsonArray: A Swift array of JSON objects

    - returns: The created JSON
    */
    public init(_ jsonArray:[JSON]) {
        self.init(jsonArray.map { $0.object })
    }

    /**
    Creates a JSON from a [String: JSON]

    - parameter jsonDictionary: A Swift dictionary of JSON objects

    - returns: The created JSON
    */
    public init(_ jsonDictionary:[String: JSON]) {
        var dictionary = [String: AnyObject](minimumCapacity: jsonDictionary.count)
        for (key, json) in jsonDictionary {
            dictionary[key] = json.object
        }
        self.init(dictionary)
    }

    /// Private object
    fileprivate var rawArray: [AnyObject] = []
    fileprivate var rawDictionary: [String : AnyObject] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber: NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    /// Private type
    fileprivate var _type: Type = .null
    /// prviate error
    fileprivate var _error: NSError? = nil

    /// Object in JSON
    public var object: AnyObject {
        get {
            switch self.type {
            case .array:
                return self.rawArray as AnyObject
            case .dictionary:
                return self.rawDictionary as AnyObject
            case .string:
                return self.rawString as AnyObject
            case .number:
                return self.rawNumber
            case .bool:
                return self.rawNumber
            default:
                return self.rawNull
            }
        }
        set {
            _error = nil
            switch newValue {
            case let number as NSNumber:
                if number.isBool {
                    _type = .bool
                } else {
                    _type = .number
                }
                self.rawNumber = number
            case  let string as String:
                _type = .string
                self.rawString = string
            case  _ as NSNull:
                _type = .null
            case let array as [AnyObject]:
                _type = .array
                self.rawArray = array
            case let dictionary as [String : AnyObject]:
                _type = .dictionary
                self.rawDictionary = dictionary
            default:
                _type = .unknown
                _error = NSError(domain: ErrorDomain, code: ErrorUnsupportedType, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
            }
        }
    }

    /// json type
    public var type: Type { get { return _type } }

    /// Error in JSON
    public var error: NSError? { get { return self._error } }

    /// The static null json
    @available(*, unavailable, renamed: "null")
    public static var nullJSON: JSON { get { return null } }
    public static var null: JSON { get { return JSON(NSNull()) } }
}

// MARK: - CollectionType, SequenceType, Indexable
extension JSON : Swift.Collection, Swift.Sequence, Swift.Indexable {

    public typealias Iterator = JSONGenerator

    public typealias Index = JSONIndex

    public var startIndex: JSON.Index {
        switch self.type {
        case .array:
            return JSONIndex(arrayIndex: self.rawArray.startIndex)
        case .dictionary:
            return JSONIndex(dictionaryIndex: self.rawDictionary.startIndex)
        default:
            return JSONIndex()
        }
    }

    public var endIndex: JSON.Index {
        switch self.type {
        case .array:
            return JSONIndex(arrayIndex: self.rawArray.endIndex)
        case .dictionary:
            return JSONIndex(dictionaryIndex: self.rawDictionary.endIndex)
        default:
            return JSONIndex()
        }
    }

    public subscript (position: JSON.Index) -> JSON.Iterator.Element {
        switch self.type {
        case .array:
            return (String(describing: position.arrayIndex), JSON(self.rawArray[position.arrayIndex!]))
        case .dictionary:
            let (key, value) = self.rawDictionary[position.dictionaryIndex!]
            return (key, JSON(value))
        default:
            return ("", JSON.null)
        }
    }

    /// If `type` is `.Array` or `.Dictionary`, return `array.isEmpty` or `dictonary.isEmpty` otherwise return `true`.
    public var isEmpty: Bool {
        get {
            switch self.type {
            case .array:
                return self.rawArray.isEmpty
            case .dictionary:
                return self.rawDictionary.isEmpty
            default:
                return true
            }
        }
    }

    /// If `type` is `.Array` or `.Dictionary`, return `array.count` or `dictonary.count` otherwise return `0`.
    public var count: Int {
        switch self.type {
        case .array:
            return self.rawArray.count
        case .dictionary:
            return self.rawDictionary.count
        default:
            return 0
        }
    }

    public func underestimateCount() -> Int {
        switch self.type {
        case .array:
            return self.rawArray.underestimatedCount
        case .dictionary:
            return self.rawDictionary.underestimatedCount
        default:
            return 0
        }
    }

    /**
    If `type` is `.Array` or `.Dictionary`, return a generator over the elements like `Array` or `Dictionary`, otherwise return a generator over empty.

    - returns: Return a *generator* over the elements of JSON.
    */
    public func makeIterator() -> JSON.Iterator {
        return JSON.Iterator(self)
    }
}

public struct JSONIndex: Comparable, _Incrementable, Equatable {

    let arrayIndex: Int?
    let dictionaryIndex: DictionaryIndex<String, AnyObject>?

    let type: Type

    init(){
        self.arrayIndex = nil
        self.dictionaryIndex = nil
        self.type = .unknown
    }

    init(arrayIndex: Int) {
        self.arrayIndex = arrayIndex
        self.dictionaryIndex = nil
        self.type = .array
    }

    init(dictionaryIndex: DictionaryIndex<String, AnyObject>) {
        self.arrayIndex = nil
        self.dictionaryIndex = dictionaryIndex
        self.type = .dictionary
    }

    public func successor() -> JSONIndex {
        switch self.type {
        case .array:
            return JSONIndex(arrayIndex: (self.arrayIndex! + 1))
        case .dictionary:
            return JSONIndex(dictionaryIndex: <#T##Dictionary corresponding to your index##Dictionary#>.index(after: self.dictionaryIndex!))
        default:
            return JSONIndex()
        }
    }
}

public func ==(lhs: JSONIndex, rhs: JSONIndex) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.array, .array):
        return lhs.arrayIndex == rhs.arrayIndex
    case (.dictionary, .dictionary):
        return lhs.dictionaryIndex == rhs.dictionaryIndex
    default:
        return false
    }
}

public func <(lhs: JSONIndex, rhs: JSONIndex) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.array, .array):
        return lhs.arrayIndex < rhs.arrayIndex
    case (.dictionary, .dictionary):
        return lhs.dictionaryIndex < rhs.dictionaryIndex
    default:
        return false
    }
}

public func <=(lhs: JSONIndex, rhs: JSONIndex) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.array, .array):
        return lhs.arrayIndex <= rhs.arrayIndex
    case (.dictionary, .dictionary):
        return lhs.dictionaryIndex <= rhs.dictionaryIndex
    default:
        return false
    }
}

public func >=(lhs: JSONIndex, rhs: JSONIndex) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.array, .array):
        return lhs.arrayIndex >= rhs.arrayIndex
    case (.dictionary, .dictionary):
        return lhs.dictionaryIndex >= rhs.dictionaryIndex
    default:
        return false
    }
}

public func >(lhs: JSONIndex, rhs: JSONIndex) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.array, .array):
        return lhs.arrayIndex > rhs.arrayIndex
    case (.dictionary, .dictionary):
        return lhs.dictionaryIndex > rhs.dictionaryIndex
    default:
        return false
    }
}

public struct JSONGenerator : IteratorProtocol {

    public typealias Element = (String, JSON)

    fileprivate let type: Type
    fileprivate var dictionayGenerate: DictionaryGenerator<String, AnyObject>?
    fileprivate var arrayGenerate: IndexingIterator<[AnyObject]>?
    fileprivate var arrayIndex: Int = 0

    init(_ json: JSON) {
        self.type = json.type
        if type == .array {
            self.arrayGenerate = json.rawArray.makeIterator()
        }else {
            self.dictionayGenerate = json.rawDictionary.makeIterator()
        }
    }

    public mutating func next() -> JSONGenerator.Element? {
        switch self.type {
        case .array:
            if let o = self.arrayGenerate?.next() {
                let i = self.arrayIndex
                self.arrayIndex += 1
                return (String(i), JSON(o))
            } else {
                return nil
            }
        case .dictionary:
            if let (k, v): (String, AnyObject) = self.dictionayGenerate?.next() {
                return (k, JSON(v))
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}

// MARK: - Subscript

/**
*  To mark both String and Int can be used in subscript.
*/
public enum JSONKey {
    case index(Int)
    case key(String)
}

public protocol JSONSubscriptType {
    var jsonKey:JSONKey { get }
}

extension Int: JSONSubscriptType {
    public var jsonKey:JSONKey {
        return JSONKey.index(self)
    }
}

extension String: JSONSubscriptType {
    public var jsonKey:JSONKey {
        return JSONKey.key(self)
    }
}

extension JSON {

    /// If `type` is `.Array`, return json whose object is `array[index]`, otherwise return null json with error.
    fileprivate subscript(index index: Int) -> JSON {
        get {
            if self.type != .array {
                var r = JSON.null
                r._error = self._error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] failure, It is not an array"])
                return r
            } else if index >= 0 && index < self.rawArray.count {
                return JSON(self.rawArray[index])
            } else {
                var r = JSON.null
                r._error = NSError(domain: ErrorDomain, code:ErrorIndexOutOfBounds , userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] is out of bounds"])
                return r
            }
        }
        set {
            if self.type == .array {
                if self.rawArray.count > index && newValue.error == nil {
                    self.rawArray[index] = newValue.object
                }
            }
        }
    }

    /// If `type` is `.Dictionary`, return json whose object is `dictionary[key]` , otherwise return null json with error.
    fileprivate subscript(key key: String) -> JSON {
        get {
            var r = JSON.null
            if self.type == .dictionary {
                if let o = self.rawDictionary[key] {
                    r = JSON(o)
                } else {
                    r._error = NSError(domain: ErrorDomain, code: ErrorNotExist, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] does not exist"])
                }
            } else {
                r._error = self._error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] failure, It is not an dictionary"])
            }
            return r
        }
        set {
            if self.type == .dictionary && newValue.error == nil {
                self.rawDictionary[key] = newValue.object
            }
        }
    }

    /// If `sub` is `Int`, return `subscript(index:)`; If `sub` is `String`,  return `subscript(key:)`.
    fileprivate subscript(sub sub: JSONSubscriptType) -> JSON {
        get {
            switch sub.jsonKey {
            case .index(let index): return self[index: index]
            case .key(let key): return self[key: key]
            }
        }
        set {
            switch sub.jsonKey {
            case .index(let index): self[index: index] = newValue
            case .key(let key): self[key: key] = newValue
            }
        }
    }

    /**
    Find a json in the complex data structuresby using the Int/String's array.

    - parameter path: The target json's path. Example:

    let json = JSON[data]
    let path = [9,"list","person","name"]
    let name = json[path]

    The same as: let name = json[9]["list"]["person"]["name"]

    - returns: Return a json found by the path or a null json with error
    */
    public subscript(path: [JSONSubscriptType]) -> JSON {
        get {
            return path.reduce(self) { $0[sub: $1] }
        }
        set {
            switch path.count {
            case 0:
                return
            case 1:
                self[sub:path[0]].object = newValue.object
            default:
                var aPath = path; aPath.remove(at: 0)
                var nextJSON = self[sub: path[0]]
                nextJSON[aPath] = newValue
                self[sub: path[0]] = nextJSON
            }
        }
    }

    /**
    Find a json in the complex data structures by using the Int/String's array.

    - parameter path: The target json's path. Example:

    let name = json[9,"list","person","name"]

    The same as: let name = json[9]["list"]["person"]["name"]

    - returns: Return a json found by the path or a null json with error
    */
    public subscript(path: JSONSubscriptType...) -> JSON {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }
}

// MARK: - LiteralConvertible

extension JSON: Swift.ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByIntegerLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByBooleanLiteral {

    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByFloatLiteral {

    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (String, AnyObject)...) {
        self.init(elements.reduce([String : AnyObject](minimumCapacity: elements.count)){(dictionary: [String : AnyObject], element:(String, AnyObject)) -> [String : AnyObject] in
            var d = dictionary
            d[element.0] = element.1
            return d
            })
    }
}

extension JSON: Swift.ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: AnyObject...) {
        self.init(elements)
    }
}

extension JSON: Swift.ExpressibleByNilLiteral {

    public init(nilLiteral: ()) {
        self.init(NSNull())
    }
}

// MARK: - Raw

extension JSON: Swift.RawRepresentable {

    public init?(rawValue: AnyObject) {
        if JSON(rawValue).type == .unknown {
            return nil
        } else {
            self.init(rawValue)
        }
    }

    public var rawValue: AnyObject {
        return self.object
    }

    public func rawData(options opt: JSONSerialization.WritingOptions = JSONSerialization.WritingOptions(rawValue: 0)) throws -> Data {
        guard JSONSerialization.isValidJSONObject(self.object) else {
            throw NSError(domain: ErrorDomain, code: ErrorInvalidJSON, userInfo: [NSLocalizedDescriptionKey: "JSON is invalid"])
        }

        return try JSONSerialization.data(withJSONObject: self.object, options: opt)
    }

    public func rawString(_ encoding: UInt = String.Encoding.utf8, options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
        switch self.type {
        case .array, .dictionary:
            do {
                let data = try self.rawData(options: opt)
                return NSString(data: data, encoding: encoding) as? String
            } catch _ {
                return nil
            }
        case .string:
            return self.rawString
        case .number:
            return self.rawNumber.stringValue
        case .bool:
            return self.rawNumber.boolValue.description
        case .null:
            return "null"
        default:
            return nil
        }
    }
}

// MARK: - Printable, DebugPrintable

extension JSON: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {

    public var description: String {
        if let string = self.rawString(options:.prettyPrinted) {
            return string
        } else {
            return "unknown"
        }
    }

    public var debugDescription: String {
        return description
    }
}

// MARK: - Array

extension JSON {

    //Optional [JSON]
    public var array: [JSON]? {
        get {
            if self.type == .array {
                return self.rawArray.map{ JSON($0) }
            } else {
                return nil
            }
        }
    }

    //Non-optional [JSON]
    public var arrayValue: [JSON] {
        get {
            return self.array ?? []
        }
    }

    //Optional [AnyObject]
    public var arrayObject: [AnyObject]? {
        get {
            switch self.type {
            case .array:
                return self.rawArray
            default:
                return nil
            }
        }
        set {
            if let array = newValue {
                self.object = array as AnyObject
            } else {
                self.object = NSNull()
            }
        }
    }
}

// MARK: - Dictionary

extension JSON {

    //Optional [String : JSON]
    public var dictionary: [String : JSON]? {
        if self.type == .dictionary {
            return self.rawDictionary.reduce([String : JSON](minimumCapacity: count)) { (dictionary: [String : JSON], element: (String, AnyObject)) -> [String : JSON] in
                var d = dictionary
                d[element.0] = JSON(element.1)
                return d
            }
        } else {
            return nil
        }
    }

    //Non-optional [String : JSON]
    public var dictionaryValue: [String : JSON] {
        return self.dictionary ?? [:]
    }

    //Optional [String : AnyObject]
    public var dictionaryObject: [String : AnyObject]? {
        get {
            switch self.type {
            case .dictionary:
                return self.rawDictionary
            default:
                return nil
            }
        }
        set {
            if let v = newValue {
                self.object = v as AnyObject
            } else {
                self.object = NSNull()
            }
        }
    }
}

// MARK: - Bool

extension JSON: Swift.BooleanType {

    //Optional bool
    public var bool: Bool? {
        get {
            switch self.type {
            case .bool:
                return self.rawNumber.boolValue
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Bool)
            } else {
                self.object = NSNull()
            }
        }
    }

    //Non-optional bool
    public var boolValue: Bool {
        get {
            switch self.type {
            case .bool, .number, .string:
                return self.object.boolValue
            default:
                return false
            }
        }
        set {
            self.object = NSNumber(value: newValue as Bool)
        }
    }
}

// MARK: - String

extension JSON {

    //Optional string
    public var string: String? {
        get {
            switch self.type {
            case .string:
                return self.object as? String
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.object = NSString(string:newValue)
            } else {
                self.object = NSNull()
            }
        }
    }

    //Non-optional string
    public var stringValue: String {
        get {
            switch self.type {
            case .string:
                return self.object as? String ?? ""
            case .number:
                return self.object.stringValue
            case .bool:
                return (self.object as? Bool).map { String($0) } ?? ""
            default:
                return ""
            }
        }
        set {
            self.object = NSString(string:newValue)
        }
    }
}

// MARK: - Number
extension JSON {

    //Optional number
    public var number: NSNumber? {
        get {
            switch self.type {
            case .number, .bool:
                return self.rawNumber
            default:
                return nil
            }
        }
        set {
            self.object = newValue ?? NSNull()
        }
    }

    //Non-optional number
    public var numberValue: NSNumber {
        get {
            switch self.type {
            case .string:
                let decimal = NSDecimalNumber(string: self.object as? String)
                if decimal == NSDecimalNumber.notANumber {  // indicates parse error
                    return NSDecimalNumber.zero
                }
                return decimal
            case .number, .bool:
                return self.object as? NSNumber ?? NSNumber(value: 0 as Int32)
            default:
                return NSNumber(value: 0.0 as Double)
            }
        }
        set {
            self.object = newValue
        }
    }
}

//MARK: - Null
extension JSON {

    public var null: NSNull? {
        get {
            switch self.type {
            case .null:
                return self.rawNull
            default:
                return nil
            }
        }
        set {
            self.object = NSNull()
        }
    }
    public func exists() -> Bool{
        if let errorValue = error , errorValue.code == ErrorNotExist{
            return false
        }
        return true
    }
}

//MARK: - URL
extension JSON {

    //Optional URL
    public var URL: Foundation.URL? {
        get {
            switch self.type {
            case .string:
                if let encodedString_ = self.rawString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    return Foundation.URL(string: encodedString_)
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
        set {
            self.object = newValue?.absoluteString as AnyObject? ?? NSNull()
        }
    }
}

// MARK: - Int, Double, Float, Int8, Int16, Int32, Int64

extension JSON {

    public var double: Double? {
        get {
            return self.number?.doubleValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Double)
            } else {
                self.object = NSNull()
            }
        }
    }

    public var doubleValue: Double {
        get {
            return self.numberValue.doubleValue
        }
        set {
            self.object = NSNumber(value: newValue as Double)
        }
    }

    public var float: Float? {
        get {
            return self.number?.floatValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Float)
            } else {
                self.object = NSNull()
            }
        }
    }

    public var floatValue: Float {
        get {
            return self.numberValue.floatValue
        }
        set {
            self.object = NSNumber(value: newValue as Float)
        }
    }

    public var int: Int? {
        get {
            return self.number?.intValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Int)
            } else {
                self.object = NSNull()
            }
        }
    }

    public var intValue: Int {
        get {
            return self.numberValue.intValue
        }
        set {
            self.object = NSNumber(value: newValue as Int)
        }
    }

    public var uInt: UInt? {
        get {
            return self.number?.uintValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as UInt)
            } else {
                self.object = NSNull()
            }
        }
    }

    public var uIntValue: UInt {
        get {
            return self.numberValue.uintValue
        }
        set {
            self.object = NSNumber(value: newValue as UInt)
        }
    }

    public var int8: Int8? {
        get {
            return self.number?.int8Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Int8)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int8Value: Int8 {
        get {
            return self.numberValue.int8Value
        }
        set {
            self.object = NSNumber(value: newValue as Int8)
        }
    }

    public var uInt8: UInt8? {
        get {
            return self.number?.uint8Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as UInt8)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt8Value: UInt8 {
        get {
            return self.numberValue.uint8Value
        }
        set {
            self.object = NSNumber(value: newValue as UInt8)
        }
    }

    public var int16: Int16? {
        get {
            return self.number?.int16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Int16)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int16Value: Int16 {
        get {
            return self.numberValue.int16Value
        }
        set {
            self.object = NSNumber(value: newValue as Int16)
        }
    }

    public var uInt16: UInt16? {
        get {
            return self.number?.uint16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as UInt16)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt16Value: UInt16 {
        get {
            return self.numberValue.uint16Value
        }
        set {
            self.object = NSNumber(value: newValue as UInt16)
        }
    }

    public var int32: Int32? {
        get {
            return self.number?.int32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Int32)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int32Value: Int32 {
        get {
            return self.numberValue.int32Value
        }
        set {
            self.object = NSNumber(value: newValue as Int32)
        }
    }

    public var uInt32: UInt32? {
        get {
            return self.number?.uint32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as UInt32)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt32Value: UInt32 {
        get {
            return self.numberValue.uint32Value
        }
        set {
            self.object = NSNumber(value: newValue as UInt32)
        }
    }

    public var int64: Int64? {
        get {
            return self.number?.int64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as Int64)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int64Value: Int64 {
        get {
            return self.numberValue.int64Value
        }
        set {
            self.object = NSNumber(value: newValue as Int64)
        }
    }

    public var uInt64: UInt64? {
        get {
            return self.number?.uint64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue as UInt64)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt64Value: UInt64 {
        get {
            return self.numberValue.uint64Value
        }
        set {
            self.object = NSNumber(value: newValue as UInt64)
        }
    }
}

//MARK: - Comparable
extension JSON : Swift.Comparable {}

public func ==(lhs: JSON, rhs: JSON) -> Bool {

    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber == rhs.rawNumber
    case (.string, .string):
        return lhs.rawString == rhs.rawString
    case (.bool, .bool):
        return lhs.rawNumber.boolValue == rhs.rawNumber.boolValue
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func <=(lhs: JSON, rhs: JSON) -> Bool {

    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber <= rhs.rawNumber
    case (.string, .string):
        return lhs.rawString <= rhs.rawString
    case (.bool, .bool):
        return lhs.rawNumber.boolValue == rhs.rawNumber.boolValue
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func >=(lhs: JSON, rhs: JSON) -> Bool {

    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber >= rhs.rawNumber
    case (.string, .string):
        return lhs.rawString >= rhs.rawString
    case (.bool, .bool):
        return lhs.rawNumber.boolValue == rhs.rawNumber.boolValue
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func >(lhs: JSON, rhs: JSON) -> Bool {

    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber > rhs.rawNumber
    case (.string, .string):
        return lhs.rawString > rhs.rawString
    default:
        return false
    }
}

public func <(lhs: JSON, rhs: JSON) -> Bool {

    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber < rhs.rawNumber
    case (.string, .string):
        return lhs.rawString < rhs.rawString
    default:
        return false
    }
}

private let trueNumber = NSNumber(value: true as Bool)
private let falseNumber = NSNumber(value: false as Bool)
private let trueObjCType = String(cString: trueNumber.objCType)
private let falseObjCType = String(cString: falseNumber.objCType)

// MARK: - NSNumber: Comparable

extension NSNumber {
    var isBool:Bool {
        get {
            let objCType = String(cString: self.objCType)
            if (self.compare(trueNumber) == ComparisonResult.orderedSame && objCType == trueObjCType)
                || (self.compare(falseNumber) == ComparisonResult.orderedSame && objCType == falseObjCType){
                    return true
            } else {
                return false
            }
        }
    }
}

func ==(lhs: NSNumber, rhs: NSNumber) -> Bool {
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == ComparisonResult.orderedSame
    }
}

func !=(lhs: NSNumber, rhs: NSNumber) -> Bool {
    return !(lhs == rhs)
}

func <(lhs: NSNumber, rhs: NSNumber) -> Bool {

    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == ComparisonResult.orderedAscending
    }
}

func >(lhs: NSNumber, rhs: NSNumber) -> Bool {

    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == ComparisonResult.orderedDescending
    }
}

func <=(lhs: NSNumber, rhs: NSNumber) -> Bool {

    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) != ComparisonResult.orderedDescending
    }
}

func >=(lhs: NSNumber, rhs: NSNumber) -> Bool {

    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) != ComparisonResult.orderedAscending
    }
}
