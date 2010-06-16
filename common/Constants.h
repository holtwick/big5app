// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

// Settings

#define kURL                    @"setting_url"
#define kLocation               @"setting_location"
#define kPhoto                  @"setting_photo"
#define kVibration              @"setting_vibration"
#define kIdleDisabled           @"setting_idle_disabled"

// Shortcuts

#import "Settings.h"

#ifndef APP_STATUSBAR_HIDDEN
    #define APP_STATUSBAR_HIDDEN    NO
#endif

#define STR_PREF(name)              [[NSUserDefaults standardUserDefaults] stringForKey:name]
#define BOOL_PREF(name)             1

/*
#ifdef APP_OFFLINE
    #define BOOL_PREF(name)         1
#else
    #define BOOL_PREF(name)         ([[[NSUserDefaults standardUserDefaults] stringForKey:name] isEqualToString:@"YES"])
#endif
*/

/*

APP_IDLE_DISABLED
  Disable auto-lock as defined in System Preferences
 
APP_LOCATION
 
 
*/