//
//  SPIModelTests.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-11-25.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIMessage.h"
#import "SPISecrets.h"
#import "SPICrypto.h"

@interface SPIMessageTests : XCTestCase
@end

@implementation SPIMessageTests

- (void)testIncomingMessageUnencrypted {

    NSString  *msgJsonStr = @"{\"message\": {\"event\": \"event_x\",\"id\": \"62\",\"data\": {\"param1\": \"value1\"}}}";
    SPIMessage *m          = [SPIMessage fromJson:msgJsonStr secrets:nil];

    XCTAssertEqualObjects(@"event_x", m.eventName);
    XCTAssertEqualObjects(@"value1", [m getDataStringValue:@"param1"]);
}

- (void)testIncomingMessageEncrypted {
    NSString *msgJsonStr = @"{\"enc\": \"819A6FF34A7656DBE5274AC44A28A48DD6D723FCEF12570E4488410B83A1504084D79BA9DF05C3CE58B330C6626EA5E9EB6BAAB3BFE95345A8E9834F183A1AB2F6158E8CDC217B4970E6331B4BE0FCAA\",\"hmac\": \"21FB2315E2FB5A22857F21E48D3EEC0969AD24C0E8A99C56A37B66B9E503E1EF\"}";

    SPISecrets *secrets = [[SPISecrets alloc] initWithEncKey:@"11A1162B984FEF626ECC27C659A8B0EEAD5248CA867A6A87BEA72F8A8706109D"                                                  hmacKey:@"40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58"];

    SPIMessage *m = [SPIMessage fromJson:msgJsonStr secrets:secrets];

    XCTAssertEqualObjects(@"pong",                    m.eventName);
    XCTAssertEqualObjects(@"2017-11-16T21:51:50.499", m.dateTimeStamp);
}

- (void)testIncomingMessageEncrypted_BadSig {
    NSString *msgJsonStr = @"{\"enc\": \"819A6FF34A7656DBE5274AC44A28A48DD6D723FCEF12570E4488410B83A1504084D79BA9DF05C3CE58B330C6626EA5E9EB6BAAB3BFE95345A8E9834F183A1AB2F6158E8CDC217B4970E6331B4BE0FCAA\",\"hmac\": \"21FB2315E2FB5A22857F21E48D3EEC0969AD24C0E8A99C56A37B66B9E503E1EA\"}";

    SPISecrets *secrets = [[SPISecrets alloc] initWithEncKey:@"11A1162B984FEF626ECC27C659A8B0EEAD5248CA867A6A87BEA72F8A8706109D"                                                  hmacKey:@"40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58"];

    SPIMessage *m = [SPIMessage fromJson:msgJsonStr secrets:secrets];
    XCTAssertEqualObjects(SPIInvalidHmacSignature, m.eventName);
}

- (void)testOutgoingMessageEncrypted {
    NSString     *posId   = @"BAR1";
    NSDictionary *data    = @{@"param1":@"value1"};
    SPIMessage    *message = [[SPIMessage alloc] initWithMessageId:@"2" eventName:@"ping" data:data needsEncryption:true];

    SPISecrets *secrets = [[SPISecrets alloc] initWithEncKey:@"11A1162B984FEF626ECC27C659A8B0EEAD5248CA867A6A87BEA72F8A8706109D"                                                  hmacKey:@"40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58"];

    SPIMessageStamp *stamp = [[SPIMessageStamp alloc] initWithPosId:posId
                                                          secrets:secrets
                                                  serverTimeDelta:0];

    NSString *msgJson = [message toJson:stamp];

    NSLog(@"%@", msgJson);

     ////// FromJson
    SPIMessage *revertedM = [SPIMessage fromJson:msgJson secrets:secrets];

    XCTAssertEqualObjects(@"ping",   revertedM.eventName);
    XCTAssertEqualObjects(@"value1", revertedM.data[@"param1"]);

}

@end
