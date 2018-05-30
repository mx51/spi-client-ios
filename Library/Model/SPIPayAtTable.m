//
//  SPIPayAtTable.m
//  SPIClient-iOS
//
//  Created by Amir Kamali on 20/5/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import "SPIPayAtTable.h"
#import "NSString+Util.h"
@implementation SPIBillStatusResponse
- (NSArray<SPIPaymentHistoryEntry *> *)getBillPaymentHistory{
    if (_billData == nil || [_billData isEqualToString:@""]){
        return [[NSArray alloc] init];
    }
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:_billData options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", decodedString); // foo
   
    NSError *jsonError = nil;
    NSData  *jsonData  = [NSJSONSerialization dataWithJSONObject:decodedString options:0 error:&jsonError];

    
    if (jsonError) {
        //ERROR
        NSLog(@"jsonError: %@", jsonError);
        return [[NSArray alloc] init];
    }
    NSMutableArray * paymentHistory = [[NSMutableArray alloc] init];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    for (NSDictionary * historyValue in jsonObject.allValues.firstObject){
        SPIPaymentHistoryEntry *historyItem = [[SPIPaymentHistoryEntry alloc] init:historyValue];
        [paymentHistory addObject:historyItem];
    }
    return [paymentHistory copy];
    
    //internal List<PaymentHistoryEntry> getBillPaymentHistory()
    //{
    //    if (string.IsNullOrWhiteSpace(BillData))
    //    {
    //        return new List<PaymentHistoryEntry>();
    //    }
    //
    //    var bdArray = Convert.FromBase64String(BillData);
    //    var bdStr = Encoding.UTF8.GetString(bdArray);
    //    var jsonSerializerSettings = new JsonSerializerSettings() {DateParseHandling = DateParseHandling.None};
    //    return JsonConvert.DeserializeObject<List<PaymentHistoryEntry>>(bdStr, jsonSerializerSettings);
    //}
    //
}
+ (NSString *)toBillData:(NSArray<SPIPaymentHistoryEntry *> *)ph{
    if (ph.count < 1){
        return @"";
    }
    
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ph options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *bphStr = [jsonData base64EncodedStringWithOptions:0];
    return bphStr;
    //   if (ph.Count < 1)
    //    {
    //        return "";
    //    }
    //
    //    var bphStr = JsonConvert.SerializeObject(ph);
    //    return Convert.ToBase64String(Encoding.UTF8.GetBytes(bphStr));
}
- (SPIMessage *)toMessage:(NSString *)messageId{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:[NSNumber numberWithInteger:BillRetrievalResultSuccess] forKey:@"success"];
    if ([NSString isNilOrEmpty:_billId]) {
        [data setObject:_billId forKey:@"bill_id"];
    }
    if ([NSString isNilOrEmpty:_tableId]){
        [data setObject:_tableId forKey:@"table_id"];
    }
    if (_result == BillRetrievalResultSuccess){
        [data setObject:@"bill_total_amount" forKey:[NSNumber numberWithInteger:_totalAmount]];
        [data setObject:@"bill_outstanding_amount" forKey:[NSNumber numberWithInteger:_outstandingAmount]];
        [data setObject:@"bill_payment_history" forKey:[self getBillPaymentHistory]];
    }else{
        [data setObject:@"error_reason" forKey:[NSNumber numberWithInt:_result].stringValue];
        [data setObject:@"error_detail" forKey:[NSNumber numberWithInt:_result].stringValue];
    }
    
    //    var data = new JObject(
    //                           new JProperty("success", Result==BillRetrievalResult.SUCCESS)
    //                           );
    //
    //    if (!string.IsNullOrWhiteSpace(BillId)) data.Add(new JProperty("bill_id", BillId));
    //    if (!string.IsNullOrWhiteSpace(TableId)) data.Add(new JProperty("table_id", TableId));
    //
    //    if (Result == BillRetrievalResult.SUCCESS)
    //    {
    //        data.Add(new JProperty("bill_total_amount", TotalAmount));
    //        data.Add(new JProperty("bill_outstanding_amount", OutstandingAmount));
    //        data.Add(new JProperty("bill_payment_history", JToken.FromObject(getBillPaymentHistory())));
    //    }
    //    else
    //    {
    //        data.Add(new JProperty("error_reason", Result.ToString()));
    //        data.Add(new JProperty("error_detail", Result.ToString()));
    //    }
    //    return new Message(messageId, Events.PayAtTableBillDetails, data, true);
    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:messageId eventName:SPIPayAtTableBillDetailsKey data:data needsEncryption:true];
    return  message;
}
@end
@implementation SPIPaymentHistoryEntry
- (NSString *)getTerminalRefId{
    if ([_paymentSummary.allKeys containsObject:@"terminal_ref_id"]){
        return _paymentSummary[@"terminal_ref_id"];
    }
    return nil;
}
- (id)init:(NSDictionary *)fromJson{
    return self;
}
- (NSDictionary *)toJsonObject{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:_paymentType forKey:@"payment_type"];
    [data setObject:_paymentSummary forKey:@"payment_summary"];
    return data;
}

