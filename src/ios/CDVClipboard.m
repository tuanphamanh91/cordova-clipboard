#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString     *url       = [command.arguments objectAtIndex:0];
        if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && ([url hasSuffix:@".png"] || [url hasSuffix:@".jpeg"]) ) {
            // photo url
            NSData *imageData         = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            [pasteboard setData:imageData forPasteboardType:(__bridge NSString *)kUTTypePNG];
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:imageData];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            // text
            pasteboard.string = url;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [pasteboard valueForPasteboardType:@"public.text"];
	    if (text == nil) {
            text = @"";
        }

	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)clear:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    	[pasteboard setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
	    
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end
