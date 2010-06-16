// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import "Big5WebAppAppDelegate.h"
#import "RootViewController.h"
#import "big5ViewController.h"
#import "Helpers.h"

@implementation Big5WebAppAppDelegate

@synthesize window, data, pathToUserCopyOfPlist;
@synthesize navigationController, rootViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

    // Check for data in Documents directory. Copy default appData.plist to Documents if not found.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.pathToUserCopyOfPlist = [documentsDirectory stringByAppendingPathComponent:@"appData.plist"];
    if ([fileManager fileExistsAtPath:pathToUserCopyOfPlist] == NO) {
        NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"appData" ofType:@"plist"];
        NSLog(@"copy file %@ %@", pathToDefaultPlist, pathToUserCopyOfPlist);
        if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:pathToUserCopyOfPlist error:&error] == NO) {
            NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
        }
    }
    // Unarchive the data, store it in the local property, and pass it to the main view controller
    self.data = [[NSMutableArray alloc] initWithContentsOfFile:pathToUserCopyOfPlist];
    NSLog(@"Data %@", data);
    
    rootViewController.data = data;
    rootViewController.pathToUserCopyOfPlist = pathToUserCopyOfPlist;

	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
    
    // [self performSelector:@selector(myLoadURL) withObject:nil afterDelay:0.0];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {   
    NSLog(@"app: handle special url");
    
    // You should be extremely careful when handling URL requests.
    // You must take steps to validate the URL before handling it.    
    if (!url) {
        // The URL is nil. There's nothing more to do.
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    if([URLString hasPrefix:@"big5:"]) {        
        URLString = [URLString substringFromIndex:5];
    } else if([URLString hasPrefix:@"bigfive:"]) {        
        URLString = [URLString substringFromIndex:8];    
    } else if([URLString hasPrefix:@"big5lite:"]) {        
        URLString = [URLString substringFromIndex:9];    
    } else if([URLString hasPrefix:@"bigfivelite:"]) {        
        URLString = [URLString substringFromIndex:12];    
    } else if([URLString hasPrefix:@"big5pro:"]) {        
        URLString = [URLString substringFromIndex:8];    
    } else if([URLString hasPrefix:@"bigfivepro:"]) {        
        URLString = [URLString substringFromIndex:11];   
        
    } else if([URLString hasPrefix:@"big5bookmark:"]) {        
        URLString = [URLString substringFromIndex:13];                   
        NSArray *parts = [URLString componentsSeparatedByString:@","];
                
        // NSLog(@"Parts: %@ %@", [parts objectAtIndex:0], [parts objectAtIndex:1]);
                
        // NSMutableArray *settings = [[NSMutableArray alloc] initWithContentsOfFile:pathToUserCopyOfPlist];
        // self.data = [[NSMutableArray alloc] initWithContentsOfFile:pathToUserCopyOfPlist];
        NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [parts objectAtIndex:0], @"title",
                                    [parts objectAtIndex:1], @"url",
                                    nil];        
        [data addObject:obj];
        [data writeToFile:pathToUserCopyOfPlist atomically:NO];

        alert(@"A new bookmark has been added.");

        URLString = [parts objectAtIndex:1];
        // [data release];
        return YES;
    }
    
    NSLog(@"app: srtarting with url %@", [URLString description]);
    
    if (!URLString) {
        // The URL's absoluteString is nil. There's nothing more to do.
        return NO;
    }
    
    // Your application is defining the new URL type, so you should know the maximum character
    // count of the URL. Anything longer than what you expect is likely to be dangerous.
    NSInteger maximumExpectedLength = 255;
    
    if ([URLString length] > maximumExpectedLength) {
        // The URL is longer than we expect. Stop servicing it.
        return NO;
    }
    
    // alert(URLString);
    NSLog(@"app: loading individual url %@", URLString);
    
    // self.gURL = [[NSString alloc] initWithString:URLString];
    
    // NSURL * anURL = [NSURL URLWithString:URLString];
    // NSURLRequest * aRequest = [NSURLRequest requestWithURL:anURL];
    // [WEB loadRequest:aRequest];
    
    // [WEB loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
	
    [self.navigationController 
     setNavigationBarHidden:YES 
     animated:YES];
    
    big5ViewController *controller = [[big5ViewController alloc] init];
    controller.title = @""; //[obj objectForKey:@"title"];
    controller.gURL = [NSURL URLWithString:URLString];    
    [self.navigationController pushViewController:controller animated:NO];    
    [controller release];        
    return YES;
}

- (void)dealloc {
    [pathToUserCopyOfPlist release];
    [rootViewController release];
    [data release];
    [navigationController release];
    [window release];
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // save changes to plist in Documents
    // [data writeToFile:pathToUserCopyOfPlist atomically:NO];
}

@end
