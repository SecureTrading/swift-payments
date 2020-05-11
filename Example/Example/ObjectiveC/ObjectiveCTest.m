//
//  ObjectiveCTest.m
//  Example
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (void) someTestMethod {
    // Test frameworks availability
    DefaultAPIClient <APIClient> * apiClient = [DefaultAPIClient new];
    id vc = [[ViewControllerFactory shared] testMainViewController];
}

@end
