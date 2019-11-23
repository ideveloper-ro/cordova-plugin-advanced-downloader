#import "CordovaDownloaderPlugin.h"
#import "CDVFile.h"

@interface CordovaDownloaderPlugin()

@end

@implementation CordovaDownloaderPlugin {}

- (void)pluginInitialize {
}

- (void)downloadFile:(CDVInvokedUrlCommand*)command {
    NSLog(@"DOWNLOAFILE!!!");
}

@end
