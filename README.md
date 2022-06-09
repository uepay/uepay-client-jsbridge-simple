# uepay-client-jsbridge-simple
**UePayJSBridge** 是前端Web頁面通過 js 與原生客戶端（Android&IOS）進行交互的通信橋樑。通過此對象可以很方便的實現跨端調用。

> PS：此UePayJSBridge對象，是在客戶端（Android&IOS）初始化 WebView 完成時，創建並注入至瀏覽器的 doucument 中，從而實現 js 調用原生Native方法。


![](https://github.com/uepay/uepay-client-jsbridge-simple/blob/main/res/1.jpeg)
![](https://github.com/uepay/uepay-client-jsbridge-simple/blob/main/res/2.jpeg)

## 目錄
代碼關鍵目錄介紹


	|- Android（Android原生示例代碼）
	|- iOS（IOS原始示例代碼）
	|- index.html（前端js示例代碼）

客戶端使用文檔

- [Android 文檔](https://github.com/uepay/uepay-client-jsbridge-simple/blob/main/android/README.md) 

- [IOS 文檔](https://github.com/uepay/uepay-client-jsbridge-simple/tree/main/iOS/iOS/README.md) 

## 如何使用？
1. 進入Web頁面時，默認監聽 UePayJSBridge 對象準備就緒事件（**根據實際需求選擇是否需要監聽**）

	```js
	// 此方式用於打開頁面默認需要調用JS對象函數的情況（自動觸發調用）
    function onBridgeReady() {
        getLocation();
    }


    // 打開HTML頁面，添加客戶端JS注入完成的回調事件監聽
    if (typeof UePayJSBridge == "undefined") {
        if (document.addEventListener) {
            document.addEventListener('UePayJSBridgeReady', onBridgeReady, false);
        } else if (document.attachEvent) {
            document.attachEvent('UePayJSBridgeReady', onBridgeReady);
        }
    } else {
        onBridgeReady();
    }
	```
2. 調用接口獲取定位

	```js
	// 獲取定位
    function getLocation() {
        var req = {
            "type": "wgs84", // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
        }
        UePayJSBridge.callHandler(
            'getLocation',
            req,
            (res) => {
                var obj = JSON.parse(res);
                if (obj.ret_code === '00') { // 成功
                    var latitude = obj.latitude; // 纬度，浮点数，范围为90 ~ -90
                    var longitude = obj.longitude; // 经度，浮点数，范围为180 ~ -180。
                    var speed = obj.speed; // 速度，以米/每秒计
                    var accuracy = obj.accuracy; // 位置精度
                }
                if (obj.ret_code === '01') { // 失敗
                    alert(obj.ret_msg);
                }
            }
        )
    }
	```
3. 調用接口喚醒支付

	```js
	// 喚醒客戶端支付
    function payment() {

       // 服務端通過 極易付下單接口 獲取喚醒客戶端支付參數
        var req = { 
            "appId": "000030000300000", 
            "timeStamp": 158190790, 
            "nonceStr": "43209cfd7e9c2b20f16a60942d04b1016", 
            "prepayid": "UEPAY2000001810500882040194", 
            "signType": "MD5", 
            "paySign": "EC1DEEB32CAEE9AC3AAB9789E249D9EA" 
        };

        UePayJSBridge.callHandler(
            "sendPayReq",
            req,
            (res) => {
                var obj = JSON.parse(res);
                alert("res: " + res);
                if (obj.ret_code === '00') { 
                    // 支付成功
                    // {"ret_code":"00","ret_msg":"success"}
                } else if (obj.ret_code === '01') {
                    // 支付失敗（未知錯誤）
                    // {"ret_code":"01","ret_msg":"failed"}
                } else if (obj.ret_code === '02') {
                    // 用戶取消支付
                    // {"ret_code":"02","ret_msg":"cancel"}
                }
            }
        );
    }
	```
