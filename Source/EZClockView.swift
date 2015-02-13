// Copyright (c) 2015 Benoit Layer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

@IBDesignable
public class EZClockView: UIView {
    
    // MARK: - Properties
    private var faceView: UIView = UIView()
    private var centerView: UIView = UIView()
    private var handHours: UIView = UIView()
    private var handMinutes: UIView = UIView()
    private var handSeconds: UIView = UIView()
    
    // MARK: Time
    /// Set this property to change the hour hand position.
    @IBInspectable public var hours: Int = 0 { didSet { updateHands() } }
    /// Set this property to change the minutes hand position.
    @IBInspectable public var minutes: Int = 0 { didSet { updateHands() } }
    /// Set this property to change the seconds hand position.
    @IBInspectable public var seconds: Int = 0 { didSet { updateHands() } }
    
    // MARK: Face
    /// Defines the background color of the face. Defaults to white.
    @IBInspectable public var faceBackgroundColor: UIColor = UIColor.whiteColor() { didSet { faceView.backgroundColor = faceBackgroundColor } }
    /// Defines the border color of the face. Defaults to black.
    @IBInspectable public var faceBorderColor: UIColor = UIColor.blackColor()
    /// Defines the border width of the face. Defaults to 2.
    @IBInspectable public var faceBorderWidth: CGFloat = 2.0
    
    // MARK: Center disc
    /// Defines the color of the rounded part in the middle of the face, over the needles. Default is red.
    @IBInspectable public var centerColor: UIColor = UIColor.redColor() { didSet { centerView.backgroundColor = centerColor } }
    /// Desfines the width of the center circle. Default is 3.0.
    @IBInspectable public var centerRadius: CGFloat = 3.0 { didSet { setupCenterView() } }
    /// Defines the width for the border of this center part. Default is 1.0.
    @IBInspectable public var centerBorderWidth: CGFloat = 1.0 { didSet { centerView.layer.borderWidth = centerBorderWidth } }
    /// Defines the color for the border of this center part. Default is red.
    @IBInspectable public var centerBorderColor: UIColor = UIColor.redColor() { didSet { centerView.layer.borderColor = centerBorderColor.CGColor } }
    
    // MARK: Hour hand
    /// Defines the color for the hours hand. Default to black.
    @IBInspectable public var hoursColor: UIColor = UIColor.blackColor() { didSet { handHours.backgroundColor = hoursColor } }
    /// Defines the length of the hours hand. It is represented as a ratio of the radius of the face. Default to 0.5.
    @IBInspectable public var hoursLength: CGFloat = 0.5 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    /// Defines the thickness of the hours hand. Default is 4.
    @IBInspectable public var hoursThickness: CGFloat = 4 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    /// Defines the distance by which the hours hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var hoursOffset: CGFloat = 2 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    
    // MARK: Minute hand
    /// Defines the color for the minutes hand. Default to black.
    @IBInspectable public var minutesColor: UIColor = UIColor.blackColor() { didSet { handMinutes.backgroundColor = minutesColor } }
    /// Defines the length of the minutes hand. It is represented as a ratio of the radius of the face. Default to 0.7.
    @IBInspectable public var minutesLength: CGFloat = 0.7 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    /// Defines the thickness of the minutes hand. Default is 2.
    @IBInspectable public var minutesThickness: CGFloat = 2 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    /// Defines the distance by which the minutes hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var minutesOffset: CGFloat = 2 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    
    // MARK: Second hand
    /// Defines the color for the seconds hand. Default to red.
    @IBInspectable public var secondsColor: UIColor = UIColor.redColor() { didSet { handSeconds.backgroundColor = secondsColor } }
    /// Defines the length of the seconds hand. It is represented as a ratio of the radius of the face. Default to 0.8.
    @IBInspectable public var secondsLength: CGFloat = 0.8 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    /// Defines the thickness of the seconds hand. Default is 1.
    @IBInspectable public var secondsThickness: CGFloat = 1 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    /// Defines the distance by which the seconds hand will overlap over the center of the face. Default is 2.
    @IBInspectable public var secondsOffset: CGFloat = 2 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    
    // MARK: - Public methods
    /**
    Set the time the clock will display. You can animate it or not.
    
    :param: h The hour to set
    :param: m The minute to set
    :param: s The second to set
    :param: animated Whether or not the change should be animated (default to false).
    */
    public func setTime(#h: Int, m: Int, s: Int, animated: Bool = false) {
        hours = h
        minutes = m
        seconds = s
        updateHands(animated: animated)
    }
    
