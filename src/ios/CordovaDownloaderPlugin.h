#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CordovaDownloaderPlugin : CDVPlugin

- (void)downloadFile:(CDVInvokedUrlCommand*)command;

@end
