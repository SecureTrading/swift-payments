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

    [self.apiManager makeGeneralRequestWithJwt:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqd3QtcGdzbW9iaWxlc2RrIiwiaWF0IjoxNTg5NTI0Nzc2Ljk5MDA0NTEsInBheWxvYWQiOnsiZXhwaXJ5ZGF0ZSI6IjEyXC8yMDIyIiwiYmFzZWFtb3VudCI6MTA1MCwicGFuIjoiNDExMTExMTExMTExMTExMSIsInNlY3VyaXR5Y29kZSI6IjEyMyIsImFjY291bnR0eXBlZGVzY3JpcHRpb24iOiJFQ09NIiwic2l0ZXJlZmVyZW5jZSI6InRlc3RfcGdzbW9iaWxlc2RrNzk0NTgiLCJjdXJyZW5jeWlzbzNhIjoiR0JQIn19.DvrtwnTw7FcIxNN8-BkrKyib0DquFQNKVrKL_kj6nXA" request:requestObject success:^(JWTResponseObject * response, NSString * jwt) {
        NSLog(@"%li", (long)response.errorCode);
        NSLog(@"%li", (long)response.responseErrorCode);
    } failure:^(NSError * error) {
        NSLog(@"%@", error.localizedDescription);
    }];

}

@end
