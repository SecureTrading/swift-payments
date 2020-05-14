//
//  ObjectiveCTest.m
//  PodsTest
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (void) someTestMethod {
    // Test frameworks availability
    id vc = [[ViewControllerFactory shared] testMainViewControllerWithDidTapShowDetails:^{
    }];
}

@end
