#import "CordovaDownloaderPlugin.h"
#import "CDVFile.h"
#import "SDNetworkActivityIndicator.h"
#import "FKDownloader.h"

@interface CordovaDownloaderPlugin() <FKTaskDelegate>

@end

@implementation CordovaDownloaderPlugin {}

- (void)pluginInitialize {
}

- (void)downloadFile:(CDVInvokedUrlCommand*)command {
    self.callbackId = command.callbackId;
    
    NSString *url = [command.arguments objectAtIndex:0];
    NSString *filePath = [command.arguments objectAtIndex:1];
    if ([filePath hasPrefix:@"file://"]) {
        filePath = [filePath substringFromIndex:7];
    }
    
    [[_SDNetworkActivityIndicator sharedActivityIndicator] startActivity];
    
    @try {
//        NSArray *urls = [NSArray arrayWithObject:url];
        
        NSArray *tasks = [NSArray arrayWithObject:@{FKTaskInfoURL: url,
            FKTaskInfoFileName: [[url lastPathComponent] stringByDeletingPathExtension],
            FKTaskInfoVerificationType: @(VerifyTypeMD5),
            FKTaskInfoVerification: @"5f75fe52c15566a12b012db21808ad8c",
            FKTaskInfoRequestHeader: @{},
            FKTaskInfoTags: @[@"group_task_01"],
            FKTaskInfoSavePath: [filePath stringByAppendingString:@"/file"],
            FKTaskInfoResumeSavePath: [filePath stringByAppendingString:@"/resume"]
        }];
        
        
        [[FKDownloadManager manager] addTasksWithArray:tasks.copy];
        
        [[FKDownloadManager manager] acquire:url].savePath = filePath;
        [[FKDownloadManager manager] acquire:url].delegate = self;

        [[FKDownloadManager manager] acquire:url].progressBlock = ^(FKTask *task) {
            NSLog(@"progress changed %.6f - %@", task.progress.fractionCompleted, task.bytesPerSecondSpeedDescription);
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:task.bytesPerSecondSpeedDescription forKey:@"speed"];
            [dictionary setObject:task.estimatedTimeRemainingDescription forKey:@"eta"];
            [dictionary setObject:[NSString stringWithFormat:@"%.6f", task.progress.fractionCompleted] forKey:@"percentage"];
            
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictionary];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };
        [[FKDownloadManager manager] start:url];

        [[_SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    } @catch (NSException *exception) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Download error"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        [[_SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
    }
}


- (void)downloader:(FKDownloadManager *)downloader didFinishTask:(FKTask *)task {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSString stringWithFormat:@"file://%@", task.filePath] forKey:@"file"];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

-(void)downloader:(FKDownloadManager *)downloader errorTask:(FKTask *)task {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Download error"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
