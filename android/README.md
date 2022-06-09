#	UePay-SDK-WebView for Android

Android 客戶端 WebView 組件SDK示例使用說明

## 安裝
1. 導入aar文件
	
	將 **uepay-sdk-webview-2.0.5-SNAPSHOT.aar** 文件導入到項目的 **libs** 目錄下
	
1. 添加依賴
	
	在主項目的 build.gradle 文件中添加
	
	```groovy
	dependencies {
    	implementation files('libs/uepay_sdk_webview-2.0.5-SNAPSHOT.aar')
    	...
	}
	```
	
## 使用
1. 在佈局中聲明使用組件

	```xml
    <com.uepay.web.UePayWebView
        android:id="@+id/web_view"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />
	```
2. 初始化配置

	```java
	/**
     * 根據需要設置WebView屬性
     */
    private void setupWebView() {
        WebSettings settings = webView.getSettings();
        String originUA = settings.getUserAgentString();
        // 添加瀏覽器自定義的 userAgent 信息；"Customer/Text" 可替換成任意字符串
        String newUA = new StringBuilder(originUA).append("; Customer/Text").toString();
        settings.setUserAgentString(newUA);
    }
	```
3. 註冊提供給 js 調用的函數
	
	```java
	/**
     * 註冊native原生方法，提供給JS側調用
     */
    private void registerHandler() {
        // 獲取定位信息
        webView.registerHandler("getLocation", (data, function) -> {
            /**
             * 模擬獲取位置信息，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Response res = new Response();
            res.ret_code = "00"; // 00：成功，01：失敗
            res.ret_msg = "獲取定位成功";
            res.latitude = 20.146551;
            res.longitude = 112.346848;
            res.speed = 0;
            res.accuracy = 100;
            function.onCallback(g.toJson(res));
        });
        // 喚醒支付
        webView.registerHandler("sendPayReq", (data, function) -> {
            showMsgDialog(data, function);
        });
    }
	```
4. 回調返回結果
	
	```java
	private void showMsgDialog(String data, final CallbackFunction function) {
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("发起支付");
        dialog.setMessage("订单信息：" + data);
        dialog.setPositiveButton("支付完成", (dialog3, which) -> {
            /**
             * 模擬 用戶支付成功，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","00");
            resp.put("ret_msg","success");
            function.onCallback(g.toJson(resp));
        });
        dialog.setNeutralButton("支付失敗",(dialog1, which) -> {
            /**
             * 模擬 支付失敗，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","01");
            resp.put("ret_msg","failed");
            function.onCallback(g.toJson(resp));
        });
        dialog.setNegativeButton("取消支付", (dialog2, which) -> {
            /**
             * 模擬 用戶取消支付，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","02");
            resp.put("ret_msg","cancel");
            function.onCallback(g.toJson(resp));
        });
        dialog.show();
    }
	```