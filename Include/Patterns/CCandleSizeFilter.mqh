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
      return IsLargeCandle(bar);
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Candle size filter";
   }
};

