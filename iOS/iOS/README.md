UePay-SDK-WebView for iOS

iOS客戶端 webView組件SDK示例使用說明

安裝
1.導入UPWebViewSDK 和 jsBridge.js文件到工程目錄下
2.導入頭文件#import <UPWebViewSDK/UPWebView.h>

使用
1.初始化組件並設置delegate
UPWebView * webView = [[UPWebView alloc]initWebView];
webView.navigationDelegate = self;
webView.delegate = self;
webView.frame  = self.view.bounds;
[self.view addSubview:webView];

2.加載並設置userAgent
/*
加載urlString
*/
[webView loadUrlString:@"url地址" withUserAgent:@"testDemo"];

3.在WKWebView添加js配置文件
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.webView addJsConfig];
}

4.實現UPWebViewDelegate 方法,註冊js調用的函數
-(void)UPGetLocationWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString * _Nonnull))handleComplete{

    NSDictionary *dict = @{
        @"ret_msg" : @"成功",
        @"ret_code" : @"00",
        @"latitude" : @"20.146551",
        @"longitude" : @"112.346848",
        @"speed" : @"0",
        @"accuracy" : @"100"
        
    };
    NSError *parseError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出錯
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    handleComplete(json);
}

-(void)UPBeginPayWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString * _Nonnull))handleComplete{
    
    //ret_code : 00 成功 01 支付失败 02 取消支付
    
    NSError *parseError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出錯
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self showAlertMessage:json HandleComplete:^(NSString * json) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:json preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

5.回調結果
-(void)showAlertMessage:(NSString *)message HandleComplete:(void(^)(NSString *))handleComplete{
    
    
    //ret_code : 00 成功 01 支付失败 02 取消支付
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"支付成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dict = @{
            @"ret_msg" : @"支付成功",
            @"ret_code" : @"00"
        };
        NSError *parseError;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        handleComplete(json);
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dict = @{
            @"ret_msg" : @"取消支付",
            @"ret_code" : @"02"
        };
        NSError *parseError;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        handleComplete(json);
    }];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"支付失敗" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dict = @{
            @"ret_msg" : @"支付失敗",
            @"ret_code" : @"01"
        };
        NSError *parseError;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        handleComplete(json);
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

