//
//  ViewController.swift
//  Clicaptcha
//
//  Created by 009 on 2018/6/21.
//  Copyright © 2018年 009. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickBtn(_ sender: Any) {
        let c = ClicaptchaView()
        c.targetTexts = ["减速让行", "前方学校", "注意行人", "回复的咖"]
        c.disturbingText = "花开怀照亮你的心扉伤心也是带着微笑的眼泪数不尽相逢等不完守候如果仅有此生又何用待从头"
        c.successVal = { // 验证成功后的事件
            print("验证成功，开始播放")
        }
        c.failsVal = { // 每次验证时失败的事件
            print("验证失败，请重试")
        }
        c.show()
    }
    
}

