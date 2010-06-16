// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import "EditViewController.h"

@implementation EditViewController

@synthesize fieldTitle;
@synthesize fieldUrl;
@synthesize data;
@synthesize pathToUserCopyOfPlist;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        // fieldTitle.adjustsFontSizeToFitWidth = YES;
        // fieldTitle.minimumFontSize = 32.0;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)editRow:(NSInteger)newRow {
    row = newRow;
    NSLog(@"Selected %d", row);        
    NSDictionary *obj = [data objectAtIndex:row];
    NSLog(@"Object %@", obj);    
    NSString *title = [obj objectForKey:@"title"];
    NSString *url = [obj objectForKey:@"url"];    
    NSLog(@"Title %@", title);    
    fieldTitle.text = title;
    fieldUrl.text = url;
    self.title = [NSString stringWithFormat:@"Editing %@", title];
}

- (void)viewWillDisappear:(BOOL)animated {
    // hides the keyboard
    NSLog(@"disappear");
    
    NSMutableDictionary *obj = [data objectAtIndex:row];
    [obj setObject:fieldTitle.text forKey:@"title"];
    [obj setObject:fieldUrl.text forKey:@"url"];
        
    [fieldTitle resignFirstResponder];
    [fieldUrl resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark <UITextFieldDelegate> Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
}

@end
