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
   CCandleSizeFilter(int period) : CBasePatternDetector(period)
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      return IsLargeCandle(bar);
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Candle size filter";
   }
};

