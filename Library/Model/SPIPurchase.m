//
//  SPIPurchase.m
//  SPIClient-iOS
//
//  Created by Yoo-Jin Lee on 2017-11-29.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import "SPIPurchase.h"
#import "SPIMessage.h"
#import "SPIClient.h"
#import "SPIRequestIdHelper.h"
#import "NSDateFormatter+Util.h"

@implementation SPIPurchaseRequest : NSObject

- (instancetype)initWithAmountCents:(NSInteger)amountCents
                           posRefId:(NSString *)posRefId{
    self = [super init];
    
    if (self) {
        _posRefId  = posRefId;
        _purchaseAmount = amountCents;
        
        // Library Backwards Compatibility
        _purchaseId = posRefId;
        _amountCents = amountCents;
    }
    
    return self;
    
}
- (SPIMessage *)toMessage {
    NSDictionary *originalData = @{@"purchase_amount":@(self.purchaseAmount),
                                  @"tip_amount":@(self.tipAmount),
                                  @"cash_amount":@(self.cashoutAmount),
                                  @"prompt_for_cashout":@(self.promptForCashout)
                                  };
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:originalData];
    [_config addReceiptConfig:data];
    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"prchs"]
                                       eventName:SPIPurchaseRequestKey
                                            data:data
                                 needsEncryption:true];
    return message;
    
}
-(NSString *)amountSummary{
    return [NSString stringWithFormat:@"Purchase: %.2f; Tip: %.2f; Cashout: %.2f;",((float)_purchaseAmount/100.0),((float)_tipAmount/100.0),((float)_cashoutAmount/100.0)];
}

@end

@implementation SPIPurchaseResponse : NSObject
- (instancetype)initWithMessage:(SPIMessage *)message {
    self = [super init];
    
    if (self) {
        _message       = message;
        _requestid     = message.mid;
        _schemeName    = [message getDataStringValue:@"scheme_name"];
        _posRefId      = [message getDataStringValue:@"pos_ref_id"];
        _isSuccess     = message.successState == SPIMessageSuccessStateSuccess;
        
    }
    
    return self;
    
}

- (NSString *)getRRN {
    return [self.message getDataStringValue:@"rrn"];
}

- (NSString *)getCustomerReceipt {
    return [self.message getDataStringValue:@"customer_receipt"];
}

- (NSString *)getResponseText {
    return [self.message getDataStringValue:@"host_response_text"];
}

- (NSString *)getResponseValueWithAttribute:(NSString *)attribute {
    return [self.message getDataStringValue:attribute];
}

- (NSString *)hostResponseText {
    return [self.message getDataStringValue:@"host_response_text"];
}
- (NSInteger)getPurchaseAmount{
    return [self.message getDataIntegerValue:@"purchase_amount"];
}
- (NSInteger)getTipAmount{
    return [self.message getDataIntegerValue:@"tip_amount"];
}
- (NSInteger)getCashoutAmount{
    return [self.message getDataIntegerValue:@"cash_amount"];
}

- (NSInteger)getBankNonCashAmount{
    return [self.message getDataIntegerValue:@"bank_noncash_amount"];
}

- (NSInteger)getBankCashAmount{
    return [self.message getDataIntegerValue:@"bank_cash_amount"];
}

@end

@implementation SPICancelTransactionRequest : NSObject
- (SPIMessage *)toMessage {
    return [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"ctx"]
                                       eventName:SPICancelTransactionRequestKey
                                            data:nil
                                 needsEncryption:true];
    
}

@end

@implementation SPIGetLastTransactionRequest : NSObject
- (SPIMessage *)toMessage {
    return [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"glt"]
                                       eventName:SPIGetLastTransactionRequestKey
                                            data:nil
                                 needsEncryption:true];
    
}

@end

@implementation SPIGetLastTransactionResponse : NSObject

- (instancetype)initWithMessage:(SPIMessage *)message {
    self = [super init];
    
    if (self) {
        _message = message;
    }
    
    return self;
    
}