@end
@implementation SPIBillPayment
SPIMessage* _incomingAdvice;
- (instancetype)initWithMessage:(SPIMessage *)message{
    _incomingAdvice = message;
    _billId = [_incomingAdvice getDataStringValue:@"bill_id"];
    _tableId = [_incomingAdvice getDataStringValue:@"table_id"];
    _operatorId = [_incomingAdvice getDataStringValue:@"operator_id"];
  
    
    NSInteger paymentType = [_incomingAdvice getDataIntegerValue:@"payment_type"];
    if (paymentType == PaymentTypeCard){
        _paymentType = PaymentTypeCard;
    }else if (paymentType == PaymentTypeCash)
    {
        _paymentType = PaymentTypeCard;
    }
    NSDictionary<NSString *,NSObject *> *data = (NSDictionary *)[message.data valueForKey:@"payment_details"];
    
    // this is when we ply the sub object "payment_details" into a purchase response for convenience.
    SPIMessage *purchaseMsg = [[SPIMessage alloc] initWithMessageId:message.mid eventName:@"payment_details" data:data needsEncryption:false];
    
    _purchaseResponse = [[SPIPurchaseResponse alloc] initWithMessage:purchaseMsg];
    
    _purchaseAmount = [_purchaseResponse getPurchaseAmount];
    
    _TipAmount =  [_purchaseResponse getTipAmount];
    return self;
}
@end
@implementation SPIPayAtTableConfig
- (SPIMessage *)toMessage:(NSString *)messageId{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:@true forKey:@"pay_at_table_enabled"];
    [data setValue:[NSNumber numberWithBool:_operatorIdEnabled] forKey:@"operator_id_enabled"];
    [data setValue:[NSNumber numberWithBool:_splitByAmountEnabled] forKey:@"split_by_amount_enabled"];
    [data setValue:[NSNumber numberWithBool:_equalSplitEnabled] forKey:@"equal_split_enabled"];
    [data setValue:[NSNumber numberWithBool:_tippingEnabled] forKey:@"tipping_enabled"];
    [data setValue:[NSNumber numberWithBool:_summaryReportEnabled] forKey:@"summary_report_enabled"];
    [data setValue:[NSNumber numberWithBool:_labelPayButton] forKey:@"pay_button_label"];
    [data setValue:[NSNumber numberWithBool:_labelOperatorId] forKey:@"operator_id_label"];
    [data setValue:[NSNumber numberWithBool:_labelTableId] forKey:@"table_id_label"];
    [data setValue:_allowedOperatorIds forKey:@"operator_id_list"];
    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:messageId eventName:SPIPayAtTableSetTableConfigKey data:data needsEncryption:true];
    return message;
}
+ (SPIMessage *)featureDisableMessage:(NSString *)messageId{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:@false forKey:@"pay_at_table_enabled"];
    
    SPIMessage *message = [[SPIMessage alloc] initWithMessageId:messageId eventName:SPIPayAtTableSetTableConfigKey data:data needsEncryption:true];
    return message;
}
@end
