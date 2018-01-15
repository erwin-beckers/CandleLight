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
      double body = MathAbs(iClose(Symbol(), _period, bar) - iOpen(Symbol(), _period, bar));
      
      double cnt     = 0;
      double barSize = 0;
      for (int i=1; i < 30;++i)
      {
         barSize += MathAbs(iClose(Symbol(), _period, bar+1) - iOpen(Symbol(), _period, bar+1));
         cnt++;
      }
      double avgBarSize = barSize / cnt;
      return (body >= avgBarSize);
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Candle size filter";
   }
};

