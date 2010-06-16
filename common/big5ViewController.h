// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import <AudioToolbox/AudioServices.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>

@interface big5ViewController : UIViewController <
    UITextFieldDelegate, 
    UIWebViewDelegate, 
    CLLocationManagerDelegate, 
    UIAccelerometerDelegate,
    UIPickerViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
    >
{
	UIWebView           *gWebView;
    UIActivityIndicatorView *gImageView;
	// UITextField      *urlField;
    NSURL               *gURL;
    NSURL               *gCurrentURL;
    BOOL                gNotFoundState;
    BOOL                gSupportAutoRotation;
    
    // Location
	CLLocationManager   *gLocationManager;  
	CLLocation          *gLastLocation;
    
    // Photo
    NSString            *gPhotoUploadDestination;
    NSString            *gPhotoSaveDestination;
    
    SystemSoundID       soundID;
}

@property (nonatomic, retain) UIWebView	*gWebView;
@property (nonatomic, retain) NSURL *gURL;
@property (nonatomic, retain) NSURL *gCurrentURL;
@property (nonatomic, retain) UIActivityIndicatorView *gImageView;
@property (nonatomic, retain) CLLocation *gLastLocation;
@property (nonatomic, retain) NSString *gPhotoUploadDestination;
@property (nonatomic, retain) NSString *gPhotoSaveDestination;
@property BOOL gNotFoundState;
@property BOOL gSupportAutoRotation;

@end
