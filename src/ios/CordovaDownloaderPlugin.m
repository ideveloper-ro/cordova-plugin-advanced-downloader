#import "CordovaDownloaderPlugin.h"
#import "CDVFile.h"
#import "SDNetworkActivityIndicator.h"
#import "FKDownloadManager.h"

@interface CordovaDownloaderPlugin()

@end

@implementation CordovaDownloaderPlugin {}

- (void)pluginInitialize {
}

- (void)downloadFile:(CDVInvokedUrlCommand*)command {
    NSLog(@"DOWNLOAFILE!!!");
    
    [[SDNetworkActivityIndicator sharedActivityIndicator] startActivity];
    
    @try {
        
        
        [[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    } @catch (NSException *exception) {
        [[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    }
}

@end
