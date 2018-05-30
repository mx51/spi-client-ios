//
//  SPIPurchaseHelper.h
//  SPIClient-iOS
//
//  Created by Amir Kamali on 31/5/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIPurchase.h"

@interface SPIPurchaseHelper : NSObject

+(SPIPurchaseRequest *) createPurchaseRequest:(int)amountCents purchaseId:(NSString *)purchaseId;
+(SPIPurchaseRequest *) createPurchaseRequestV2:(NSString *)posRefId purchaseAmount:(int)purchaseAmount tipAmount:(int)tipAmount cashAmount:(int)cashAmount promptForCashout:(BOOL)promptForCashout;
+(SPIRefundRequest *)createRefundRequest:(int)amountCents purchaseId:(NSString *)purchaseId;

@end
