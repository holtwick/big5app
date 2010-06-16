// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

/* 
 * Comment out APP_OFFLINE if you want to start directly with an online page.
 * APP_FOLDER defines the folder in the projects resources that contains the
 * index.html starting page for the offline app. APP_URL is only used if APP_OFFLINE
 * is commented out.
 */

#define APP_OFFLINE             0
#define APP_FOLDER              @"WebApp"
#define APP_URL                 @"http://macintosh.local:8080/WebApp/index.html"

/*
 *
 *
 */

#define APP_ALLOW_ROTATION      1
#define APP_ALLOW_STATUSBAR     1

#define APP_USE_LOCATION        1
#define APP_USE_PHOTO           1
#define APP_USE_ACCELERATION    1
#define APP_USE_VIBRATION       1
