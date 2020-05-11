//
//  ObjectiveCTest.m
//  Example
//
//  Created by TIWASZEK on 06/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (void) someTestMethod {
    // Test frameworks availability
    DefaultAPIClient <APIClient> * apiClient = [DefaultAPIClient new];
    id vc = [[ViewControllerFactory shared] testMainViewController];
}

@end
