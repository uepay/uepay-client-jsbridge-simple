//
//  UPWebView.h
//  UPWebViewAPI
//
//  Created by uepay-pc-016 on 2022/6/9.
//

#import <WebKit/WebKit.h>
#import <UPWebViewSDK/DWKWebView.h>
NS_ASSUME_NONNULL_BEGIN

@protocol UPWebViewDelegate<NSObject>

//獲取定位
-(void)UPGetLocationWithParameter:(NSDictionary *)parameter andCallBack:(void (^)(NSString *))handleComplete;

//支付
- (void)UPBeginPayWithParameter: (NSDictionary *)parameter andCallBack: (void(^)(NSString *))handleComplete;
@end

@interface UPWebView : DWKWebView
@property(weak,nonatomic)id<UPWebViewDelegate > delegate;
-(instancetype)initWebView;
-(void)loadHtmlFile:(NSURL *)url withUserAgent:(NSString *)userAgent;
-(void)loadUrlString:(NSString *)urlString withUserAgent:(NSString *)userAgent;
-(void)addJsConfig;
@end

NS_ASSUME_NONNULL_END
