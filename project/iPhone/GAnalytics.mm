#include "Utils.h"

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAIEcommerceFields.h"

@interface GAnalyticsController : NSObject<UIApplicationDelegate>
@end

@implementation GAnalyticsController

	- (void)parseAdditionalParams:(GAIDictionaryBuilder*)builder withData:(NSDictionary*)responseDic
    {
    	NSLog(@"parseAdditionalParams");
    	if ([[responseDic allKeys] containsObject:@"campaignData"]) {
    		 NSString* deepLinkUrl = [responseDic objectForKey:@"campaignData"];
			[builder setCampaignParametersFromUrl:deepLinkUrl];
    	}
    	if ([[responseDic allKeys] containsObject:@"productAction"]) {
			 NSDictionary* pAction = [responseDic objectForKey:@"productAction"];
			 NSLog( @"productAction string %@",pAction);
			 GAIEcommerceProductAction *action = [self createProductAction:pAction];
			[builder setProductAction:action];
		}
		if ([[responseDic allKeys] containsObject:@"product"]) {
			 NSDictionary* p = [responseDic objectForKey:@"product"];
			 NSLog( @"product string %@",p);
			 GAIEcommerceProduct *pr = [self createProduct:p];
			 if ([[responseDic allKeys] containsObject:@"impressionList"] && [[responseDic allKeys] containsObject:@"impressionSource"]) {
			 	NSString* imprList = [responseDic objectForKey:@"impressionList"];
			 	NSString* imprSource = [responseDic objectForKey:@"impressionSource"];
			 	[builder addProductImpression:pr
                               impressionList:imprList
                             impressionSource:imprSource];
			 } else {
			 	[builder addProduct:pr];
			 }
		}
		if ([[responseDic allKeys] containsObject:@"promotion"]) {
			 NSDictionary* p = [responseDic objectForKey:@"promotion"];
			 NSLog( @"promotion string %@",p);
			 GAIEcommercePromotion *pr = [self createPromotion:p];
			[builder addPromotion:pr];
		}
		if ([[responseDic allKeys] containsObject:@"promotionAction"]) {
			 NSString* pAction = [responseDic objectForKey:@"promotionAction"];
			 NSLog( @"promotionAction string %@",pAction);
			 [builder set:pAction forKey:kGAIPromotionAction];
		}
		if ([[responseDic allKeys] containsObject:@"nonInteraction"]) {
			 NSString* ni = [responseDic objectForKey:@"nonInteraction"];
			 NSLog( @"nonInteraction %@",ni);
			 [builder set:ni forKey:kGAINonInteraction];
		}
		if ([[responseDic allKeys] containsObject:@"setNewSession"]) {
			 NSString* ni = [responseDic objectForKey:@"setNewSession"];
			 NSString *good = @"1";
			 NSLog( @"setNewSession %@",ni);
			 if (ni == good) {
			 	[builder set:@"start" forKey:kGAISessionControl];
			 }
		}
    }
    - (GAIEcommercePromotion*) createPromotion:(NSDictionary*)p
    {
		GAIEcommercePromotion *promo = [[GAIEcommercePromotion alloc] init];
    	if ([[p allKeys] containsObject:@"id"]) {
			NSString* d = [p objectForKey:@"id"];
			[promo setId:d];
		}
		if ([[p allKeys] containsObject:@"name"]) {
			NSString* d = [p objectForKey:@"name"];
			[promo setName:d];
		}
		if ([[p allKeys] containsObject:@"creative"]) {
			NSString* d = [p objectForKey:@"creative"];
			[promo setCreative:d];
		}
		if ([[p allKeys] containsObject:@"position"]) {
			NSString* d = [p objectForKey:@"position"];
			[promo setPosition:d];
		}
		return promo;
    }
    - (GAIEcommerceProduct*) createProduct:(NSDictionary*)p
    {
    	GAIEcommerceProduct *product = [[GAIEcommerceProduct alloc] init];
    	if ([[p allKeys] containsObject:@"id"]) {
			NSString* d = [p objectForKey:@"id"];
			[product setId:d];
		}
		if ([[p allKeys] containsObject:@"brand"]) {
			NSString* d = [p objectForKey:@"brand"];
			[product setBrand:d];
		}
		if ([[p allKeys] containsObject:@"category"]) {
			NSString* d = [p objectForKey:@"category"];
			[product setCategory:d];
		}
		if ([[p allKeys] containsObject:@"couponCode"]) {
			NSString* d = [p objectForKey:@"couponCode"];
			[product setCouponCode:d];
		}
		if ([[p allKeys] containsObject:@"name"]) {
			NSString* d = [p objectForKey:@"name"];
			[product setName:d];
		}
		if ([[p allKeys] containsObject:@"variant"]) {
			NSString* d = [p objectForKey:@"variant"];
			[product setVariant:d];
		}
		if ([[p allKeys] containsObject:@"position"]) {
			NSNumber* n = [p objectForKey:@"position"];
			[product setPosition:n];
		}
		if ([[p allKeys] containsObject:@"quantity"]) {
			NSNumber* n = [p objectForKey:@"quantity"];
			[product setQuantity:n];
		}
		if ([[p allKeys] containsObject:@"price"]) {
			NSNumber* n = [p objectForKey:@"price"];
			[product setPrice:n];
		}
		if ([[p allKeys] containsObject:@"price"]) {
			NSNumber* n = [p objectForKey:@"price"];
			[product setPrice:n];
		}
		if ([[p allKeys] containsObject:@"customDimensions"]) {
			NSDictionary* cd = [p objectForKey:@"customDimensions"];
			for (NSString* key in cd) {
				id value = [cd objectForKey:key];
				NSUInteger i = (NSUInteger)[key integerValue];
				[product setCustomDimension:i value:value];
			}
		}
		if ([[p allKeys] containsObject:@"customMetrics"]) {
			NSDictionary* cd = [p objectForKey:@"customMetrics"];
			for (NSString* key in cd) {
				id value = [cd objectForKey:key];
				NSUInteger i = (NSUInteger)[key integerValue];
				[product setCustomMetric:i value:value];
			}
		}
		return product;
    }
    - (GAIEcommerceProductAction*) createProductAction:(NSDictionary*)pAction
    {
    	GAIEcommerceProductAction *action = [[GAIEcommerceProductAction alloc] init];
		if ([[pAction allKeys] containsObject:@"action"]) {
			NSString* d = [pAction objectForKey:@"action"];
			[action setAction:d];
		}
		if ([[pAction allKeys] containsObject:@"checkoutOptions"]) {
			NSString* d = [pAction objectForKey:@"checkoutOptions"];
			[action setCheckoutOption:d];
		}
		if ([[pAction allKeys] containsObject:@"checkoutStep"]) {
			NSNumber* n = [pAction objectForKey:@"checkoutStep"];
			[action setCheckoutStep:n];
		}
		if ([[pAction allKeys] containsObject:@"productionActionList"]) {
			NSString* d = [pAction objectForKey:@"productionActionList"];
			[action setProductActionList:d];
		}
		if ([[pAction allKeys] containsObject:@"productionListSource"]) {
			NSString* d = [pAction objectForKey:@"productionListSource"];
			[action setProductListSource:d];
		}
		if ([[pAction allKeys] containsObject:@"transactionAffiliation"]) {
			NSString* d = [pAction objectForKey:@"transactionAffiliation"];
			[action setAffiliation:d];
		}
		if ([[pAction allKeys] containsObject:@"transactionCouponCode"]) {
			NSString* d = [pAction objectForKey:@"transactionCouponCode"];
			[action setCouponCode:d];
		}
		if ([[pAction allKeys] containsObject:@"transactionId"]) {
			NSString* d = [pAction objectForKey:@"transactionId"];
			[action setTransactionId:d];
		}
		if ([[pAction allKeys] containsObject:@"transactionRevenue"]) {
			NSNumber* n = [pAction objectForKey:@"transactionRevenue"];
			[action setRevenue:n];
		}
		if ([[pAction allKeys] containsObject:@"transactionShipping"]) {
			NSNumber* n = [pAction objectForKey:@"transactionShipping"];
			[action setShipping:n];
		}
		if ([[pAction allKeys] containsObject:@"transactionTax"]) {
			NSNumber* n = [pAction objectForKey:@"transactionTax"];
			[action setTax:n];
		}
    	return action;
    }

