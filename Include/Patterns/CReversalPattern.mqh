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
   CReversalPattern()
   {
   }

   //+------------------------------------------------------------------+
   //
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      if (IsUp(bar) && !IsUp(bar+1))
      {
         double bodySize = MathAbs(iOpen(_symbol, _period, bar+1) - iClose(_symbol, _period, bar+1));
         double half = iClose(_symbol, _period, bar+1) + bodySize * 0.5;
         if (iClose(_symbol, _period, bar) > half)
         {
            if (iLow(_symbol, _period, bar) < iLow(_symbol, _period, bar+1))
            {
               _patternName = "Bullish Reversal candle";
               return true;
            }
         }
      }
      else if (!IsUp(bar) && IsUp(bar+1))
      {
         double bodySize = MathAbs(iOpen(_symbol, _period, bar+1) - iClose(_symbol, _period, bar+1));
         double half     = iClose(_symbol, _period, bar+1) - bodySize * 0.5;
         if (iClose(_symbol, _period, bar) < half)
         {
            if (iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1))
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

