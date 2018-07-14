//
//  ClicaptchaView.swift
//  Clicaptcha
//
//  Created by 009 on 2018/6/21.
//  Copyright © 2018年 009. All rights reserved.
//

import UIKit

private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height
private let keyWindow = UIApplication.shared.keyWindow
typealias SuccessValidation = () -> Void
typealias FailsValidation = () -> Void
class ClicaptchaView: UIView, UIGestureRecognizerDelegate, CanvasViewDelegate {
    open var successVal: SuccessValidation?
    open var failsVal: FailsValidation?
    open var targetTexts: [String]! {
        didSet {
            count = targetTexts.count
        }
    }
    open var disturbingText: String!
    private lazy var container: UIView! = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 30, height: 0))
        container.backgroundColor = .clear
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        return container
    }()
    private var titleL: UILabel!
    private var canvasView: CanvasView!
    init() {
        super.init(frame: UIScreen.main.bounds)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGes.delegate = self
        self.addGestureRecognizer(tapGes)
        self.addSubview(self.container)
        container.center = self.center
        
    }
    
    func displayContentUI() {
        
        titleL = UILabel(frame: CGRect(x: 0, y: 0, width: container.frame.width, height: 40))
        titleL.backgroundColor = UIColor.hex(hex: 0x1C93D5, alpha: 1.0)
        titleL.text = "课件签到 剩余时间\(times!)秒 次数\(targetTexts.count)次"
        titleL.font = UIFont.systemFont(ofSize: 15)
        titleL.textColor = .white
        titleL.textAlignment = .center
        startClicked()
        
        container.addSubview(titleL)
        
        let y = container.frame.height - 55
        let w = (container.frame.width - (screenWidth/414)*123) / 2
        
        let okBtn = UIButton(type: .system)
        okBtn.frame = CGRect(x: 15, y: y, width: w, height: 40)
        okBtn.backgroundColor = UIColor.hex(hex: 0x5EB5DF, alpha: 1.0)
        okBtn.layer.cornerRadius = 5
        okBtn.clipsToBounds = true
        okBtn.setTitle("确定", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.addTarget(self, action: #selector(startPlay), for: .touchUpInside)
        container.addSubview(okBtn)
        
        let cancleBtn = UIButton(type: .system)
        cancleBtn.frame = CGRect(x: container.frame.width - 15 - w, y: y, width: w, height: 40)
        cancleBtn.backgroundColor = UIColor.hex(hex: 0x5EB5DF, alpha: 1.0)
        cancleBtn.layer.cornerRadius = 5
        cancleBtn.clipsToBounds = true
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(.white, for: .normal)
        cancleBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        container.addSubview(cancleBtn)
        
        canvasView = CanvasView(frame: CGRect(x: 0, y: titleL.frame.height, width: container.frame.width, height: container.frame.height - titleL.frame.height - 55))
        canvasView.targetText = targetTexts[0]
        canvasView.disturbingText = getDisturbingText() + targetTexts[0]
        canvasView.delegate = self
        container.addSubview(canvasView)
    }
    private  var clickText = ""
    func clickText(text: String) {
        clickText = text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var count: Int!
    private var clickCount = 0
    @objc private func startPlay() {
        
        if clickText == targetTexts[clickCount] {
//            if clickCount == count - 1 {
//                close()
//                successVal!()
//
//            } else {
//                if clickCount < count {
//                    times = 60
//                    startClicked()
//                    clickCount = clickCount + 1
//                    titleL.text = "课件签到 剩余时间\(times!)秒 次数\(count - clickCount)次"
//                    canvasView.targetText = targetTexts[clickCount]
//                    canvasView.disturbingText = getDisturbingText() + targetTexts[clickCount]
//                }
//            }
            close()
            successVal!()
        } else {
            if clickCount < count {
                times = 60
                startClicked()
                clickCount = clickCount + 1
                if clickCount == count {
                    close()
                    return
                }
                titleL.text = "课件签到 剩余时间\(times!)秒 次数\(count - clickCount)次"
                canvasView.targetText = targetTexts[clickCount]
                canvasView.disturbingText = getDisturbingText() + targetTexts[clickCount]
            }
            failsVal!()
        }
    }
    private var times: Int! = 60
    private var timer :Timer!
    func startClicked() {
        //获取该计时器的剩余时间
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    @objc func tickDown() {
        times = times - 1
        titleL.text = "课件签到 剩余时间\(times!)秒 次数\(count - clickCount)次"
        if times <= 0 {
            //取消定时器
            timer.invalidate()
            timer = nil
            close()
        }
    }
    
    /// 显示
    open func show() {
        keyWindow?.addSubview(self)
        keyWindow?.bringSubview(toFront: self)
        UIView.animate(withDuration: 0.21, animations: {
            self.container.frame.size.height = 280
            self.container.center = self.center
            self.container.backgroundColor = UIColor.hex(hex: 0xEDF0F0, alpha: 1.0)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: { (finish: Bool) in
            self.displayContentUI()
        } )
        
    }
    
    @objc private func close() {
        UIView.animate(withDuration: 0.15, animations: {
            self.container.frame.size.height = 0
            self.container.center = self.center
            self.backgroundColor = .clear
        }) { (finish: Bool) in
            self.container.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }
        return true
    }
    
    // 获取打乱后的字符串
    func getDisturbingText() -> String {
        var texts: [String] = []
        for c in disturbingText {
            texts.append(String(c))
        }
        let shuffleTexts = texts.shuffle()
        let a = shuffleTexts.suffix(8)
        return a.joined(separator: "")
    }
    
}

protocol CanvasViewDelegate: NSObjectProtocol {
    func clickText(text: String)
}
class CanvasView: UIView {
    weak var delegate: CanvasViewDelegate?
    let lineCount = 10
    let lineWidth = 1
    
    var disturbingText: String! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var targetText: String! {
        didSet {
            let a = "按顺序"
            let b = "点击文字:  "
            let c = a + b + targetText
            let aAttribute = [NSAttributedStringKey.foregroundColor: UIColor.hex(hex: 0x66303D, alpha: 1.0),
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)] as [NSAttributedStringKey : Any]
            let bAttribute = [NSAttributedStringKey.foregroundColor: UIColor.hex(hex: 0x66303D, alpha: 1.0),
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)] as [NSAttributedStringKey : Any]
            let cAttribute = [NSAttributedStringKey.foregroundColor: UIColor.hex(hex: 0xF50014, alpha: 1.0),
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)] as [NSAttributedStringKey : Any]
            let attString = NSMutableAttributedString(string: c)
            attString.addAttributes(aAttribute, range: NSRange.init(location: 0, length: a.count))
            attString.addAttributes(bAttribute, range: NSRange.init(location: a.count, length: b.count))
            attString.addAttributes(cAttribute, range: NSRange.init(location: a.count + b.count, length: targetText.count))
            targetL.attributedText = attString
        }
    }
    var targetL: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        targetL = UILabel(frame: CGRect(x: 10, y: 0, width: frame.width - 20, height: 30))
        targetL.backgroundColor = .clear
        addSubview(targetL)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 获取打乱后的字符串
    func getDisturbingTexts() -> [String] {
        var texts: [String] = []
        for c in disturbingText {
            texts.append(String(c))
        }
        let shuffleTexts = texts.shuffle()
        return shuffleTexts
    }
    // 文字的随机颜色
    let colors = [UIColor.hex(hex: 0x17514F, alpha: 1.0), UIColor.hex(hex: 0x6D485A, alpha: 1.0), UIColor.hex(hex: 0x2A7529, alpha: 1.0), UIColor.hex(hex: 0x716468, alpha: 1.0), UIColor.hex(hex: 0x173125, alpha: 1.0), UIColor.hex(hex: 0x352161, alpha: 1.0), UIColor.hex(hex: 0x6FC4DA, alpha: 1.0), UIColor.hex(hex: 0x517579, alpha: 1.0), UIColor.hex(hex: 0x2D6489, alpha: 1.0), .red, .orange, .green, .blue, .cyan, .purple]
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 画干扰点
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        for _ in 0..<300 {
            context!.setStrokeColor(UIColor.hex(hex: 0x6d6d6d, alpha: 1.0).cgColor)
            let x = CGFloat(self.randomNum(Int(rect.size.width)))
            let y = CGFloat(self.randomNum(Int(rect.size.height)))
            context?.move(to: CGPoint(x: x, y: y))
            context?.addLine(to: CGPoint(x: x+2, y: y+2))
            context!.strokePath()
        }
        
        // 画字
        for v in subviews {
            if v is UIButton {
                v.removeFromSuperview()
            }
        }
        clickText = ""
        let texts = getDisturbingTexts()
        let endString = texts.joined(separator: "")
        // 设每个字符需要的宽度
        let w: CGFloat = self.frame.size.width / CGFloat(endString.count)
        for index in 0..<texts.count {
            let text = texts[index]
            let font = UIFont.systemFont(ofSize: CGFloat(randomNum(10) + 17))
//            let attribute = [NSAttributedStringKey.foregroundColor: randomColor(),
//                              NSAttributedStringKey.font: font] as [NSAttributedStringKey : Any]

            let pX = CGFloat(index * Int(w))
            let pY = CGFloat(30 + randomNum(Int(self.frame.height - 30 - CGFloat(w + 8))))
//            (text as NSString).draw(at: CGPoint(x: pX, y: pY), withAttributes: attribute)
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: pX, y: pY, width: w, height: w)
            button.backgroundColor = .clear
            button.setTitle(text, for: .normal)
            button.titleLabel?.font = font
            button.setTitleColor(colors[randomNum(colors.count)], for: .normal)
            button.tag = 10001 + index
            button.layer.cornerRadius = w/2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(clickTextBtn), for: .touchUpInside)
            addSubview(button)
        }
        
        // 画干扰线
        context!.setLineWidth(1.0)
        for _ in 0..<20 {
            // 随机颜色
            context!.setStrokeColor(self.randomColor().cgColor)
            var pX:CGFloat = 0.0
            var pY:CGFloat = 0.0
            // 起点
            pX = CGFloat(self.randomNum(Int(rect.size.width)))
            pY = CGFloat(30 + randomNum(Int(self.frame.height - 30 - CGFloat(w + 8))))
            context?.move(to: CGPoint(x: pX, y: pY))
            // 终点
            pX = CGFloat(self.randomNum(Int(rect.size.width)))
            pY = CGFloat(30 + randomNum(Int(self.frame.height - 30)))
            context?.addLine(to: CGPoint(x: pX, y: pY))
            // 画线
            context!.strokePath()
        }
    }
    var clickText = ""
    @objc func clickTextBtn(btn: UIButton) {
        btn.backgroundColor = UIColor.hex(hex: 0xCCCCFF, alpha: 1.0)
        let text = (btn.titleLabel?.text)!
        if !clickText.contains(text) {
            clickText += text
        } else {
            btn.backgroundColor = .clear
            clickText = clickText.replacingOccurrences(of: text, with: "")
        }
        delegate?.clickText(text: clickText)
    }

    func randomNum(_ num:Int)->Int {
        let ranNum = arc4random()%UInt32(num)
        return Int(ranNum)
    }
    
    func randomColor() -> UIColor {
        let ranColor = UIColor(red: CGFloat(randomNum(256))/256.0, green: CGFloat(randomNum(256))/256.0, blue: CGFloat(randomNum(256))/256.0, alpha: 1)
        return ranColor
    }
}

extension UIColor {
    class func hex(hex: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((hex >> 16) & 0xFF)/255.0, green: CGFloat((hex >> 8) & 0xFF)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: alpha)
    }
}
extension Array {
    public func shuffle() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        return list
    }
}
