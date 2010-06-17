//
//  SOAPExampleAppDelegate.h
//  SOAPExample
//
//  Created by freelancer on 6/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOAPExampleViewController;

@interface SOAPExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SOAPExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SOAPExampleViewController *viewController;

@end

