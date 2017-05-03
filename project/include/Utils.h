#ifndef GA_H
#define GA_H


namespace ganalytics {
	
	
	void startNewSession( const char *sUID , int iPeriod );
	void sendScreenView( const char *sScreen );
	void sendEvent( const char *sData);
	void sendSocial( const char *sData );
	void sendTiming( const char *sData );
	void sendException( const char *sData );
	void stopSession( );
	void setCustomParams(const char *data);

}


#endif