//
//  SPICryptoTest.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-11-25.
//  Copyright © 2017 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SPICrypto.h"
#import "NSString+Crypto.h"

#import "RNEncryptor.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@interface SPICryptoTest : XCTestCase
@end

@implementation SPICryptoTest

- (void)testEncrypt {
    NSString *encKey = @"11A1162B984FEF626ECC27C659A8B0EEAD5248CA867A6A87BEA72F8A8706109D";
    NSString *msg = @"asdfghjklzxcvbnm";
    NSString *expectEncryptedMsg = @"E488657A702455F0D1D2B85494B240C006EF50E9B19085098CAA5707E999582D";

    NSString *encryptedMsg = [SPICrypto aesEncryptMessage:msg key:[encKey dataFromHexEncoding]];
    NSString *decryptedMsg = [SPICrypto aesDecryptEncMessage:encryptedMsg key:[encKey dataFromHexEncoding]];

    XCTAssertEqualObjects(encryptedMsg, expectEncryptedMsg);
    XCTAssertEqualObjects(decryptedMsg, msg);
}

- (void)testHmac {
    NSString *hmacKey = @"BD9DA176404A65C7D379E77E385800556655207C411E0B88E45B393C7DC88999";
    NSString *enc = @"88A9BAACA293124A9737F946DF296E661BC081A8F46AC7E24FD4156757572C874662181ED2706CE8271B5BDA4512AC0D27389BCEAA269583F51C22B4488CAB6048A0B41DA0F33A1911F90BF0D5459C90";
    NSString *expectedHmacSig = @"B0BCB3D94116BB7321EFA97AB9437E42D6866D83F9F91056843A48B826BDFCF6";
    NSString *hmacSig = [SPICrypto hmacSignatureMessage:enc key:[hmacKey dataFromHexEncoding]];

    XCTAssertEqualObjects(hmacSig, expectedHmacSig);
}

@end
