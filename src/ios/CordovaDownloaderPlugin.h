#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CordovaDownloaderPlugin : CDVPlugin

@property (nonatomic, strong) NSString *callbackId;

- (void)downloadFile:(CDVInvokedUrlCommand*)command;

@end
