#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace ganalytics;



#ifdef IPHONE

	static value ganalytics_startNewSession( value sUA_code , value iPeriod ){
		startNewSession( val_string( sUA_code ) , val_int( iPeriod ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_startNewSession , 2 );

	static value ganalytics_sendScreenView( value sScreen ){
		sendScreenView( val_string( sScreen ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendScreenView , 1 );

	static value ganalytics_sendEvent( value data){
		sendEvent(
					val_string( data )
				);
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendEvent , 1 );

	static value ganalytics_sendTiming( value data){
		sendTiming( val_string( data ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendTiming , 1 );

	static value ganalytics_stopSession( ){
		stopSession( );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_stopSession , 0 );

	static value ganalytics_sendSocial( value data ){
		sendSocial( val_string( data ));
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendSocial , 1 );

	static value ganalytics_sendException( value data ){
		sendException( val_string( data ));
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendException , 1 );

#endif


extern "C" void ganalytics_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (ganalytics_main);


extern "C" int ganalytics_register_prims () { return 0; }