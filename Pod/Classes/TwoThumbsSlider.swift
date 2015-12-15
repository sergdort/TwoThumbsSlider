//
//  TwoTumbsSlider.swift
//  Pods
//
//  Created by Sergey Shulga on 2/5/15.
//
//

import UIKit

private let tumbWidth:CGFloat = 28
private let sliderInset:CGFloat = 5
private let extraTapInset:CGFloat = 12
private let TumbsSliderParametrExeption = "TumbsSliderParametrExeption"

@IBDesignable
public class TwoThumbsSlider: UIControl {
   
   
   private var leftThumbView = ThumbView(frame: CGRect.zero)
   private var rightThumbView = ThumbView(frame: CGRect.zero)
   private var contentView = UIView()
   private var trackBackgroundLayer = CAShapeLayer()
   private var trackLayer = CAShapeLayer()
   
   @IBInspectable
   public var minValue:CGFloat = 0 {
      didSet {
         setupPositions()
      }
   }
   @IBInspectable
   public var maxValue:CGFloat = 1 {
      didSet {
         setupPositions()
      }
   }
   
   public var minDistance:CGFloat = 0.2  {// 0.0 - 1.
      willSet {
         if !(newValue >= 0 && newValue < 1) {
            let exeption = NSException(name: TumbsSliderParametrExeption, reason: "Incorrect minDistance", userInfo: nil)
            exeption.raise()
         }
      }
   }
   
   @IBInspectable
   public var leftValue:CGFloat = 0 {
      didSet {
         setupPositions()
      }
   }
   
   @IBInspectable
   public var rightValue:CGFloat = 1 {
      didSet {
         setupPositions()
      }
   }
   
   @IBInspectable
   public var leftThumbColor:UIColor = UIColor.blueColor() {
      didSet {
         leftThumbView.backgroundColor = leftThumbColor
      }
   }
   
   @IBInspectable
   public var rightThumbColor:UIColor = UIColor.blueColor() {
      didSet {
         rightThumbView.backgroundColor = rightThumbColor
      }
   }
   
   
   @IBInspectable
   public var leftThumbImage:UIImage = UIImage() {
      didSet{
         leftThumbView.image = leftThumbImage
         leftThumbView.layer.masksToBounds = true
      }
   }
   
   @IBInspectable
   public var rightThumbImage:UIImage = UIImage() {
      didSet{
         rightThumbView.image = rightThumbImage
         rightThumbView.layer.masksToBounds = true
      }
   }
   
   @IBInspectable
   public var trackColor:UIColor = UIColor(red: 9/255, green: 90/255, blue: 255/255, alpha: 1) {
      didSet{
         trackLayer.strokeColor = trackColor.CGColor
      }
   }
   
   @IBInspectable
   public var backgroundTrackColor:UIColor = UIColor.lightGrayColor() {
      didSet {
         trackBackgroundLayer.strokeColor = backgroundTrackColor.CGColor
      }
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
   }
   
   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
   }
   
   override public func prepareForInterfaceBuilder() {
      setup()
   }
   
   override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
      if let touch = touches.first {
         let location = touch.locationInView(self)
         if leftThumbView.frame.insetBy(dx: -extraTapInset, dy: -extraTapInset).contains(location) {
            moveLeftThumbToLocation(touch.locationInView(self))
            sendActionsForControlEvents(.ValueChanged)
         }
         if rightThumbView.frame.insetBy(dx: -extraTapInset, dy: -extraTapInset).contains(location) {
            moveRightThumbToLocation(touch.locationInView(self))
            sendActionsForControlEvents(.ValueChanged)
         }
      }
   }
   
   override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
      let convertedPoint = convertPoint(point, toView: self)
      
      if leftThumbView.frame.contains(convertedPoint) || rightThumbView.frame.contains(convertedPoint) {
         return self
      }
      return super.hitTest(point, withEvent: event)
   }
}

//setup

extension TwoThumbsSlider {
   
   private class func configThumbView(thumbView:ThumbView) {
      
      thumbView.layer.cornerRadius = thumbView.frame.width/2.0
      
      thumbView.layer.shadowColor = UIColor.grayColor().CGColor
      thumbView.layer.shadowRadius = 2
      
