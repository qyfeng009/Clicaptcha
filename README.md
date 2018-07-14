# Clicaptcha
点击验证码

近日一朋友在项目中需要用到点击验证码操作。
需求：在播放视频前需要点击验证码确认，共3次验证机会，每次60秒操作时间，只要又一次验证通过就开始播放，每60秒或验证错误即刷新验证一次，3次都没验证通过就推出播放页面。遂给他就画两个，先看效果：
<p align="center">
<img src="https://github.com/qyfeng009/Clicaptcha/blob/master/1234.gif" width="266" height="500"/>
</p>

###### 思路很简单，具体就看代码吧
1、UI布局等都很简单，干扰线和干扰点 drawRect中绘制。
2、混淆文字，由于需要点击效果于是就采用了取巧的方法，使用Button显示并在容器内随机button位置。

###### 使用
暴露两个属性:
targetTexts 验证码数组，验证机会次数根据此数组长度
disturbingText 混淆文字(不可包括验证目标文字)，显示时随机取值
验证成功和验证失败的回调方法
```
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
    
```