    /**
    Set the time the clock will display directly by using an NSDate instance.
    
    :param: date The date to display. Only hours, minutes, and seconds, will be taken into account.
    :param: animated Whether or not the change should be animated (default to false).
    */
    public func setTime(date: NSDate, animated: Bool = false) {
        let components = NSCalendar.currentCalendar().components((.HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit), fromDate: date)
        hours = components.hour
        minutes = components.minute
        seconds = components.second
        updateHands(animated: animated)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
        
        // Reset all transforms
        setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset)
        setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset)
        setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset)
        
        setupCenterView()
        
        handHours.backgroundColor = hoursColor
        handMinutes.backgroundColor = minutesColor
        handSeconds.backgroundColor = secondsColor
        
        faceView.frame.size = CGSize(width: clockRadius, height: clockRadius)
        faceView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        faceView.layer.cornerRadius = clockRadius/2.0
        faceView.backgroundColor = faceBackgroundColor
        faceView.layer.borderWidth = faceBorderWidth
        faceView.layer.borderColor = faceBorderColor.CGColor
        
        
        setTime(h: hours, m: minutes, s: seconds)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if (faceView.superview == nil) {
            
            self.backgroundColor = UIColor.clearColor()
            
            self.addSubview(faceView)
            self.addSubview(handHours)
            self.addSubview(handMinutes)
            self.addSubview(handSeconds)
            self.addSubview(centerView)
        }
    }
    
    // MARK: - Private methods
    private func setupHand(hand: UIView, lengthRatio: CGFloat, thickness: CGFloat, offset: CGFloat) {
        hand.transform = CGAffineTransformIdentity
        hand.layer.allowsEdgeAntialiasing = true
        
        let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
        let handLength = (clockRadius/2.0) * CGFloat(lengthRatio)
        
        let anchorX: CGFloat = 0.5
        let anchorY: CGFloat = 1.0 - (offset/handLength)
        hand.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        
        let centerInParent = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        hand.frame = CGRectMake(centerInParent.x-(thickness/2), centerInParent.y - handLength + offset, thickness, handLength)

        // Replace the hand at appropriate position
        updateHands()
    }
    
    private func setupCenterView() {
        centerView.bounds = CGRect(origin: CGPointZero, size: CGSize(width: centerRadius*2, height: centerRadius*2))
        centerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        centerView.layer.cornerRadius = centerRadius
        centerView.backgroundColor = centerColor
        centerView.layer.borderColor = centerBorderColor.CGColor
        centerView.layer.borderWidth = centerBorderWidth
    }
    
    private func updateHands(animated: Bool = false) {
        // Put everything in seconds to have ratios
        let hoursInSeconds = (hours%12)*3600
        let minutesInSeconds = (minutes%60)*60
        let secondsInSeconds = (seconds%60)
        
        let hoursRatio = CGFloat(hoursInSeconds + minutesInSeconds + secondsInSeconds) / 43200.0
        let minutesRatio = CGFloat(minutesInSeconds + secondsInSeconds) / 3600.0
        let secondsRatio = CGFloat(secondsInSeconds) / 60.0
        
        if (animated) {
            UIView.animateWithDuration(0.3) {
                self.handSeconds.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*secondsRatio)
                self.handMinutes.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*minutesRatio)
                self.handHours.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*hoursRatio)
            }
        } else {
            handSeconds.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*secondsRatio)
            handMinutes.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*minutesRatio)
            handHours.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*hoursRatio)
        }
    }
}