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
	@:optional var setNewSession:Bool;

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
	var timingVariable:String;
	var timingValue:Int;
	@:optional var timingLabel:String;
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
	* @param 	builder
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
	* @param	builder
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
	* @param	builder
	* @return	void
	*/

	static public function sendTiming(builder:TTimingHitBuilder):Void
	{
		var jsonString:String = Json.stringify(builder);
		#if (android && openfl)

		if (ganalytics_sendTiming_jni == null) ganalytics_sendTiming_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "sendTiming", "(Ljava/lang/String;)V");
		ganalytics_sendTiming_jni(jsonString);

		#elseif ios

		ganalytics_sendTiming(jsonString);

		#end
	}


	/**
	* Track a social event
	*
	* @public
	* @param 	builder
	* @return	void
	*/

	static public function trackSocial(builder:TSocialHitBuilder):Void
	{
		var jsonString:String = Json.stringify(builder);
		#if (android && openfl)

		if (ganalytics_trackSocial_jni == null) ganalytics_trackSocial_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "trackSocial", "(Ljava/lang/String;)V");
		ganalytics_trackSocial_jni(jsonString);

		#elseif ios

		ganalytics_sendSocial(jsonString);

		#end
	}

	/**
	* Track an exception event
	*
	* @public
	* @param 	builder
	* @return	void
	*/

	static public function trackException(builder:TExceptionHitBuilder):Void
	{
		var jsonString:String = Json.stringify(builder);
		#if (android && openfl)

		if (ganalytics_trackException_jni == null) ganalytics_trackException_jni = JNI.createStaticMethod("org.haxe.extension.GAnalytics", "trackException", "(Ljava/lang/String;)V");
		ganalytics_trackException_jni(jsonString);

		#elseif ios

		ganalytics_sendException(jsonString);

		#end
	}

	// -------o protected

	// -------o misc

	#if ios

	private static var ganalytics_startNewSession = Lib.load("ganalytics", "ganalytics_startNewSession", 2);

	private static var ganalytics_stopSession = Lib.load("ganalytics", "ganalytics_stopSession", 0);

	private static var ganalytics_sendScreenView = Lib.load("ganalytics", "ganalytics_sendScreenView", 1);

	private static var ganalytics_sendEvent = Lib.load("ganalytics", "ganalytics_sendEvent", 1);

	private static var ganalytics_sendTiming = Lib.load("ganalytics", "ganalytics_sendTiming", 1);

	private static var ganalytics_sendSocial = Lib.load("ganalytics", "ganalytics_sendSocial", 1);

	private static var ganalytics_sendException = Lib.load("ganalytics", "ganalytics_sendException", 1);

	#end

	#if (android && openfl)

	private static var ganalytics_startNewSession_jni:Dynamic;

	private static var ganalytics_trackScreen_jni:Dynamic;

	private static var ganalytics_trackEvent_jni:Dynamic;

	private static var ganalytics_sendTiming_jni:Dynamic;

	private static var ganalytics_trackSocial_jni:Dynamic;

	private static var ganalytics_trackException_jni:Dynamic;

	#end

}