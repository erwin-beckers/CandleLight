//+------------------------------------------------------------------+
//|                                            CCandleSizeFilter.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CCandleSizeFilter : public CBasePatternDetector
{
   
public:
   //+------------------------------------------------------------------+
   CCandleSizeFilter() 
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      
      double body = CandleRange(bar);
      
      double cnt     = 0;
      double barSize = 0;
      for (int i=1; i < 100;++i)
      {
         barSize += CandleRange(bar+i);
         cnt++;
      }
      double avgBarSize = barSize / cnt;
      return (body >= (avgBarSize * 0.4));
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Candle size filter";
   }
};

