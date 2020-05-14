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
    [NSMutableArray arrayWithArray:@[@(TypeDescriptionObjcAuth)]];
    RequestObject * requestObject = [[RequestObject alloc] initWithTypeDescriptions:typeDescriptions];
    NSMutableArray *requestObjects = [[NSMutableArray alloc] init];
    [requestObjects addObject: requestObject];

    [apiManager makeGeneralRequestWithAlias:@"jwt-pgsmobilesdk" jwt:@"" version:@"1.00" requests: requestObjects];
}

@end
