//+------------------------------------------------------------------+
//|                                                 CDojiPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CDojiPattern : public CBasePatternDetector
{
private: 
   
public:
   //+------------------------------------------------------------------+
   CDojiPattern()
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      /*
      double body      = MathAbs(iClose(_symbol, _period, bar) - iOpen(_symbol, _period, bar));
      double lowerWick = LowerWick(bar);
      double upperWick = UpperWick(bar);
      double range     = iHigh(_symbol, _period, bar) - iLow(_symbol, _period, bar);
      double tail      = MathMax(lowerWick, upperWick);
      double nose      = MathMin(lowerWick, upperWick); 
      
      if (upperWick >= 2*body || lowerWick >= 2*body)  
      {
         if ( (nose / tail) >= 0.4)
         {
            return true;
         }
      }*/
      
      // body is less then 5% of entire candle
      double bodySize = GetCandleBodySize(bar);
      double candleRange = GetCandleRangeSize(bar);
      double percentage = (bodySize / candleRange) * 100.0;
      return percentage <= 15;
      
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Doji pattern";
   }
   
   //+------------------------------------------------------------------+
   color PatternColor()
   {
      return clrChartreuse;
   }
};

