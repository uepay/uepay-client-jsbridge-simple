//
//  UPWebView.h
//  UPWebViewAPI
//
//  Created by uepay-pc-016 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class DWKWebView;
@class UPPayJsApi;
NS_ASSUME_NONNULL_BEGIN

@protocol UPWebViewManagerDelegate<NSObject>

//獲取定位
-(void)UPGetLocationWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString *))handleComplete;

//支付
- (void)UPBeginPayWithParameter: (NSDictionary *)parameter andCallBack: (void(^)(NSString *))handleComplete;
- (void)UPWebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
@end

@interface UPWebViewManager : NSObject

@property(weak,nonatomic)id<UPWebViewManagerDelegate > delegate;

+(instancetype)shareManager;
-(DWKWebView *)setUpUPWebView;
//加載url地址
-(void)loadUrlString:(NSString *)urlString;
//加載本地html文件
-(void)loadHtmlFile:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
