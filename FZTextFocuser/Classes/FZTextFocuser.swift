//
//  FZTextFocuser.swift
//  VHX TV
//
//  Created by Gutenberg Neto on 30/05/19.
//  Copyright © 2019 Fuze. All rights reserved.
//

import UIKit
import CoreText
import FuzeUtils

private struct FZFocusableText {
    var text: String?
    var cornerRadius: CGFloat
    var backgroundColor: UIColor?
    var range: NSRange?
    var textColor: UIColor?
}

public protocol FZTextFocuserDelegate: class {
    func fzTextFocuserDidTapView(textFocuser: FZTextFocuser)
}

public extension FZTextFocuserDelegate {
    func fzTextFocuserDidTapView(textFocuser: FZTextFocuser) {}
}

public class FZTextFocuser: UIView {
    override public var canBecomeFocused: Bool {
        return true
    }
    
    public var attributedText: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = self.cornerRadius != 0
            self.setNeedsDisplay()
        }
    }
    
    public var focusedBackgroundColor: UIColor = .clear {
        didSet {
            if self.isFocused {
                self.backgroundColor = self.focusedBackgroundColor
            }
            self.setNeedsDisplay()
        }
    }
    
    public var normalBackgroundColor: UIColor = .clear {
        didSet {
            if !self.isFocused {
                self.backgroundColor = self.normalBackgroundColor
            }
            self.setNeedsDisplay()
        }
    }
    
    public var focusOffset = CGPoint(x: 4, y: 0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var textInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public weak var delegate: FZTextFocuserDelegate?
    
    private var focusableTexts: [FZFocusableText] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.performInitialSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.performInitialSetup()
    }
    
    private func performInitialSetup() {
        self.isUserInteractionEnabled = true
        
        self.addTapGestureRecognizer()
    }
    
    // MARK: - Focusable Text
    
    public func addFocusableText(_ text: String, textColor: UIColor? = nil, backgroundColor: UIColor? = nil,
                          cornerRadius: CGFloat = 0) {
        self.focusableTexts.append(FZFocusableText(text: text, cornerRadius: cornerRadius,
                                                   backgroundColor: backgroundColor, range: nil,
                                                   textColor: textColor))
        self.setNeedsDisplay()
    }
    
    public func addFocusableText(range: NSRange, textColor: UIColor? = nil, backgroundColor: UIColor? = nil,
                          cornerRadius: CGFloat = 0) {
        self.focusableTexts.append(FZFocusableText(text: nil, cornerRadius: cornerRadius,
                                                   backgroundColor: backgroundColor, range: range,
                                                   textColor: textColor))
        self.setNeedsDisplay()
    }
    
    public func clearFocusableTexts() {
        self.focusableTexts.removeAll()
        self.setNeedsDisplay()
    }
    
    // MARK: - Gesture Recognizer
    
    private func addTapGestureRecognizer() {
        self.removeAllGestureRecognizers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.userDidTap))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        self.addGestureRecognizer(tap)
    }
    
    @objc private func userDidTap(gesture: UITapGestureRecognizer) {
        self.delegate?.fzTextFocuserDidTapView(textFocuser: self)
    }
    
    // MARK: - Helper
    
    private func getAttributedStringWithFocusableAttributes() -> NSAttributedString? {
        guard let attributedText = self.attributedText else {
            return nil
        }
        
        guard self.isFocused else {
            return attributedText
        }
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        for focusableText in self.focusableTexts {
            let range = focusableText.range ?? mutableAttributedText.range(of: focusableText.text ?? "")
            
            if let textColor = focusableText.textColor {
                mutableAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor,
                                                   range: range)
            }
        }
        
        return mutableAttributedText
    }
    
    // MARK: - Focus Update
    
    override public func didUpdateFocus(in context: UIFocusUpdateContext,
                                        with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            self.backgroundColor = self.focusedBackgroundColor
        } else if context.previouslyFocusedView == self {
            self.backgroundColor = self.normalBackgroundColor
        }
        
        self.setNeedsDisplay()
    }
    
    // MARK: - Drawing

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let attributedText = self.getAttributedStringWithFocusableAttributes(),
            let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // since Core Text's origin is in the lower left corner, we need to flip the coordinate system [GN]
        context.textMatrix = .identity
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let insetBounds = self.bounds.inset(by: self.textInsets)
        let path = CGMutablePath()
        path.addRect(insetBounds)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
        let frameReference = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText.length), path, nil)
        
        defer {
            CTFrameDraw(frameReference, context)
        }
        
        guard !self.focusableTexts.isEmpty, self.isFocused else {
            return
        }
        
        // will look for text that needs to be highlightable [GN]
        
        let lines = CTFrameGetLines(frameReference)
        
        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count: CFArrayGetCount(lines))
        CTFrameGetLineOrigins(frameReference, CFRangeMake(0, 0), &lineOrigins)
        
        for i in 0..<CFArrayGetCount(lines) {
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            let lineOrigin = lineOrigins.count > i ? lineOrigins[i] : CGPoint.zero
            
            context.textPosition = lineOrigin
            
            let glyphRuns = CTLineGetGlyphRuns(line)
            
            for j in 0..<CFArrayGetCount(glyphRuns) {
                for focusableText in self.focusableTexts {
                    let glyphRun = unsafeBitCast(CFArrayGetValueAtIndex(glyphRuns, j), to: CTRun.self)
                    let stringRange = CTRunGetStringRange(glyphRun)
                    
                    let focusableTextRange = focusableText.range ??
                        attributedText.range(of: focusableText.text ?? "")
                    let nsStringRange = NSMakeRange(stringRange.location, stringRange.length)
                    let intersectionRange = NSIntersectionRange(focusableTextRange, nsStringRange)
                    
                    guard let backgroundColor = focusableText.backgroundColor, intersectionRange.length > 0 else {
                        continue
                    }
                    
                    var ascent: CGFloat = 0
                    var descent: CGFloat = 0
                    var leading: CGFloat = 0
                    var secondaryOffset: CGFloat = 0
                    
                    let typographicBounds = CTRunGetTypographicBounds(
                        glyphRun,
                        CFRange(location: intersectionRange.location - stringRange.location,
                                length: intersectionRange.length),
                        &ascent, &descent, &leading)
                    let xOffset = CTLineGetOffsetForStringIndex(line, intersectionRange.location, &secondaryOffset)
                    
                    let shouldRoundLeftCorners = intersectionRange.location == focusableTextRange.location
                    let shouldRoundRightCorners = intersectionRange.location + intersectionRange.length ==
                        focusableTextRange.location + focusableTextRange.length
                    
                    var roundedCorners: UIRectCorner = []
                    
                    if shouldRoundLeftCorners && shouldRoundRightCorners {
                        roundedCorners = .allCorners
                    } else if shouldRoundLeftCorners {
                        roundedCorners = [.topLeft, .bottomLeft]
                    } else if shouldRoundRightCorners {
                        roundedCorners = [.topRight, .bottomRight]
                    }
                    
                    let bezierPathRect = CGRect(x: lineOrigin.x + xOffset + insetBounds.origin.x - self.focusOffset.x,
                                                y: lineOrigin.y - descent - insetBounds.origin.y - self.focusOffset.y,
                                                width: CGFloat(typographicBounds) + (self.focusOffset.x * 2),
                                                height: ascent + descent + (self.focusOffset.y * 2))
                    let bezierPath = UIBezierPath(roundedRect: bezierPathRect,
                                                  byRoundingCorners: roundedCorners,
                                                  cornerRadii: CGSize(width: focusableText.cornerRadius,
                                                                      height: focusableText.cornerRadius))
                    
                    backgroundColor.setFill()
                    bezierPath.fill()
                }
            }
        }
    }
}


