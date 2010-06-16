// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import "Constants.h"
#import "Helpers.h"
#import "big5ViewController.h"
#import "Reachability.h"

@implementation big5ViewController

@synthesize gWebView;
@synthesize gURL;
@synthesize gCurrentURL;
@synthesize gImageView;
@synthesize gLastLocation;
@synthesize gNotFoundState;
@synthesize gSupportAutoRotation;
@synthesize gPhotoSaveDestination;
@synthesize gPhotoUploadDestination;

- (id)init {
	self = [super init];
	/* if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"WebTitle", @"");
	} */
    gNotFoundState = false;
    gSupportAutoRotation = false;
    gPhotoSaveDestination = nil;
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [gWebView release];
	// [urlField release];	
	[super dealloc];
}

// MARK: -
// MARK: VIEW
// MARK: -

- (void)loadView {
    NSLog(@"view: load");
    
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
	UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    	
	// important for view orientation rotation
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	self.view = contentView;	
	[contentView release];
    
    // Init web view
    // -------------------------------------------------

    CGRect webFrame = [[UIScreen mainScreen] bounds];

	gWebView = [[UIWebView alloc] initWithFrame:webFrame];
	gWebView.scalesPageToFit = NO;
    gWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	gWebView.delegate = self;
    gWebView.hidden = YES;
	[self.view addSubview:gWebView];
    
    // Show Image while loading
    // -------------------------------------------------
    
    NSLog(@"ACTIVITY");
    gImageView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [gImageView setCenter:CGPointMake(160.0f, 104.0f)];
    [gImageView startAnimating];
    [self.view addSubview:gImageView];

    /*
    UIProgressView *gProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(50.0f, 70.0f, 220.0f, 90.0f)];
    [gProgress setProgressViewStyle:UIProgressViewStyleBar];
    [self.view addSubview:gProgress];
    [gProgress release];
    */
    
    if(gURL) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.gWebView loadRequest:[NSURLRequest 
                                      requestWithURL:gURL
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                      timeoutInterval:60.0
                                      ]];
    }
    
    /*
     gImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"]]];
	[self.view addSubview:gImageView];    
     */
    
}

/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// we do not support rotation in this view controller
	return gSupportAutoRotation;
}

/*
 Implement viewDidLoad if you need to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
}
 */

// MARK: -
// MARK: WEBVIEW
// MARK: -

