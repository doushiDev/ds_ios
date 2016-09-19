//
//  SnapKit
//
//  Copyright (c) 2011-2015 SnapKit Team - https://github.com/SnapKit
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

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

// Type of object that can be a target of relation constraint. 
// Doesn't cover system protocols which can't be extended with additional conformances.
public protocol RelationTarget {
    var constraintItem : ConstraintItem { get }
}

// Type of things that can be converted to floats. Used to provide a catch all for
// different numeric types.
public protocol FloatConvertible : RelationTarget {
    var floatValue : Float { get }
}

extension FloatConvertible {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: nil, attributes: ConstraintAttributes.None)
    }
}

extension Float : FloatConvertible, RelationTarget {
    public var floatValue : Float {
        return self
    }
}

extension Int : FloatConvertible, RelationTarget {
    public var floatValue : Float {
        return Float(self)
    }
}

extension UInt : FloatConvertible, RelationTarget {
    public var floatValue : Float {
        return Float(self)
    }
}

extension Double : FloatConvertible, RelationTarget {
    public var floatValue : Float {
        return Float(self)
    }
}

extension CGFloat : FloatConvertible, RelationTarget {
    public var floatValue : Float {
        return Float(self)
    }
}

@available(iOS 9.0, OSX 10.11, *)
extension NSLayoutAnchor : RelationTarget {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: self, attributes: ConstraintAttributes.None)
    }
}

extension CGPoint : RelationTarget {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: nil, attributes: ConstraintAttributes.None)
    }
}

extension CGSize : RelationTarget {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: nil, attributes: ConstraintAttributes.None)
    }
}

extension EdgeInsets : RelationTarget {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: nil, attributes: ConstraintAttributes.None)
    }
}

extension View : RelationTarget {
    public var constraintItem : ConstraintItem {
        return ConstraintItem(object: self, attributes: ConstraintAttributes.None)
    }
}

extension ConstraintItem : RelationTarget {
    public var constraintItem : ConstraintItem {
        return self
    }
}

/**
    Used to expose the final API of a `ConstraintDescription` which allows getting a constraint from it
 */
open class ConstraintDescriptionFinalizable {
    
    fileprivate let backing : ConstraintDescription
    
    internal init(_ backing : ConstraintDescription) {
        self.backing = backing
    }
    
    open var constraint: Constraint {
        return backing.constraint
    }
}

/**
    Used to expose priority APIs
 */
open class ConstraintDescriptionPriortizable: ConstraintDescriptionFinalizable {
    
    open func priority(_ priority: FloatConvertible) -> ConstraintDescriptionFinalizable {
        return ConstraintDescriptionFinalizable(self.backing.priority(priority))
    }
    
    open func priorityRequired() -> ConstraintDescriptionFinalizable {
        return ConstraintDescriptionFinalizable(self.backing.priorityRequired())
    }
    open func priorityHigh() -> ConstraintDescriptionFinalizable {
        return ConstraintDescriptionFinalizable(self.backing.priorityHigh())
    }
    open func priorityMedium() -> ConstraintDescriptionFinalizable {
        return ConstraintDescriptionFinalizable(self.backing.priorityMedium())
    }
    open func priorityLow() -> ConstraintDescriptionFinalizable {
        return ConstraintDescriptionFinalizable(self.backing.priorityLow())
    }
}

/**
    Used to expose multiplier & constant APIs
*/
open class ConstraintDescriptionEditable: ConstraintDescriptionPriortizable {

    open func multipliedBy(_ amount: FloatConvertible) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.multipliedBy(amount))
    }
    
    open func dividedBy(_ amount: FloatConvertible) -> ConstraintDescriptionEditable {
        return self.multipliedBy(1 / amount.floatValue)
    }
    
    open func offset(_ amount : FloatConvertible) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.offset(amount))
    }
    open func offset(_ amount: CGPoint) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.offset(amount))
    }
    open func offset(_ amount: CGSize) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.offset(amount))
    }
    open func offset(_ amount: EdgeInsets) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.offset(amount))
    }
    
    open func inset(_ amount: FloatConvertible) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.inset(amount))
    }
    open func inset(_ amount: EdgeInsets) -> ConstraintDescriptionEditable {
        return ConstraintDescriptionEditable(self.backing.inset(amount))
    }
}

/**
    Used to expose relation APIs
*/
open class ConstraintDescriptionRelatable {

    fileprivate let backing : ConstraintDescription
    
    init(_ backing : ConstraintDescription) {
        self.backing = backing
    }
    

    open func equalTo(_ other: RelationTarget, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .equal, location: location))
    }
    open func equalTo(_ other: LayoutSupport, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .equal, location: location))
    }
    
    open func lessThanOrEqualTo(_ other: RelationTarget, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .lessThanOrEqualTo, location: location))
    }
    open func lessThanOrEqualTo(_ other: LayoutSupport, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .lessThanOrEqualTo, location: location))
    }
    
    open func greaterThanOrEqualTo(_ other: RelationTarget, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .greaterThanOrEqualTo, location: location))
    }
    open func greaterThanOrEqualTo(_ other: LayoutSupport, file : String = #file, line : UInt = #line) -> ConstraintDescriptionEditable {
        let location = SourceLocation(file: file, line: line)
        return ConstraintDescriptionEditable(self.backing.constrainTo(other, relation : .greaterThanOrEqualTo, location: location))
    }
}

