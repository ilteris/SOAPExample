//
//  SOAPExampleAppDelegate.m
//  SOAPExample
//
//  Created by freelancer on 6/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SOAPExampleAppDelegate.h"
#import "SOAPExampleViewController.h"

@implementation SOAPExampleAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
