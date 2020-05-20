//
//  ObjectiveCTest.h
//  Example
//

#import <Foundation/Foundation.h>

@import SecureTradingCore;
@import SecureTradingUI;
@protocol APIClient;

@interface ObjectiveCTest : NSObject

@property (strong, nonatomic) id someTestProperty;

@property (nonatomic, strong, readwrite) DefaultAPIManager <APIManagerObjc> *apiManager;

- (void) someTestMethod;

@end

