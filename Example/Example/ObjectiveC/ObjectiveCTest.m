//
//  ObjectiveCTest.m
//  Example
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (instancetype)init {
    self.apiManager = [[DefaultAPIManager alloc] initWithGatewayType: GatewayTypeEuropean username: @""];
    return self;
}

- (void) someTestMethod {
    // Test frameworks availability
    id vc = [[ViewControllerFactory shared] testMainViewControllerWithDidTapShowDetails:^{
    }];

    NSMutableArray *typeDescriptions =
    [NSMutableArray arrayWithArray:@[@(TypeDescriptionObjcAuth)]];
    RequestObject * requestObject = [[RequestObject alloc] initWithTypeDescriptions:typeDescriptions];
    //NSMutableArray *requestObjects = [[NSMutableArray alloc] init];
    //[requestObjects addObject: requestObject];

    [self.apiManager makeGeneralRequestWithJwt:@"" request:requestObject success:^(JWTResponseObject * response, NSString * jwt) {
        NSLog(@"%li", (long)response.errorCode);
        NSLog(@"%li", (long)response.responseErrorCode);
    } failure:^(NSError * error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}

@end