- (BOOL)wasRetrievedSuccessfully {
    NSString *rrn = [self getRRN];
    return rrn != nil && ![rrn isEqualToString:@""];
}

- (BOOL)wasOperationInProgressError {
    return [self.message.error isEqualToString:@"OPERATION_IN_PROGRESS"];
}

- (BOOL)wasSuccessfulTx {
    return self.message.successState == SPIMessageSuccessStateSuccess;
}

- (NSString *)getTxType {
    return [self.message getDataStringValue:@"transaction_type"];
}

- (NSString *)getPosRefId{
    return [self.message getDataStringValue:@"pos_ref_id"];
}

- (NSString *)getSchemeName {
    return [self.message getDataStringValue:@"scheme_name"];
}

- (NSInteger)getAmount {
    return [self.message getDataIntegerValue:@"amount_purchase"];
}

- (NSInteger)getTransactionAmount {
    return [self.message getDataIntegerValue:@"amount_transaction_type"];
}

- (NSString *)getRRN {
    return [self.message getDataStringValue:@"rrn"];
}

- (NSString *)getBankDateTimeString {
    // bank_date":"07092017","bank_time":"152137"
    NSString *date = [self.message getDataStringValue:@"bank_date"];
    NSString *time = [self.message getDataStringValue:@"bank_time"];
    
    if (!date || !time) return nil;
    
    // ddMMyyyyHHmmss
    return [NSString stringWithFormat:@"%@%@", date, time];
}

- (NSDate *)bankDate {
    NSString *bankDateTimeString = self.getBankDateTimeString;
    
    if (!bankDateTimeString) return nil;
    
    return [[NSDateFormatter dateNoTimeZoneFormatter] dateFromString:bankDateTimeString];
}

-(BOOL) isStillInProgress:(NSString *) posRefId{
    return ([self wasOperationInProgressError] && [[self getPosRefId] isEqualToString:posRefId]);
}

- (SPIMessageSuccessState)successState {
    return self.message.successState;
}

- (NSString *)getResponseValue:(NSString *)attribute {
    if (!attribute) return @"";
    
    return (NSString *)self.message.data[attribute] ?: @"";
}

- (void)copyMerchantReceiptToCustomerReceipt {
    NSString *cr = [self.message getDataStringValue:@"customer_receipt"];
    NSString *mr = [self.message getDataStringValue:@"merchant_receipt"];
    
    if (cr.length != 0 && mr.length != 0) {
        NSMutableDictionary *data = self.message.data.mutableCopy;
        data[@"customer_receipt"] = mr;
        self.message.data         = data.copy;
    }
}

@end

@implementation SPIRefundRequest : NSObject

- (instancetype)initWithPosRefId:(NSString *)posRefId amountCents:(NSInteger)amountCents {
    
    self = [super init];
    
    if (self) {
        _refundId    = [SPIRequestIdHelper idForString:@"refund"];
        _posRefId = posRefId;
        _amountCents = amountCents;
    }
    
    return self;
}

- (SPIMessage *)toMessage {
    return [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"refund"]
                                       eventName:SPIRefundRequestKey
                                            data:@{@"refund_amount":@(self.amountCents),
                                                   @"pos_ref_id":self.posRefId
                                                   }
                                 needsEncryption:true];
}

@end

@implementation SPIRefundResponse : NSObject

- (instancetype)initWithMessage:(SPIMessage *)message {
    
    self = [super init];
    
    if (self) {
        _message       = message;
        _requestId     = message.mid;
        _schemeName    = [message getDataStringValue:@"scheme_name"];
        _isSuccess     = message.isSuccess;
    }
    
    return self;
    
}

- (NSString *)getRRN {
    return [self.message getDataStringValue:@"rrn"];
}

- (NSString *)getCustomerReceipt {
    return [self.message getDataStringValue:@"customer_receipt"];
}

- (NSString *)getMerchantReceipt {
    return [self.message getDataStringValue:@"merchant_receipt"];
}

- (NSString *)getResponseText {
    return [self.message getDataStringValue:@"host_response_text"];
}