/**
    Used to expose chaining APIs
*/
open class ConstraintDescriptionExtendable: ConstraintDescriptionRelatable {
    
    open var left: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.left)
    }
    open var top: ConstraintDescriptionExtendable  {
        return ConstraintDescriptionExtendable(self.backing.top)
    }
    open var bottom: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.bottom)
    }
    open var right: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.right)
    }
    open var leading: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.leading)
    }
    open var trailing: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.trailing)
    }
    open var width: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.width)
    }
    open var height: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.height)
    }
    open var centerX: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.centerX)
    }
    open var centerY: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.centerY)
    }
    open var baseline: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.baseline)
    }
    
    @available(iOS 8.0, *)
    open var firstBaseline: ConstraintDescriptionExtendable  {
        return ConstraintDescriptionExtendable(self.backing.firstBaseline)
    }
    @available(iOS 8.0, *)
    open var leftMargin: ConstraintDescriptionExtendable  {
        return ConstraintDescriptionExtendable(self.backing.leftMargin)
    }
    @available(iOS 8.0, *)
    open var rightMargin: ConstraintDescriptionExtendable  {
        return ConstraintDescriptionExtendable(self.backing.rightMargin)
    }
    @available(iOS 8.0, *)
    open var topMargin: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.topMargin)
    }
    @available(iOS 8.0, *)
    open var bottomMargin: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.bottomMargin)
    }
    @available(iOS 8.0, *)
    open var leadingMargin: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.leadingMargin)
    }
    @available(iOS 8.0, *)
    open var trailingMargin: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.trailingMargin)
    }
    @available(iOS 8.0, *)
    open var centerXWithinMargins: ConstraintDescriptionExtendable  {
        return ConstraintDescriptionExtendable(self.backing.centerXWithinMargins)
    }
    @available(iOS 8.0, *)
    open var centerYWithinMargins: ConstraintDescriptionExtendable {
        return ConstraintDescriptionExtendable(self.backing.centerYWithinMargins)
    }
}

/**
    Used to internally manage building constraint
 */
internal class ConstraintDescription {
    
    fileprivate var location : SourceLocation?
    
