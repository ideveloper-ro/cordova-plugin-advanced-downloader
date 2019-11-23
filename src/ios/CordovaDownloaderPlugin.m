#import "CordovaDownloaderPlugin.h"
#import "CDVFile.h"
#import "SDNetworkActivityIndicator.h"
#import "FKDownloader.h"

@interface CordovaDownloaderPlugin()

@end

@implementation CordovaDownloaderPlugin {}

- (void)pluginInitialize {
}

- (void)downloadFile:(CDVInvokedUrlCommand*)command {
    NSLog(@"DOWNLOAFILE!!!");
    
    NSString *url = [command.arguments objectAtIndex:0];
    NSString *filePath = [command.arguments objectAtIndex: 2];
    
    
    [[SDNetworkActivityIndicator sharedActivityIndicator] startActivity];
    
    @try {
        NSArray *urls = [NSArray arrayWithObject:url];
        
        [[FKDownloadManager manager] addTasksWithArray:urls.copy];
        [[FKDownloadManager manager ] start:url];
        [[FKDownloadManager manager] acquire:url].delegate = self;
        [[FKDownloadManager manager ] acquire:url].progressBlock = ^(FKTask *task) {
            NSLog(@"progress changed %.6f - %@", task.progress.fractionCompleted, task.bytesPerSecondSpeedDescription);
        };
        
        [[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    } @catch (NSException *exception) {
        [[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    }
}

@end
