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
    // Test Core framework availability
    DefaultAPIClient <APIClient> * apiClient = [DefaultAPIClient new];

    // Test UI framework availability
    CardView * view = [CardView new];
    CardViewModel * viewModel = [CardViewModel new];
    //todo - how to make the swift generics available to objc
    //CardViewController * cardVC = [[CardViewController alloc] initWithView: view viewModel: viewModel];

}

@end