    fileprivate var left: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Left) }
    fileprivate var top: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Top) }
    fileprivate var right: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Right) }
    fileprivate var bottom: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Bottom) }
    fileprivate var leading: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Leading) }
    fileprivate var trailing: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Trailing) }
    fileprivate var width: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Width) }
    fileprivate var height: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Height) }
    fileprivate var centerX: ConstraintDescription { return self.addConstraint(ConstraintAttributes.CenterX) }
    fileprivate var centerY: ConstraintDescription { return self.addConstraint(ConstraintAttributes.CenterY) }
    fileprivate var baseline: ConstraintDescription { return self.addConstraint(ConstraintAttributes.Baseline) }
    
    @available(iOS 8.0, *)
    fileprivate var firstBaseline: ConstraintDescription { return self.addConstraint(ConstraintAttributes.FirstBaseline) }
    @available(iOS 8.0, *)
    fileprivate var leftMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.LeftMargin) }
    @available(iOS 8.0, *)
    fileprivate var rightMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.RightMargin) }
    @available(iOS 8.0, *)
    fileprivate var topMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.TopMargin) }
    @available(iOS 8.0, *)
    fileprivate var bottomMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.BottomMargin) }
    @available(iOS 8.0, *)
    fileprivate var leadingMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.LeadingMargin) }
    @available(iOS 8.0, *)
    fileprivate var trailingMargin: ConstraintDescription { return self.addConstraint(ConstraintAttributes.TrailingMargin) }
    @available(iOS 8.0, *)
    fileprivate var centerXWithinMargins: ConstraintDescription { return self.addConstraint(ConstraintAttributes.CenterXWithinMargins) }
    @available(iOS 8.0, *)
    fileprivate var centerYWithinMargins: ConstraintDescription { return self.addConstraint(ConstraintAttributes.CenterYWithinMargins) }
    
    // MARK: initializer
    
    init(fromItem: ConstraintItem) {
        self.fromItem = fromItem
        self.toItem = ConstraintItem(object: nil, attributes: ConstraintAttributes.None)
    }
    
    // MARK: multiplier
    
    fileprivate func multipliedBy(_ amount: FloatConvertible) -> ConstraintDescription {
        self.multiplier = amount.floatValue
        return self
    }
    
    fileprivate func dividedBy(_ amount: FloatConvertible) -> ConstraintDescription {
        self.multiplier = 1.0 / amount.floatValue;
        return self
    }
    
    // MARK: offset
    
    fileprivate func offset(_ amount: FloatConvertible) -> ConstraintDescription {
        self.constant = amount.floatValue
        return self
    }
    fileprivate func offset(_ amount: CGPoint) -> ConstraintDescription {
        self.constant = amount
        return self
    }
    fileprivate func offset(_ amount: CGSize) -> ConstraintDescription {
        self.constant = amount
        return self
    }
    fileprivate func offset(_ amount: EdgeInsets) -> ConstraintDescription {
        self.constant = amount
        return self
    }
    
    // MARK: inset
    
    fileprivate func inset(_ amount: FloatConvertible) -> ConstraintDescription {
        let value = CGFloat(amount.floatValue)
        self.constant = EdgeInsets(top: value, left: value, bottom: -value, right: -value)
        return self
    }
    fileprivate func inset(_ amount: EdgeInsets) -> ConstraintDescription {
        self.constant = EdgeInsets(top: amount.top, left: amount.left, bottom: -amount.bottom, right: -amount.right)
        return self
    }
    
    // MARK: priority
    
    fileprivate func priority(_ priority: FloatConvertible) -> ConstraintDescription {
        self.priority = priority.floatValue
        return self
    }
    fileprivate func priorityRequired() -> ConstraintDescription {
        return self.priority(1000.0)
    }
    fileprivate func priorityHigh() -> ConstraintDescription {
        return self.priority(750.0)
    }
    fileprivate func priorityMedium() -> ConstraintDescription {
        #if os(iOS) || os(tvOS)
        return self.priority(500.0)
        #else
        return self.priority(501.0)
        #endif
    }
    fileprivate func priorityLow() -> ConstraintDescription {
        return self.priority(250.0)
    }
    
    // MARK: Constraint
    
    internal var constraint: Constraint {
        if self.concreteConstraint == nil {
            if self.relation == nil {
                fatalError("Attempting to create a constraint from a ConstraintDescription before it has been fully chained.")
            }
            self.concreteConstraint = ConcreteConstraint(
                fromItem: self.fromItem,
                toItem: self.toItem,
                relation: self.relation!,
                constant: self.constant,
                multiplier: self.multiplier,
                priority: self.priority,
                location: self.location
            )
        }
        return self.concreteConstraint!
    }
    
    // MARK: Private
    
    fileprivate let fromItem: ConstraintItem
    fileprivate var toItem: ConstraintItem {
        willSet {
            if self.concreteConstraint != nil {
                fatalError("Attempting to modify a ConstraintDescription after its constraint has been created.")
            }
        }
    }
    fileprivate var relation: ConstraintRelation? {
        willSet {
            if self.concreteConstraint != nil {
                fatalError("Attempting to modify a ConstraintDescription after its constraint has been created.")
            }
        }
    }
    fileprivate var constant: Any = Float(0.0) {
        willSet {
            if self.concreteConstraint != nil {
                fatalError("Attempting to modify a ConstraintDescription after its constraint has been created.")
            }
        }
    }
    fileprivate var multiplier: Float = 1.0 {
        willSet {
            if self.concreteConstraint != nil {
                fatalError("Attempting to modify a ConstraintDescription after its constraint has been created.")
            }
        }
    }
    fileprivate var priority: Float = 1000.0 {
        willSet {
            if self.concreteConstraint != nil {
                fatalError("Attempting to modify a ConstraintDescription after its constraint has been created.")
            }
        }
    }
    fileprivate var concreteConstraint: ConcreteConstraint? = nil
    
    fileprivate func addConstraint(_ attributes: ConstraintAttributes) -> ConstraintDescription {
        if self.relation == nil {
            self.fromItem.attributes += attributes
        }
        return self
    }
    
    fileprivate func constrainTo(_ other: RelationTarget, relation: ConstraintRelation, location : SourceLocation) -> ConstraintDescription {
        
        self.location = location
        
        if let constant = other as? FloatConvertible {
            self.constant = constant.floatValue
        }
        
        let item = other.constraintItem
        
        if item.attributes != ConstraintAttributes.None {
            let toLayoutAttributes = item.attributes.layoutAttributes
            if toLayoutAttributes.count > 1 {
                let fromLayoutAttributes = self.fromItem.attributes.layoutAttributes
                if toLayoutAttributes != fromLayoutAttributes {
                    NSException(name: NSExceptionName(rawValue: "Invalid Constraint"), reason: "Cannot constrain to multiple non identical attributes", userInfo: nil).raise()
                    return self
                }
                item.attributes = ConstraintAttributes.None
            }
        }
        self.toItem = item
        self.relation = relation
        return self
    }
    
    @available(iOS 7.0, *)
    fileprivate func constrainTo(_ other: LayoutSupport, relation: ConstraintRelation, location : SourceLocation) -> ConstraintDescription {
        return constrainTo(ConstraintItem(object: other, attributes: ConstraintAttributes.None), relation: relation, location: location)
    }
    
}