@end

namespace ganalytics {

	static id<GAITracker> tracker;

	GAnalyticsController* getController()
	{
		static GAnalyticsController* controller = NULL;
		if(controller == NULL)
		{
			controller = [[GAnalyticsController alloc] init];
		}
		return controller;
	}

	void startNewSession( const char *sUID , int iPeriod ){
		NSString *NSUID = [NSString stringWithUTF8String:sUID];
		//NSLog( @"startNewSession %@" , NSUID );
		tracker = [[GAI sharedInstance] trackerWithTrackingId:NSUID];
		tracker.allowIDFACollection = YES;
		[[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
	}

	void sendScreenView(  const char *sScreen ) {
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sScreen];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		NSString *screenName = [responseDic objectForKey:@"screenName"];
		NSLog( @"sendScreenView %@" , screenName );
		[tracker set:kGAIScreenName value:screenName];
		GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
		GAnalyticsController* controller = getController();
        [controller parseAdditionalParams:builder withData:responseDic];
        setCustomParams(sScreen);
		// Send a screenview.
		//NSLog( @"sendScreenView build %@" , [builder build] );
		[tracker send:[builder build]];
	}
	void sendEvent( const char *sData){
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sData];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		NSString *eventCategory = [responseDic objectForKey:@"eventCategory"];
		NSString *eventAction = [responseDic objectForKey:@"eventAction"];
		NSString *eventLabel = nil;
		NSNumber *eventValue = nil;
		if ([[responseDic allKeys] containsObject:@"eventLabel"]) {
			eventLabel = [responseDic objectForKey:@"eventLabel"];
		}
		if ([[responseDic allKeys] containsObject:@"eventValue"]) {
			eventValue = [responseDic objectForKey:@"eventValue"];
		}

		GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:eventCategory
																				action:eventAction
																				 label:eventLabel
																				 value:eventValue];
		GAnalyticsController* controller = getController();
		[controller parseAdditionalParams:builder withData:responseDic];
		setCustomParams(sData);
		//NSLog( @"sendEvent build %@" , [builder build] );
		[tracker send:[builder build]];
	}

	void sendTiming( const char *sData ){
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sData];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

		NSString *timingCategory = [responseDic objectForKey:@"timingCategory"];
		NSString *timingVariable = [responseDic objectForKey:@"timingVariable"];
		NSNumber *timingValue = [responseDic objectForKey:@"timingValue"];
		NSString *timingLabel = nil;
		if ([[responseDic allKeys] containsObject:@"timingLabel"]) {
			timingLabel = [responseDic objectForKey:@"timingLabel"];
		}


		GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:timingCategory
																						interval:timingValue
																							name:timingVariable
																						   label:timingLabel];
		GAnalyticsController* controller = getController();
		[controller parseAdditionalParams:builder withData:responseDic];
		setCustomParams(sData);
		//NSLog( @"sendEvent build %@" , [builder build] );
		[tracker send:[builder build]];
	}

	void sendSocial( const char *sData ){
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sData];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

		NSString *socialNetwork = [responseDic objectForKey:@"socialNetwork"];
		NSString *socialAction = [responseDic objectForKey:@"socialAction"];
		NSString *socialTarget = nil;
		if ([[responseDic allKeys] containsObject:@"socialTarget"]) {
			socialTarget = [responseDic objectForKey:@"socialTarget"];
		}

		GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createSocialWithNetwork:socialNetwork
																			  action:socialAction
																			  target:socialTarget];
		GAnalyticsController* controller = getController();
		[controller parseAdditionalParams:builder withData:responseDic];
		setCustomParams(sData);
		[tracker send:[builder build]];
	}
	void sendException( const char *sData ){
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sData];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

		NSNumber *fatal = [responseDic objectForKey:@"fatal"];
		NSString *exceptionDescription = nil;
		if ([[responseDic allKeys] containsObject:@"exceptionDescription"]) {
			exceptionDescription = [responseDic objectForKey:@"exceptionDescription"];
		}

		GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createExceptionWithDescription:exceptionDescription
																			  withFatal:fatal];
		GAnalyticsController* controller = getController();
		[controller parseAdditionalParams:builder withData:responseDic];
		setCustomParams(sData);
		[tracker send:[builder build]];
	}
	void setCustomParams(const char *sData){
		NSString *NSScreen = [[NSString alloc] initWithUTF8String:sData];
		NSData* data = [NSScreen dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

		if ([[responseDic allKeys] containsObject:@"customDimensions"]) {
			 NSDictionary* cd = [responseDic objectForKey:@"customDimensions"];
			 NSLog( @"customDimensions %@",cd);
			 for (NSString* key in cd) {
				id value = [cd objectForKey:key];
				NSUInteger i = (NSUInteger)[key integerValue];
				[tracker set:[GAIFields customDimensionForIndex:i] value:value];
			}
		}
		if ([[responseDic allKeys] containsObject:@"customMetrics"]) {
			 NSDictionary* cd = [responseDic objectForKey:@"customMetrics"];
			 NSLog( @"customMetrics %@",cd);
			 for (NSString* key in cd) {
				id value = [cd objectForKey:key];
				NSUInteger i = (NSUInteger)[key integerValue];
				[tracker set:[GAIFields customMetricForIndex:i] value:value];
			}
		}
	}
	void stopSession( ){
		//[[GANTracker sharedTracker] stopTracker];
	}

}
