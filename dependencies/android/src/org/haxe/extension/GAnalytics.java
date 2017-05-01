package org.haxe.extension;


import com.google.android.gms.analytics.ExceptionReporter;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.google.android.gms.analytics.ecommerce.Product;
import com.google.android.gms.analytics.ecommerce.Promotion;
import com.google.android.gms.analytics.ecommerce.ProductAction;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;


import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.util.Log;
import java.util.Map.Entry;

/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class GAnalytics extends Extension {
	
	
	
	
	private static Tracker _gaTracker;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public GAnalytics( ){
			//trace("constructor");
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setDry_run( boolean b ){
			GoogleAnalytics.getInstance( mainContext ).setDryRun( b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setOpt_out( boolean b ){
			GoogleAnalytics.getInstance( mainContext ).setAppOptOut( b );
		}


		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void startSession( String sUA_code , int iPeriod ) {
			//trace("startSession ::: "+sUA_code+" - "+iPeriod);
			_gaTracker = GoogleAnalytics.getInstance( mainContext ).newTracker( sUA_code );
			_gaTracker.enableExceptionReporting( true );
			setDispatch_period( iPeriod );
			
			Thread.UncaughtExceptionHandler handler = new ExceptionReporter(
				_gaTracker,
				Thread.getDefaultUncaughtExceptionHandler(),
				mainContext
			);
			
			Thread.setDefaultUncaughtExceptionHandler(handler);
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setDispatch_period( int iPeriod ) {
			GoogleAnalytics.getInstance( mainContext ).setLocalDispatchPeriod( iPeriod );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void dispatch( ){
			GoogleAnalytics.getInstance( mainContext ).dispatchLocalHits();
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void trackScreen( String datas )
		{
			if (datas != null) {
				try {
					JSONObject jObject = new JSONObject(datas);

					_gaTracker.setScreenName( jObject.get("screenName").toString() );

					HitBuilders.ScreenViewBuilder builder = new HitBuilders.ScreenViewBuilder();
					parseAdditionalParams(builder, jObject);
					_gaTracker.send(builder.build());
					Log.v("GAnalytics", "trackScreen Success!" + builder.build());
				} catch (final JSONException e) {
					Log.e("GAnalytics", "trackScreen Json parsing error: " + e);
				}
			}
		}
		/**
		 *
		 *
		 * @public
		 * @return	void
		 */
		public static void trackEvent(String datas){
			if (datas != null) {
				try {
					JSONObject jObject = new JSONObject(datas);
					HitBuilders.EventBuilder builder = new HitBuilders.EventBuilder();
					builder.setCategory(jObject.getString("eventCategory"));
					builder.setAction(jObject.getString("eventAction"));
					builder.setLabel(jObject.getString("eventLabel"));
					if (jObject.has("eventValue")) {
						builder.setValue(jObject.getLong("eventValue"));
					}
					parseAdditionalParams(builder, jObject);
					_gaTracker.send(builder.build());
					Log.v("GAnalytics", "trackEvent Success!" + builder.build());
				} catch (final JSONException e) {
					Log.e("GAnalytics", "trackEvent Json parsing error: " + e);
				}
			}
		}

		private static void parseAdditionalParams(Object builder, JSONObject jObject)
		{
			try {
				if (jObject.has("campaignData")) {
					Class[] cArg = new Class[1];
					cArg[0] = String.class;
					Method builderMethod = builder.getClass().getMethod("setCampaignParamsFromUrl", cArg);
					try {
						builderMethod.invoke(builder, jObject.get("campaignData").toString());
					} catch (Exception e) {
						Log.e("GAnalytics", "campaignData: " + e);
					}
				}

				if (jObject.has("promotionAction")) {
					Class[] cArg = new Class[1];
					cArg[0] = String.class;
					Method builderMethod = builder.getClass().getMethod("setPromotionAction", cArg);
					try {
						builderMethod.invoke(builder, jObject.get("promotionAction").toString());
					} catch (Exception e) {
						Log.e("GAnalytics", "promotionAction: " + e);
					}
				}

				if (jObject.has("impressionList") && jObject.has("product")) {
					Class[] cArg = new Class[2];
					cArg[0] = Product.class;
					cArg[1] = String.class;
					Method builderMethod = builder.getClass().getMethod("addImpression", cArg);
					try {
						builderMethod.invoke(builder, getProduct(jObject.getJSONObject("product")), jObject.get("impressionList").toString());
					} catch (Exception e) {
						Log.e("GAnalytics", "impressionList: " + e);
					}
				} else if (jObject.has("product")) {
					Class[] cArg = new Class[1];
					cArg[0] = Product.class;
					Method builderMethod = builder.getClass().getMethod("addProduct", cArg);
					try {
						builderMethod.invoke(builder, getProduct(jObject.getJSONObject("product")));
					} catch (Exception e) {
						Log.e("GAnalytics", "impressionList: " + e);
					}
				}

				if (jObject.has("promotion")) {
					Class[] cArg = new Class[1];
					cArg[0] = Promotion.class;
					Method builderMethod = builder.getClass().getMethod("addPromotion", cArg);
					try {
						builderMethod.invoke(builder, getPromotion(jObject.getJSONObject("promotion")));
					} catch (Exception e) {
						Log.e("GAnalytics", "impressionList: " + e);
					}
				}

				if (jObject.has("productAction")) {
					Class[] cArg = new Class[1];
					cArg[0] = ProductAction.class;
					Method builderMethod = builder.getClass().getMethod("setProductAction", cArg);
					try {
						builderMethod.invoke(builder, getProductAction(jObject.getJSONObject("productAction")));
					} catch (Exception e) {
						Log.e("GAnalytics", "impressionList: " + e);
					}
				}

				if (jObject.has("nonInteraction")) {
					Class[] cArg = new Class[1];
					cArg[0] = boolean.class;
					Method builderMethod = builder.getClass().getMethod("setNonInteraction", cArg);
					try {
						builderMethod.invoke(builder, jObject.getBoolean("nonInteraction"));
					} catch (Exception e) {
						Log.e("GAnalytics", "nonInteraction: " + e);
					}
				}

				try {
					if (jObject.has("customDimensions")) {
						Class[] cArg = new Class[2];
						cArg[0] = int.class;
						cArg[1] = String.class;
						Method builderMethod = builder.getClass().getMethod("setCustomDimension", cArg);

						JSONObject cdObject = jObject.getJSONObject("customDimensions");
						Iterator<String> keys = cdObject.keys();
						while (keys.hasNext()) {
							String key = (String) keys.next();
							builderMethod.invoke(builder, Integer.parseInt(key), cdObject.get(key).toString());
						}
					}
				} catch (Exception e) {
					Log.e("GAnalytics", "customDimensions: " + e);
				}
				try {
					if (jObject.has("customMetrics")) {
						Class[] cArg = new Class[2];
						cArg[0] = int.class;
						cArg[1] = float.class;
						Method builderMethod = builder.getClass().getMethod("setCustomMetric", cArg);

						JSONObject cmObject = jObject.getJSONObject("customMetrics");
						Iterator<String> keys = cmObject.keys();
						while (keys.hasNext()) {
							String key = (String) keys.next();
							builderMethod.invoke(builder, Integer.parseInt(key), Float.parseFloat(cmObject.get(key).toString()));
						}
					}
				} catch (Exception e) {
					Log.e("GAnalytics", "customMetrics: " + e);
				}




			} catch (Exception e) {
				Log.e("GAnalytics", "parseAdditionalParams: " + e);
			}
		}
		private static ProductAction getProductAction (JSONObject paObject) {
			Log.d("GAnalytics", "getProductAction_: " + paObject);
			try {
				ProductAction p = new ProductAction(paObject.getString("action"));
				try {
					if (paObject.has("checkoutOptions")) {
						p.setCheckoutOptions(paObject.getString("checkoutOptions"));
					}
					if (paObject.has("checkoutStep")) {
						p.setCheckoutStep(paObject.getInt("checkoutStep"));
					}
					if (paObject.has("productionActionList")) {
						p.setProductActionList(paObject.getString("productionActionList"));
					}
					if (paObject.has("productionListSource")) {
						p.setProductListSource(paObject.getString("productionListSource"));
					}
					if (paObject.has("transactionAffiliation")) {
						p.setTransactionAffiliation(paObject.getString("transactionAffiliation"));
					}
					if (paObject.has("transactionCouponCode")) {
						p.setTransactionCouponCode(paObject.getString("transactionCouponCode"));
					}
					if (paObject.has("transactionId")) {
						p.setTransactionId(paObject.getString("transactionId"));
					}
					if (paObject.has("transactionRevenue")) {
						p.setTransactionRevenue(paObject.getDouble("transactionRevenue"));
					}
					if (paObject.has("transactionShipping")) {
						p.setTransactionShipping(paObject.getDouble("transactionShipping"));
					}
					if (paObject.has("transactionTax")) {
						p.setTransactionTax(paObject.getDouble("transactionTax"));
					}
				} catch (Exception e) {
					Log.e("GAnalytics", "getProductAction1: " + e);
				}
				return p;
			} catch (Exception e) {
				Log.e("GAnalytics", "getProductAction0: " + e);
			}
			return null;
		}
		private static Promotion getPromotion (JSONObject promoObject) {
			Log.d("GAnalytics", "getPromotion: " + promoObject);
			Promotion p = new Promotion();
			try {
				if (promoObject.has("id")) {
					p.setId(promoObject.get("id").toString());
				}
				if (promoObject.has("creative")) {
					p.setCreative(promoObject.get("creative").toString());
				}
				if (promoObject.has("name")) {
					p.setName(promoObject.get("name").toString());
				}
				if (promoObject.has("position")) {
					p.setPosition(promoObject.get("position").toString());
				}
			} catch (Exception e) {
				Log.e("GAnalytics", "getPromotion: " + e);
			}
			return p;
		}
		private static Product getProduct (JSONObject productObject) {
			Log.d("GAnalytics", "product type: " + productObject);
			Product p = new Product();
			try {
				if (productObject.has("id")) {
					p.setId(productObject.get("id").toString());
				}
				if (productObject.has("name")) {
					p.setName(productObject.get("name").toString());
				}
				if (productObject.has("brand")) {
					p.setBrand(productObject.get("brand").toString());
				}
				if (productObject.has("category")) {
					p.setCategory(productObject.get("category").toString());
				}
				if (productObject.has("couponCode")) {
					p.setCouponCode(productObject.get("couponCode").toString());
				}
				if (productObject.has("position")) {
					p.setPosition(Integer.parseInt(productObject.get("position").toString()));
				}
				if (productObject.has("price")) {
					p.setPrice(Double.parseDouble(productObject.get("price").toString()));
				}
				if (productObject.has("quantity")) {
					p.setQuantity(Integer.parseInt(productObject.get("quantity").toString()));
				}
				if (productObject.has("variant")) {
					p.setVariant(productObject.get("variant").toString());
				}
				try {
					if (productObject.has("customDimensions")) {
						JSONObject cdObject = productObject.getJSONObject("customDimensions");
						Iterator<String> keys = cdObject.keys();
						while (keys.hasNext()) {
							String key = (String) keys.next();
							p.setCustomDimension(Integer.parseInt(key), cdObject.get(key).toString());
						}
					}
				} catch (Exception e) {
					Log.e("GAnalytics", "customDimensions: " + e);
				}
				try {
					if (productObject.has("customMetrics")) {
						JSONObject cmObject = productObject.getJSONObject("customMetrics");
						Iterator<String> keys = cmObject.keys();
						while (keys.hasNext()) {
							String key = (String) keys.next();
							p.setCustomMetric(Integer.parseInt(key), Integer.parseInt(cmObject.get(key).toString()));
						}
					}
				} catch (Exception e) {
					Log.e("GAnalytics", "customMetrics: " + e);
				}
			} catch (Exception e) {
				Log.e("GAnalytics", "getProduct: " + e);
			}
			return p;
		}


		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void trackSocial( String sSocial_network , String sAction , String sTarget ){
			_gaTracker.send( new HitBuilders.SocialBuilder()
				.setNetwork( sSocial_network )
				.setAction( sAction )
				.setTarget( sTarget )
				.build()
			);
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void sendTiming( String sCat , String sName , String sLabel, int iVal ){
			_gaTracker.send( new HitBuilders.TimingBuilder()
				.setCategory( sCat )
				.setVariable( sName )
				.setLabel( sLabel )
				.setValue( Long.valueOf( iVal ) )
				.build()
			);
		}

	// -------o protected



	// -------o misc
	
	
	
	public static int sampleMethod (int inputValue) {
		
		return inputValue * 100;
		
	}
	
	
	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		
		return true;
		
	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
		
		
		
	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
		
		
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
		
		GoogleAnalytics.getInstance( mainContext ).reportActivityStart ( mainActivity );
		
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
		
		GoogleAnalytics.getInstance( mainContext ).reportActivityStop ( mainActivity );
		
	}
	
	
}