package;

/*
Copyright (c) 2013, Hyperfiction
All rights reserved.

Update to Google Analytics V3 API and latest OpenFL API by Emiliano Angelini - Emibap

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end
import haxe.Json;

@:enum abstract EProductActionType(String)
{
	var ACTION_ADD = 'add';
	var ACTION_CHECKOUT = 'checkout';
	var ACTION_CHECKOUT_OPTION = 'checkout_option';
	var ACTION_CLICK = 'click';
	var ACTION_DETAIL = 'detail';
	var ACTION_PURCHASE = 'purchase';
	var ACTION_REFUND = 'refund';
	var ACTION_REMOVE = 'remove';
}

@:enum abstract EPromotionActionType(String)
{
	var ACTION_CLICK = 'click';
	var ACTION_VIEW = 'view';
}

typedef TProduct =
{
	@:optional var brand:String;
	@:optional var category:String;
	@:optional var couponCode:String;
	@:optional var id:String;
	@:optional var name:String;
	@:optional var variant:String;
	@:optional var position:Int;
	@:optional var quantity:Int;
	@:optional var price:Float;
	@:optional var customDimensions:Dynamic<String>;
	@:optional var customMetrics:Dynamic<Int>;
}

typedef TProductAction =
{
	var action:EProductActionType;
	@:optional var checkoutOptions:String;
	@:optional var checkoutStep:Int;
	@:optional var productionActionList:String;
	@:optional var productionListSource:String;
	@:optional var transactionAffiliation:String;
	@:optional var transactionCouponCode:String;
	@:optional var transactionId:String;
	@:optional var transactionRevenue:Float;
	@:optional var transactionShipping:Float;
	@:optional var transactionTax:Float;
}

typedef TPromotion =
{
	@:optional var creative:String;
	@:optional var id:String;
	@:optional var name:String;
	@:optional var position:String;
}

typedef THitBuilder =
{
	@:optional var campaignData:String;
	@:optional var product:TProduct;
	@:optional var productAction:TProductAction;
	@:optional var promotion:TPromotion;
	@:optional var impressionList:String;
	@:optional var promotionAction:EPromotionActionType;
	@:optional var nonInteraction:Bool;

	@:optional var customDimensions:Dynamic<String>;
	@:optional var customMetrics:Dynamic<Float>;
}

typedef TEventHitBuilder =
{
	> THitBuilder,
	var eventCategory:String;
	var eventAction:String;
	var eventLabel:String;
	@:optional var eventValue:Int;
}

typedef TAppViewHitBuilder =
{
	> THitBuilder,
	var screenName:String;
}

typedef TExceptionHitBuilder =
{
	> THitBuilder,
	var exceptionDescription:String;
	var fatal:Bool;
}

typedef TItemHitBuilder =
{
	> THitBuilder,
	var transactionID:String;
	var name:String;
	var SKU:String;
	@:optional var category:String;
	@:optional var currencyCode:String;
	@:optional var price:Float;
	@:optional var quantity:Int;
}

typedef TSocialHitBuilder =
{
	> THitBuilder,
	var socialNetwork:String;
	var socialAction:String;
	var socialTarget:String;
}

typedef TTimingHitBuilder =
{
	> THitBuilder,
	var timingCategory:String;
	@:optional var timingName:String;
	@:optional var timingLabel:String;
	@:optional var timingInterval:Int;
}

typedef TTransactionHitBuilder =
{
	> THitBuilder,
	var transactionID:String;
	var affiliation:String;
	@:optional var currencyCode:String;
	@:optional var revenue:Float;
	@:optional var tax:Float;
	@:optional var shipping:Float;
}

class GAnalytics
{

	// -------o public

	/**
	* Start the Ga tracking session
	*
	* @public
	* @param sUA : GA UA code ( String )
	* @param iPeriod ( Int )
	* @return	void
	*/

	static public function startSession(sUA:String, iPeriod:Int = 15):Void
	{
		#if (android && openfl)

		if (ganalytics_startNewSession_jni == null) ganalytics_startNewSession_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "startSession", "(Ljava/lang/String;I)V");

		ganalytics_startNewSession_jni(sUA, iPeriod);

		#elseif ios

		ganalytics_startNewSession(sUA, iPeriod);

		#end
	}

	/**
	* Stop the GA tracking session
	*
	* @public
	* @return	void
	*/

	static public function stopSession():Void
	{
		#if (android && openfl)

		#elseif ios

		ganalytics_stopSession();

		#end
	}

	/**
	* Track a screen view
	*
	* @public
	* @param 	sScreen : Code of the screen to be tracked ( String )
	* @return	void
	*/

	static public function trackScreen(builder:TAppViewHitBuilder):Void
	{
		var jsonString:String = Json.stringify(builder);

		#if (android && openfl)

		if (ganalytics_trackScreen_jni == null) ganalytics_trackScreen_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "trackScreen", "(Ljava/lang/String;)V");

		ganalytics_trackScreen_jni(jsonString);

		#elseif ios

		ganalytics_sendScreenView(jsonString);

		#end
	}

	/**
	* Track a event
	*
	* @public
	* @param	sCat		: Event category 	( String )
	* @param	sCat		: Action 			( String )
	* @param	sLabel	: Event label 		( String )
	* @param	value	: Event value 		( Int )
	* @return	void
	*/

	static public function trackEvent(builder:TEventHitBuilder):Void
	{
		var jsonString:String = Json.stringify(builder);

		#if (android && openfl)

		if (ganalytics_trackEvent_jni == null) ganalytics_trackEvent_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "trackEvent", "(Ljava/lang/String;)V");
		ganalytics_trackEvent_jni(jsonString);

		#elseif ios
		ganalytics_sendEvent(jsonString);
		#end
	}

	/**
	*
	*
	* @public
	* @param	sCat		: Event category 	( String )
	* @param	iInterval	: Timing interval 	( Int )
	* @param	sName	: Timing name 		( String )
	* @param	sLabel	: Label 			( String )
	* @return	void
	*/

	static public function sendTiming(sCat:String, sName:String, sLabel:String, iValue:Int):Void
	{
		#if (android && openfl)

		if (ganalytics_sendTiming_jni == null) ganalytics_sendTiming_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "sendTiming", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V");
		ganalytics_sendTiming_jni(sCat, sName, sLabel, iValue);

		#elseif ios

		ganalytics_sendTiming(sCat, iValue, sName, sLabel);

		#end
	}

	/**
	* Set a custom dimension value
	*
	* @public
	* @param	iIndex : Index of the dimension 	( Int )
	* @param	sValue : Dimension value 		( String )
	* @return	void
	*/

	static public function setCustom_dimension(iIndex:Int, sValue:String):Void
	{
		#if (android && openfl)

		#elseif ios
		ganalytics_setCustom_dimension(iIndex, sValue);
		#end
	}

	/**
	* Set a custom metric value
	*
	* @public
	* @param	iIndex : Index of the metric 	( Int )
	* @param	sValue : Metric value 		( String )
	* @return	void
	*/

	static public function setCustom_metric(iIndex:Int, iValue:Int):Void
	{
		#if (android && openfl)

		#elseif ios

		ganalytics_setCustom_metric(iIndex, iValue);

		#end
	}

	/**
	* Track a social event
	*
	* @public
	* @param 	sSocial_network :Targetted social network ( String )
	* @param 	sAction : Action ( String )
	* @return	void
	*/

	static public function trackSocial(sSocial_network:String, sAction:String, sTarget:String):Void
	{
		#if (android && openfl)

		if (ganalytics_trackSocial_jni == null) ganalytics_trackSocial_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "trackSocial", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
		ganalytics_trackSocial_jni(sSocial_network, sAction, sTarget);

		#elseif ios

		ganalytics_sendSocial(sSocial_network, sAction, sTarget);

		#end
	}

	// -------o protected

	// -------o misc

	#if ios

	private static var ganalytics_startNewSession = Lib.load("ganalytics", "ganalytics_startNewSession", 2);

	private static var ganalytics_stopSession = Lib.load("ganalytics", "ganalytics_stopSession", 0);

	private static var ganalytics_sendScreenView = Lib.load("ganalytics", "ganalytics_sendScreenView", 1);

	private static var ganalytics_sendEvent = Lib.load("ganalytics", "ganalytics_sendEvent", 1);

	private static var ganalytics_sendTiming = Lib.load("ganalytics", "ganalytics_sendTiming", 4);

	private static var ganalytics_setCustom_dimension = Lib.load("ganalytics", "ganalytics_setCustom_dimension", 2);

	private static var ganalytics_setCustom_metric = Lib.load("ganalytics", "ganalytics_setCustom_metric", 2);

	private static var ganalytics_sendSocial = Lib.load("ganalytics", "ganalytics_sendSocial", 3);

	#end

	#if (android && openfl)

	private static var ganalytics_startNewSession_jni:Dynamic;

	private static var ganalytics_trackScreen_jni:Dynamic;

	private static var ganalytics_trackEvent_jni:Dynamic;

	private static var ganalytics_sendTiming_jni:Dynamic;

	private static var ganalytics_trackSocial_jni:Dynamic;

	#end

}