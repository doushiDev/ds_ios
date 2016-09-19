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

/**
    Used to make constraints
*/
open class ConstraintMaker {
    
    /// left edge
    open var left: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Left) }
    
    /// top edge
    open var top: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Top) }
    
    /// right edge
    open var right: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Right) }
    
    /// bottom edge
    open var bottom: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Bottom) }
    
    /// leading edge
    open var leading: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Leading) }
    
    /// trailing edge
    open var trailing: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Trailing) }
    
    /// width dimension
    open var width: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Width) }
    
    /// height dimension
    open var height: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Height) }
    
    /// centerX dimension
    open var centerX: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.CenterX) }
    
    /// centerY dimension
    open var centerY: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.CenterY) }
    
    /// baseline position
    open var baseline: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Baseline) }
    
    /// firse baseline position
    @available(iOS 8.0, *)
    open var firstBaseline: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.FirstBaseline) }
    
    /// left margin
    @available(iOS 8.0, *)
    open var leftMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.LeftMargin) }
    
    /// right margin
    @available(iOS 8.0, *)
    open var rightMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.RightMargin) }
    
    /// top margin
    @available(iOS 8.0, *)
    open var topMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.TopMargin) }
    
    /// bottom margin
    @available(iOS 8.0, *)
    open var bottomMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.BottomMargin) }
    
    /// leading margin
    @available(iOS 8.0, *)
    open var leadingMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.LeadingMargin) }
    
    /// trailing margin
    @available(iOS 8.0, *)
    open var trailingMargin: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.TrailingMargin) }
    
    /// centerX within margins
    @available(iOS 8.0, *)
    open var centerXWithinMargins: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.CenterXWithinMargins) }
    
    /// centerY within margins
    @available(iOS 8.0, *)
    open var centerYWithinMargins: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.CenterYWithinMargins) }
    
    /// top + left + bottom + right edges
    open var edges: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Edges) }
    
    /// width + height dimensions
    open var size: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Size) }
    
    // centerX + centerY positions
    open var center: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Center) }
    
    // top + left + bottom + right margins
    @available(iOS 8.0, *)
    open var margins: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.Margins) }
    
    // centerX + centerY within margins
    @available(iOS 8.0, *)
    open var centerWithinMargins: ConstraintDescriptionExtendable { return self.makeConstraintDescription(ConstraintAttributes.CenterWithinMargins) }
    
    internal init(view: View, location: SourceLocation) {
        self.view = view
        self.location = location
    }
    
    internal let location: SourceLocation
    internal let view: View
    internal var constraintDescriptions = [ConstraintDescription]()
    
    internal func makeConstraintDescription(_ attributes: ConstraintAttributes) -> ConstraintDescriptionExtendable {
        let item = ConstraintItem(object: self.view, attributes: attributes)
        let constraintDescription = ConstraintDescription(fromItem: item)
        self.constraintDescriptions.append(constraintDescription)
        return ConstraintDescriptionExtendable(constraintDescription)
    }
    
    internal class func prepareConstraints(view: View, location: SourceLocation, closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        let maker = ConstraintMaker(view: view, location : location)
        closure(maker)
        
        let constraints = maker.constraintDescriptions.map { $0.constraint }
        for constraint in constraints {
            constraint.makerLocation = maker.location
        }
        return constraints
    }
    
    internal class func makeConstraints(view: View, location: SourceLocation, closure: (_ make: ConstraintMaker) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let maker = ConstraintMaker(view: view, location: location)
        closure(maker)
        
        let constraints = maker.constraintDescriptions.map { $0.constraint as! ConcreteConstraint }
        for constraint in constraints {
            constraint.makerLocation = maker.location
            constraint.installOnView(updateExisting: false)
        }
    }
    
    internal class func remakeConstraints(view: View, location : SourceLocation, closure: (_ make: ConstraintMaker) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let maker = ConstraintMaker(view: view, location: location)
        closure(maker)
        
        self.removeConstraints(view: view)
        let constraints = maker.constraintDescriptions.map { $0.constraint as! ConcreteConstraint }
        for constraint in constraints {
            constraint.makerLocation = maker.location
            constraint.installOnView(updateExisting: false)
        }
    }
    
    internal class func updateConstraints(view: View, location: SourceLocation, closure: (_ make: ConstraintMaker) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let maker = ConstraintMaker(view: view, location: location)
        closure(maker)
        
        let constraints = maker.constraintDescriptions.map { $0.constraint as! ConcreteConstraint}
        for constraint in constraints {
            constraint.makerLocation = maker.location
            constraint.installOnView(updateExisting: true)
        }
    }
    
    internal class func removeConstraints(view: View) {
        for existingLayoutConstraint in view.snp_installedLayoutConstraints {
            existingLayoutConstraint.snp_constraint?.uninstall()
        }
    }
}