      let shadowPath = UIBezierPath(ovalInRect: thumbView.bounds)
      thumbView.layer.masksToBounds = false
      thumbView.layer.shadowColor = UIColor.blackColor().CGColor
      thumbView.layer.shadowOffset = CGSizeMake(0.0, 2.0)
      thumbView.layer.shadowOpacity = 0.5
      thumbView.layer.shadowPath = shadowPath.CGPath
   }
   
   private func setup() {
      clipsToBounds = false
      multipleTouchEnabled = true
      setupContentView()
      setupBackgroundTrackLayer()
      setupTrackLayer()
      setupLeftThumb()
      setupRightThumb()
      setupPositions()
   }
   
   private func setupContentView() {
      addSubview(contentView)
      contentView.frame = CGRectInset(bounds, 0, 0)
   }
   
   private func setupLeftThumb() {
      addSubview(leftThumbView)
      leftThumbView.frame = CGRect(x: 0, y: 0, width: tumbWidth, height: tumbWidth)
      leftThumbView.center = CGPoint(x: contentView.frame.origin.x, y: contentView.center.y)
      TwoThumbsSlider.configThumbView(leftThumbView)
   }
   
   private func setupRightThumb() {
      addSubview(rightThumbView)
      rightThumbView.frame = CGRect(x: 0, y: 0, width: tumbWidth, height: tumbWidth)
      rightThumbView.center = CGPoint(x: contentView.frame.maxX, y: contentView.center.y)
      TwoThumbsSlider.configThumbView(rightThumbView)
   }
   
   private func setupBackgroundTrackLayer() {
      let path = UIBezierPath()
      path.moveToPoint(CGPoint(x: 0, y: contentView.center.y))
      path.addLineToPoint(CGPoint(x: contentView.frame.width, y: contentView.center.y))
      
      layer.addSublayer(trackBackgroundLayer)
      trackBackgroundLayer.frame = contentView.frame
      trackBackgroundLayer.strokeColor = backgroundTrackColor.CGColor
      trackBackgroundLayer.lineWidth = 2
      trackBackgroundLayer.path = path.CGPath
   }
   
   private func setupTrackLayer() {
      let path = UIBezierPath()
      path.moveToPoint(CGPoint(x: 0, y: contentView.center.y))
      path.addLineToPoint(CGPoint(x: contentView.frame.width, y: contentView.center.y))
      
      layer.addSublayer(trackLayer)
      trackLayer.frame = contentView.frame
      trackLayer.strokeColor = trackColor.CGColor
      trackLayer.lineWidth = 2
      trackLayer.path = path.CGPath
   }
}

//config position

extension TwoThumbsSlider {
   
   private func valueForPossition(position:CGPoint) -> CGFloat {
      
      let convertedPoint = convertPoint(position, toView: contentView)
      let value = convertedPoint.x * (maxValue - minValue)/contentView.frame.width + minValue
      
      if value < 0 {
         return 0
      }
      if value > maxValue {
         return maxValue
      }
      return value
   }
   
   private func positionForValue(value:CGFloat) -> CGPoint {
      let x:CGFloat = fabs((value - minValue)/(maxValue - minValue))*bounds.width
      let position = CGPoint(x: x, y: contentView.center.y)
      return position
   }
   
   private func moveLeftThumbToLocation(location:CGPoint) {
      let useableTrackLength = contentView.frame.width
      if location.x > contentView.frame.minX - tumbWidth/2 &&
         location.x + minDistance*useableTrackLength < rightThumbView.center.x {
            leftValue = valueForPossition(location)
      }
   }
   
   private func moveRightThumbToLocation(location:CGPoint) {
      if leftThumbView.center.x + minDistance * contentView.frame.width < location.x &&
         location.x < frame.width + tumbWidth {
            rightValue = valueForPossition(location)
      }
   }
   
   private func setupPositions() {
      let percentStart = fabs((leftValue - minValue)/(maxValue - minValue))
      let percentEnd = fabs((rightValue - minValue)/(maxValue - minValue))
      
      leftThumbView.center = positionForValue(leftValue);
      rightThumbView.center = positionForValue(rightValue);
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      trackLayer.strokeStart = percentStart
      trackLayer.strokeEnd = percentEnd
      CATransaction.commit()
   }
   
}

private class ThumbView : UIImageView {
   
   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!
      setup()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
   }
   
   private func setup() {
      backgroundColor = UIColor.whiteColor()
      contentMode = .ScaleToFill
   }
}
