//
//  SPIKeyRollingTests.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-11-27.
//  Copyright © 2017 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIKeyRollingHelper.h"
#import "SPIMessage.h"
#import "SPISecrets.h"
#import "NSString+Crypto.h"

@interface SPIKeyRollingTests : XCTestCase
@end

@implementation SPIKeyRollingTests

- (void)testKeyRolling {
    SPIMessage *krRequest = [[SPIMessage alloc] initWithMessageId:@"x"
                                                      eventName:SPIKeyRollRequestKey
                                                           data:nil needsEncryption:false];

    SPISecrets *oldSecrets = [[SPISecrets alloc] initWithEncKeyData:@"11A1162B984FEF626ECC27C659A8B0EEAD5248CA867A6A87BEA72F8A8706109D".dataFromHexEncoding
                                                      hmacKey:@"40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58".dataFromHexEncoding];

    SPIKeyRollingResult *krResult = [SPIKeyRollingHelper performKeyRollingWithMessage:krRequest currentSecrets:oldSecrets];
    XCTAssertEqualObjects(@"0307C53DD0F119A1BC4CE61AA395882FB63BF8FCD0E0D27BBEB0D56AA9B24162".dataFromHexEncoding, krResult.secrets.encKeyData);
    XCTAssertEqualObjects(@"E4C3908437C14AC442C925FC8ED536C69FF67080D15FE007D69F8580D73FDF9D".dataFromHexEncoding, krResult.secrets.hmacKeyData);

    XCTAssertEqualObjects(@"x",                                                                krResult.keyRollingConfirmation.mid);
    XCTAssertEqualObjects(SPIKeyRollResponseKey,                                                krResult.keyRollingConfirmation.eventName);
}

@end
