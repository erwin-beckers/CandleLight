//+------------------------------------------------------------------+
//|                                             CReversalPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CReversalPattern : public CBasePatternDetector
{
private: 
   string _patternName;
   
public:
   //+------------------------------------------------------------------+
   CReversalPattern(int period) : CBasePatternDetector(period)
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      if (IsUp(bar) && !IsUp(bar+1))
      {
         double bodySize = MathAbs(iOpen(Symbol(), _period, bar+1) - iClose(Symbol(), _period, bar+1));
         double half = iClose(Symbol(), _period, bar+1) + bodySize * 0.5;
         if (iClose(Symbol(), _period, bar) > half)
         {
            if (iLow(Symbol(), _period, bar) < iLow(Symbol(), _period, bar+1))
            {
               _patternName = "Bullish Reversal candle";
               return true;
            }
         }
      }
      else if (!IsUp(bar) && IsUp(bar+1))
      {
         double bodySize = MathAbs(iOpen(Symbol(), _period, bar+1) - iClose(Symbol(), _period, bar+1));
         double half     = iClose(Symbol(), _period, bar+1) - bodySize * 0.5;
         if (iClose(Symbol(), _period, bar) < half)
         {
            if (iHigh(Symbol(), _period, bar) > iHigh(Symbol(), _period, bar+1))
            {
               _patternName = "Bearish Reversal candle";
               return true;
            }
         }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return _patternName;
   }
   
   
   //+------------------------------------------------------------------+
   int BarCount()
   {
      return 2;
   }
};

