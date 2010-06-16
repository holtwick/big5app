// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import <UIKit/UIKit.h>

void alert(NSString *);
void callJavascript(UIWebView *webView, NSString *formatString, ...);
id callJSON(UIWebView *webView, NSString *formatString, ...);
NSString *documentPath(void);
UIImage *scaleAndRotateImage(UIImage *image);