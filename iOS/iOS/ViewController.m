//
//  ViewController.m
//  iOS
//
//  Created by uepay-pc-016 on 2022/6/7.
//

#import "ViewController.h"
#import "DWKWebView.h"
#import <UPWebViewAPI/UPWebViewAPI.h>

@interface ViewController ()<UPWebViewManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"htmlFile"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];
    UPWebViewManager * manager = [UPWebViewManager shareManager];
    DWKWebView * webView = [manager setUpUPWebView];
    [manager loadHtmlFile:pathURL];
    manager.delegate = self;
    webView.frame  = self.view.bounds;
    [self.view addSubview:webView];
    
}

-(void)UPGetLocationWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString * _Nonnull))handleComplete{
    NSDictionary *dict = @{
        @"ret_msg" : @"成功",
        @"ret_code" : @"00"
        
    };
    NSError *parseError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出错
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    handleComplete(json);
}

- (void)UPBeginPayWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString * _Nonnull))handleComplete{
    NSError *parseError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出错
    }
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    handleComplete(json);
}

- (void)UPWebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.customUserAgent);
}



@end
