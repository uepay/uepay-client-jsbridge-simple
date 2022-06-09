//
//  ViewController.m
//  iOS
//
//  Created by uepay-pc-016 on 2022/6/7.
//

#import "ViewController.h"
#import <UPWebViewSDK/UPWebView.h>

@interface ViewController ()<UPWebViewDelegate,WKNavigationDelegate>
@property(weak,nonatomic)UPWebView * webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"htmlFile"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];

    UPWebView * webView = [[UPWebView alloc]initWebView];
    _webView = webView;
    //设置代理
    webView.navigationDelegate = self;
    webView.delegate = self;
    
    //加载html文件
    [webView loadHtmlFile:pathURL withUserAgent:@"testDemo"];
    
    //加载urlString
//    [webView loadUrlString:@"" withUserAgent:@""];
    
    //设置webView层级和frame
    webView.frame  = self.view.bounds;
    [self.view addSubview:webView];
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_webView addJsConfig];
    
}

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
      //解析出错
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    handleComplete(json);
}

-(void)UPBeginPayWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString * _Nonnull))handleComplete{
    
    //ret_code : 00 成功 01 支付失败 02 取消支付
    
    NSError *parseError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出错
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self showAlertMessage:json HandleComplete:^(NSString * json) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:json preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}



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


@end
