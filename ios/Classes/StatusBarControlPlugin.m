#import "StatusBarControlPlugin.h"

@implementation StatusBarControlPlugin

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"status_bar_control" binaryMessenger:[registrar messenger]];
    StatusBarControlPlugin *instance = [[StatusBarControlPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"setColor" isEqualToString:call.method]) {
        result(@YES);
    } else if ([@"setTranslucent" isEqualToString:call.method]) {
        result(@YES);
    } else if ([@"setHidden" isEqualToString:call.method]) {
        [self handleSetHidden:call result:result];
    } else if ([@"setStyle" isEqualToString:call.method]) {
        [self handleSetStyle:call result:result];
    } else if ([@"getHeight" isEqualToString:call.method]) {
        [self handleGetWidth:call result:result];
    } else if ([@"setNetworkActivityIndicatorVisible" isEqualToString:call.method]) {
        [self handleNetworkActivity:call result:result];
    } else if ([@"setNavigationBarColor" isEqualToString:call.method]) {
        result(@YES);
    } else if ([@"setNavigationBarStyle" isEqualToString:call.method]) {
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// 替换废弃方法：setStatusBarHidden:withAnimation: 改为使用 prefersStatusBarHidden
- (BOOL)prefersStatusBarHidden {
    // 根据需求返回YES或NO
    return YES; // 或者返回NO
}

// 替换废弃方法：setStatusBarStyle:animated: 改为使用 preferredStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 返回需要的样式，如 UIStatusBarStyleDefault 或 UIStatusBarStyleLightContent
    return UIStatusBarStyleLightContent;
}

// 替换废弃属性：statusBarFrame 改为通过 UIStatusBarManager 获取
- (CGRect)currentStatusBarFrame {
    if (@available(iOS 13.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.windowScene.statusBarManager.statusBarFrame;
    } else {
        return [UIApplication sharedApplication].statusBarFrame;
    }
}

- (void)handleSetHidden:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    bool hidden = [args[@"hidden"] boolValue];
    NSString *animationString = (NSString *) args[@"animation"];
    UIStatusBarAnimation animation;
    if ([animationString isEqualToString:@"none"]) {
        animation = UIStatusBarAnimationNone;
    } else if ([animationString isEqualToString:@"fade"]) {
        animation = UIStatusBarAnimationFade;
    } else {
        animation = UIStatusBarAnimationSlide;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animation];
    result(@YES);
}

- (void)handleSetStyle:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *statusBarStyleString = (NSString *) args[@"style"];
    bool animated = [args[@"animated"] boolValue];
    UIStatusBarStyle statusBarStyle;
    if ([statusBarStyleString isEqualToString:@"default"]) {
        statusBarStyle = UIStatusBarStyleDefault;
    } else if ([statusBarStyleString isEqualToString:@"light-content"]) {
        statusBarStyle = UIStatusBarStyleLightContent;
    } else if ([statusBarStyleString isEqualToString:@"dark-content"]) {
        if (@available(iOS 13.0, *)) {
            statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            statusBarStyle = UIStatusBarStyleDefault;
        }
    } else {
        statusBarStyle = UIStatusBarStyleDefault;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:animated];
    result(@YES);
}

- (void)handleGetWidth:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(@(  [[UIApplication sharedApplication] statusBarFrame].size.height  ));
}

- (void)handleNetworkActivity:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    bool visible = [args[@"visible"] boolValue];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    result(@YES);
}

@end
