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

    DefaultAPIManager <APIManager> *apiManager = [[DefaultAPIManager alloc] initWithGatewayType: GatewayTypeEuropean];
    NSMutableArray *typeDescriptions =
    [NSMutableArray arrayWithArray:@[@(TypeDescriptionObjcAuth), @(TypeDescriptionObjcThreeDQuery)]];
    RequestObject * requestObject = [[RequestObject alloc] initWithTypeDescriptions:typeDescriptions];
    NSMutableArray *requestObjects = [[NSMutableArray alloc] init];
    [requestObjects addObject: requestObject];

    [apiManager makeGeneralRequestWithAlias:@"" jwt:@"" version:@"" requests: requestObjects];
}

@end