- (NSString *)getResponseValue:(NSString *)attribute {
    if (!attribute) return @"";
    
    return (NSString *)self.message.data[attribute] ?: @"";
}

@end

@implementation SPISignatureRequired : NSObject

- (instancetype)initWithMessage:(SPIMessage *)message {
    
    self = [super init];
    
    if (self) {
        _requestId = message.mid;
        _message   = message;
    }
    
    return self;
    
}

- (NSString *)getMerchantReceipt {
    return [self.message getDataStringValue:@"merchant_receipt"];
}

@end

@implementation SPISignatureDecline : NSObject

- (instancetype)initWithSignatureRequiredRequestId:(NSString *)signatureRequiredRequestId {
    
    self = [super init];
    
    if (self) {
        _signatureRequiredRequestId = [signatureRequiredRequestId copy];
    }
    
    return self;
}

- (SPIMessage *)toMessage {
    return [[SPIMessage alloc] initWithMessageId:self.signatureRequiredRequestId
                                       eventName:SPISignatureDeclinedKey
                                            data:nil
                                 needsEncryption:true];
    
}

@end

@implementation SPISignatureAccept : NSObject
- (instancetype)initWithSignatureRequiredRequestId:(NSString *)signatureRequiredRequestId {
    
    self = [super init];
    
    if (self) {
        _signatureRequiredRequestId = [signatureRequiredRequestId copy];
    }
    
    return self;
}

- (SPIMessage *)toMessage {
    return [[SPIMessage alloc] initWithMessageId:self.signatureRequiredRequestId
                                       eventName:SPISignatureAcceptedKey
                                            data:nil
                                 needsEncryption:true];
    
}

@end
@implementation SPIMotoPurchaseRequest:NSObject
- (id)init:(NSInteger)amountCents posRefId:(NSString *)posRefId{
    _config = [[SPIConfig alloc] init];
    _purchaseAmount = amountCents;
    _posRefId = posRefId;
    return  self;
}
- (SPIMessage *)toMessage{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:_posRefId forKey:@"pos_ref_id"];
    [data setValue:[NSNumber numberWithInteger:_purchaseAmount] forKey:@"purchase_amount"];
    [_config addReceiptConfig:data];
    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"moto"] eventName:SPIMotoPurchaseRequestKey data:data needsEncryption:true];
    return message;
}
@end
@implementation SPIMotoPurchaseResponse:NSObject
- (instancetype)initWithMessage:(SPIMessage *)message{
    _purchaseResponse = [[SPIPurchaseResponse alloc] initWithMessage:message];
    _posRefId = _purchaseResponse.posRefId;
    return self;
}
@end
@interface SPIPhoneForAuthRequired(){
    NSString *_phoneNumber;
    NSString *_merchantId;
}
@end
@implementation SPIPhoneForAuthRequired:NSObject

- (instancetype)initWithMessage:(SPIMessage *)message{
    _requestId = message.mid;
    _posRefId = [message getDataStringValue:@"pos_ref_id"];
    _phoneNumber = [message getDataStringValue:@"auth_centre_phone_number"];
    _merchantId = [message getDataStringValue:@"merchant_id"];
    return self;
}
- (id)init:(NSString *)posRefId requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber merchantId:(NSString *)merchantId{
    _requestId = requestId;
    _posRefId = posRefId;
    _phoneNumber = phoneNumber;
    _merchantId = merchantId;
    return self;
}
-(NSString *)getPhoneNumber{
    return _phoneNumber;
}
-(NSString *)getMerchantId{
    return _merchantId;
}

@end
@implementation SPIAuthCodeAdvice:NSObject
- (id)init:(NSString *)posRefId authCode:(NSString *)authCode{
    _posRefId = posRefId;
    _authCode = authCode;
    return self;
}
- (SPIMessage *)toMessage{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:_posRefId forKey:@"pos_ref_id"];
    [data setValue:_authCode forKey:@"auth_code"];

    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:[SPIRequestIdHelper idForString:@"authad"] eventName:SPIAuthCodeAdviceKey data:data needsEncryption:true];
    return message;
}
@end
