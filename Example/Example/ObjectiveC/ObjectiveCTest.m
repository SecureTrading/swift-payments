//
//  ObjectiveCTest.m
//  Example
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (void) someTestMethod {
    // Test frameworks availability
    id vc = [[ViewControllerFactory shared] testMainViewControllerWithDidTapShowDetails:^{
    }];

    
}

@end
