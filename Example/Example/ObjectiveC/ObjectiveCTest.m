//
//  ObjectiveCTest.m
//  Example
//

#import "ObjectiveCTest.h"

@implementation ObjectiveCTest

- (instancetype)init {
    self.apiManager = [[DefaultAPIManager alloc] initWithGatewayType: GatewayTypeEu username: @""];
    return self;
}

- (void) someTestMethod {
    // Test frameworks availability
    id vc = [[ViewControllerFactory shared] testMainViewControllerWithDidTapShowDetails:^{
    }];

    NSMutableArray *typeDescriptions =
    [NSMutableArray arrayWithArray:@[@(TypeDescriptionObjcAuth)]];
    RequestObject * requestObject = [[RequestObject alloc] initWithTypeDescriptions:typeDescriptions requestId: NULL cardNumber:NULL securityCode:NULL expiryDate:NULL termUrl: NULL threeDResponse: NULL cacheToken: NULL];
    //NSMutableArray *requestObjects = [[NSMutableArray alloc] init];
    //[requestObjects addObject: requestObject];

    [self.apiManager makeGeneralRequestWithJwt:@"" request:requestObject success:^(JWTResponseObject * response, NSString * jwt, NSString * newJWT) {
        NSLog(@"%li", (long)response.errorCode);
        NSLog(@"%li", (long)response.responseErrorCode);
    } failure:^(NSError * error) {
        switch (error.code) {
            case ResponseErrorDetailInvalidExpiryDate: NSLog(@"invalid Expiry Date: %@", error.localizedDescription);
            case ResponseErrorDetailInvalidJWT : NSLog(@"invalid JWT: %@", error.localizedDescription);
            case ResponseErrorDetailInvalidPAN : NSLog(@"invalid PAN: %@", error.localizedDescription);
            case ResponseErrorDetailInvalidTermURL : NSLog(@"invalid Term URL - 3dSecure: %@", error.localizedDescription);
        }
        NSLog(@"%@", error.localizedDescription);
    }];

}

/// Test setting custom translation
-(void) testTranslations {
    [[TrustPayments instance] configureWithLocale: [NSLocale localeWithLocaleIdentifier: @"it_IT"]
                               customTranslations:@{
                                   [NSLocale localeWithLocaleIdentifier: @"it_IT"]: @{
                                           @(LocalizableKeysObjc_payButton_title): @"Paga ora!",
                                           @(LocalizableKeysObjc_navigation_back): @"< Torna indietro"
                                   },
                                   [NSLocale localeWithLocaleIdentifier: @"en_GB"]: @{
                                           @(LocalizableKeysObjc_payButton_title): @"Giv me da mona",
                                           @(LocalizableKeysObjc_navigation_back): @"<Back>"
                                   },
                                   [NSLocale localeWithLocaleIdentifier: @"fr_FR"]: @{
                                           @(LocalizableKeysObjc_payButton_title): @"Payez",
                                           @(LocalizableKeysObjc_navigation_back): @"< Retourner"
                                   },
                               }];
}

@end