- (void)setDeviceDefaults {    
    callJavascript(gWebView, @"window.bigfive = {\
       version: '1.2.0', \
       device_document_path: '%s', \
       device_model: '%s', \
       device_version: '%s', \
       device_name: '%s', \
       device_id: '%s'}",
       [documentPath() UTF8String],
       [[[UIDevice currentDevice] model] UTF8String], 
       [[[UIDevice currentDevice] systemVersion] UTF8String],
       [[[UIDevice currentDevice] systemName] UTF8String],
       [[[UIDevice currentDevice] uniqueIdentifier] UTF8String]);        
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	// starting the load, show the activity indicator in the status bar    
    NSLog(@"web: start load %@", [webView.request URL]);  
    gURL = [webView.request URL];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    // [self setDeviceDefaults];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// finished loading, hide the activity indicator in the status bar
    // gURL = [webView.request URL];
    NSLog(@"web: finished loading, request %@", [webView.request description]);

    // NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // NSArray* theCookies = [cookieStorage cookies];
    // NSLog(@"Cookies: %@", theCookies);
        
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    gWebView.hidden = NO;
    [self.view bringSubviewToFront:gWebView];
    if(gImageView!=nil) {
        [gImageView removeFromSuperview];
        [gImageView release];
        gImageView = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// load error, hide the activity indicator in the status bar
    NSLog(@"web: loading failed");

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    gWebView.hidden = NO;
    [self.view bringSubviewToFront:gWebView];

    if(!gNotFoundState) {
        gNotFoundState = true;

        // report the error inside the webview        
        NSString* errorString = [NSString stringWithFormat:
                                 @"<html><body style='background: white; font-family: Arial, Helvetica; font-size: 125%%;\
                                 margin: 1em;' align='center'>An error occurred:<br><strong>%@</strong><br><br>\
                                 <a href='%@'>%@</a>\
                                 </html>",
                                 error.localizedDescription,
                                 gURL, gURL
                                 ];
        
        NSLog(@"web: error in ", [gWebView.request description]);                                 
        [gWebView loadHTMLString:errorString baseURL:nil];
    }
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *myURL = [[request URL] absoluteString];
    
	NSLog(@"big5: handle url %@ %d", myURL, navigationType);
	// NSLog([self.lastKnownLocation description]);
	    
    // XXX deprecated!
    if([myURL hasPrefix:@"safari:"]) {
        // ([parts count]>1) && [(NSString *)[parts objectAtIndex:0] isEqualToString:@"safari"]) {
        // SWITCH TO SAFARI
        NSLog(@"safari: called");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NSString *)[myURL substringFromIndex:7]]];
        return NO;            
    }
    
    if([myURL hasPrefix:@"device:"]) {
        
        // Prepare parameters
        NSString *command = @"";
		NSString *param =  @"";
        NSArray *parts = [myURL componentsSeparatedByString:@":"];
                
        if([parts count] > 1) {
            command = (NSString *)[parts objectAtIndex:1];
        }
        
        if([parts count] > 2) {
            NSRange range; 
            range.location = 2;
            range.length = [parts count] - 2;
            param = [[NSString alloc] initWithString:[[parts subarrayWithRange:range] componentsJoinedByString:@":"]];    
        }
                
        NSLog(@"big5: command '%@', param '%@'", command, param);
        
        // MARK: INIT
        if([command isEqualToString:@"init"]) {
            NSLog(@"big5: init");
            [self setDeviceDefaults]; 
            callJavascript(gWebView, @"__device_init()");
        }

        // MARK: EXIT
        else if([command isEqualToString:@"exit"]) {
            NSLog(@"big5: exit");
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        // MARK: SETTER
        else if([command isEqualToString:@"set"] && ([parts count]==4)){
            NSString *name = (NSString *)[parts objectAtIndex:2];
            NSString *value = (NSString *)[parts objectAtIndex:3];
            NSLog(@"setter: %@ %@", name, value);
            
            // SET AUTO ROTATION
            if([name isEqualToString:@"rotation"]) {
                gSupportAutoRotation = ([value isEqualToString:@"true"] || [value isEqualToString:@"1"]);
            }

            // SET SCALE PAGE TO FIT
            else if([name isEqualToString:@"scale"]) {
                gWebView.scalesPageToFit = ([value isEqualToString:@"true"] || [value isEqualToString:@"1"]);
            }
            
            // SET VISIBILITY OF NAVIGATION BAR
            else if([name isEqualToString:@"navigationbar"]) {
                [self.navigationController setNavigationBarHidden:!([value isEqualToString:@"true"] || [value isEqualToString:@"1"]) animated:YES];
            }

            // SET VISIBILITY OF STATUS BAR
            else if([name isEqualToString:@"statusbar"]) {
                [[UIApplication sharedApplication] setStatusBarHidden:!([value isEqualToString:@"true"] || [value isEqualToString:@"1"]) animated:YES];
            }
            
            // SET VISIBILITY OF ALL
            else if([name isEqualToString:@"fullscreen"]) {
                if(([value isEqualToString:@"true"] || [value isEqualToString:@"1"])) {
                    [self.navigationController setNavigationBarHidden:YES animated:YES];                
                    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];                
                }
            }
            
            // SET PHOTO FILE NAME
            /* else if([name isEqualToString:@"photoFileName"]) {
                if([value isEqualToString:@""])
                    gPhotoSaveDestination = nil;
                else
                    gPhotoSaveDestination = [[NSString alloc] initWithString:value];                
            } */
            
        }

        // MARK: ACCELEROMETER
        else if(BOOL_PREF(@"setting_acceleration") && [command isEqualToString:@"acceleration_start"]){
            NSLog(@"accel: start!");
            // 1.0/40.0 
            
            [[UIAccelerometer sharedAccelerometer] setUpdateInterval: [param floatValue]];
            [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        }
        else if(BOOL_PREF(@"setting_acceleration") && [command isEqualToString:@"acceleration_stop"]){
            NSLog(@"accel: stop!");
            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        }

        // MARK: LOCATION
#ifndef APP_NO_LOCATION
        else if(BOOL_PREF(@"setting_location") && [command isEqualToString:@"location"]){
            NSLog(@"loc: request!");
            // Init location manager
            // -------------------------------------------------
            
            if(gLocationManager == NULL) {
                gLocationManager = [[CLLocationManager alloc] init];
                
                gLocationManager.desiredAccuracy = kCLLocationAccuracyBest;              
                gLocationManager.delegate = self;
            }
            
            if(gLocationManager.locationServicesEnabled) {
                [gLocationManager startUpdatingLocation];
            } else {
                callJavascript(gWebView, @"__device_location_error(999, 'Location service not enabled');");  
            }
        }
#endif
        
        // MARK: VIBRATION
        else if(BOOL_PREF(@"setting_vibration") && [command isEqualToString:@"vibrate"]){
            NSLog(@"vibration: request!");
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }

        // MARK: OPEN BROWSER
        else if([command isEqualToString:@"safari"]) {
            NSLog(@"big5: jumpt to safari with url %@", param);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
        }

        // MARK: LOGGING
        else if([command isEqualToString:@"log"]) {
            NSLog(@"LOG: %@", param);
        }

        // MARK: ALERT
        else if([command isEqualToString:@"alert"]) {
            NSLog(@"ALERT: %@", param);
            alert(param);
        }      

        // MARK: NETWORK
        else if([command isEqualToString:@"network"]) {
            
            NSLog(@"NETWORK: %@", param);
            
            NetworkStatus remoteHostStatus;
            NetworkStatus internetConnectionStatus;
            NetworkStatus localWiFiConnectionStatus;
            
            [[Reachability sharedReachability] setHostName:@"www.apple.com"];
            
            remoteHostStatus            = [[Reachability sharedReachability] remoteHostStatus];
            internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
            localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
            
            NSLog(@"%d, %d, %d", remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus);
            
            callJavascript(gWebView, @"__device_network_status({remote_host:%d, internet_connection: %d, local_wifi_connection: %d})", remoteHostStatus, internetConnectionStatus, localWiFiConnectionStatus);
        }      
        
        // MARK: SOUND
        else if([command isEqualToString:@"sound"]) {

            NSLog(@"SOUND: %@", param);
            NSURL *filePath = [NSURL URLWithString:param relativeToURL:gURL];
            NSLog(@"SOUND URL: %@", [filePath absoluteString]);
            AudioServicesCreateSystemSoundID((CFURLRef)[NSURL URLWithString:[filePath absoluteString]], &soundID);
            AudioServicesPlaySystemSound(soundID);
        }
        
        // MARK: IMAGE
        else if(BOOL_PREF(@"setting_photo")) {
        
            // NSLog(@"photo: allowed");
        
            // PHOTOLIB
            if (   [command isEqualToString:@"photo_from_library"] 
                || [command isEqualToString:@"photo_from_album"] 
                || [command isEqualToString:@"photo_from_library_to_local"] 
                || [command isEqualToString:@"photo_from_album_to_local"]) {

                NSLog(@"photo from library or album");
                
                gPhotoUploadDestination = param;
                gPhotoSaveDestination = nil;

                if(   [command isEqualToString:@"photo_from_library_to_local"] 
                   || [command isEqualToString:@"photo_from_album_to_local"]) {
                    gPhotoSaveDestination = param;
                    gPhotoUploadDestination = nil;
                }
                
                NSLog(@"photo: request library! callback %@", gPhotoUploadDestination);
                UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                // picker.allowsImageEditing = YES;
                [self presentModalViewController:picker animated:YES];
                NSLog(@"photo: lib dialog open now!");                                
            
            }
            
            // MARK: CAMERA
            else if (   [command isEqualToString:@"photo_from_camera"] 
                     || [command isEqualToString:@"photo_from_camera_to_local"]) {                

                gPhotoUploadDestination = param;
                gPhotoSaveDestination = nil;
                
                if([command isEqualToString:@"photo_from_camera_to_local"]) {
                    gPhotoSaveDestination = param;
                    gPhotoUploadDestination = nil;
                }
                                                
                // NSLog(@"photo: request camera! callback %@", gPhotoUploadDestination);
                                    
                if ( (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ) {
                
                    alert(@"Camera not available!");
                    NSLog(@"photo: camera not available!");
    
                    callJavascript(gWebView, @"__device_did_fail_image_upload('Camera not available');");
                
                } else {
                
                    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    picker.allowsImageEditing = YES;
                    [self presentModalViewController:picker animated:YES];
                    NSLog(@"photo: camera dialog open now!");
                
                }
            }                                                          			            
        }
    
        // XXX CONNECTION        
        // XXX SOUND RECORDING  
        // XXX READ APP PREFS

        // Next command can start
        callJavascript(gWebView, @"__device_next_command()");
        
		return NO;
	}
    
    NSLog(@"Timeout %f and cache policy %d",
        request.timeoutInterval,
        request.cachePolicy
        );
    
    // Big Five Additional Header Data
    // NSLog(@"Headers: %@", request.allHTTPHeaderFields);
    [(NSMutableURLRequest *)request addValue:[[UIDevice currentDevice] uniqueIdentifier] forHTTPHeaderField:@"BigFive-Unique-Identifier"];
    [(NSMutableURLRequest *)request addValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"BigFive-Model"];
    [(NSMutableURLRequest *)request addValue:[[UIDevice currentDevice] systemName] forHTTPHeaderField:@"BigFive-System-Name"];
    [(NSMutableURLRequest *)request addValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"BigFive-System-Version"];
    NSLog(@"New Headers: %@", request.allHTTPHeaderFields);
    
    // [request cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	return YES;
}

// MARK: -
// MARK: LOCATION
// MARK: -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    /*
	[lastKnownLocation release];
	lastKnownLocation = newLocation;
	[lastKnownLocation retain];    
    double lat = lastKnownLocation.coordinate.latitude;
    double lon = lastKnownLocation.coordinate.longitude;            
    */
    
    /*
    NSDictionary *callback  = [NSDictionary dictionaryWithObjectsAndKeys:
                               [[[NSString alloc] autorelease] initWithFormat:@"%f", newLocation.coordinate.latitude], @"latitude",
                               [[[NSString alloc] autorelease] initWithFormat:@"%f", newLocation.coordinate.longitude], @"longitude",
                               [[[NSString alloc] autorelease] initWithFormat:@"%f", newLocation.altitude], @"altitude",
                               [[[NSString alloc] autorelease] initWithFormat:@"%f", newLocation.speed], @"speed",
                               [[[NSString alloc] autorelease] initWithFormat:@"%f", newLocation.course], @"direction",
                               nil
                               ];    
     */
    
    callJavascript(gWebView, @"__device_did_update_location('%f', '%f', '%f', '%f');", 
                   newLocation.coordinate.latitude,
                   newLocation.coordinate.longitude,
                   oldLocation.coordinate.latitude,
                   oldLocation.coordinate.longitude);      

    // Not needed any more
    [gLocationManager stopUpdatingLocation];
    
    NSLog(@"loc: updating location to %@", [newLocation description]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    callJavascript(gWebView, @"__device_location_error(%d, '%@');", error.code, error);  
}

// MARK: -
// MARK: ACCELEROMETER
// MARK: -

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {    
    callJavascript(gWebView, @"__device_did_accelerate(%f,%f,%f);", acceleration.x, acceleration.y, acceleration.z);
}

// MARK: -
// MARK: IMAGE PICKER
// MARK: -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"photo: picked image");
    
    // Remove the picker interface and release the picker object.   
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
    
    image = scaleAndRotateImage(image);
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);	
	//NSData * imageData = UIImagePNGRepresentation(image);	

    // Save image locally
    
	// NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = nil;
    if(gPhotoSaveDestination!=nil) {
        filePath = [NSString stringWithFormat:@"%@/%@",documentPath(),gPhotoSaveDestination];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@.jpeg",NSTemporaryDirectory(),@"preview"];
        /* while([fileManager fileExistsAtPath:filePath]) {
         filePath = [NSString stringWithFormat:@"%@/%@.jpeg",[[NSBundle mainBundle] bundlePath],[self randomNumber]];
         } */        
    }
    
    NSLog(@"photo: local file path %@ (photo save path %@)", filePath, gPhotoSaveDestination);    
	[imageData writeToFile:filePath atomically:YES];
	
    callJavascript(gWebView, @"__device_did_get_image('%@')", [[NSURL fileURLWithPath:filePath] absoluteString]);
    
    if(gPhotoUploadDestination!=nil) {    
        
        NSLog(@"photo: upload to %@", [gPhotoUploadDestination description]);
        // NSString *urlString = [@"http://macbook01.local:8080/upload?" stringByAppendingString:@"uid="];
        // urlString = [urlString stringByAppendingString:uniqueId];
                
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:gPhotoUploadDestination]];
        [request setHTTPMethod:@"POST"];

        //Add the header info
        NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        /* //add key values from the NSDictionary object
        NSEnumerator *keys = [postKeys keyEnumerator];
        int i;
        for (i = 0; i < [postKeys count]; i++) {
            NSString *tempKey = [keys nextObject];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",tempKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"%@",[postKeys objectForKey:tempKey]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        } */
        
        //add data field and file data
        [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[NSData dataWithData:imageData]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postBody];
        
        NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(conn) {
            NSLog(@"photo: connection sucess");	
            //receivedData = [[NSMutableData data] retain];
        } else {
            NSLog(@"photo: upload failed!");
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"photo: cancel dialog");
    callJavascript(gWebView, @"__device_photo_dialog_cancel();");
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
}

// MARK: -
// MARK: UPLOAD DATA
// MARK: -

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"photo: upload finished!");

    // Callback
    callJavascript(gWebView, @"__device_did_finish_image_upload();");

    /* #if TARGET_IPHONE_SIMULATOR
    alert(@"Did finish loading image!");
    #endif */
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    // [receivedData appendData:data];
    NSLog(@"photo: progress");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"photo: upload failed! %@", [error description]);

    callJavascript(gWebView, @"__device_did_fail_image_upload('%s');", [[error description] UTF8String]);

    /* #if TARGET_IPHONE_SIMULATOR
    alert(@"Error while uploading image!");
    #endif */
}

@end

