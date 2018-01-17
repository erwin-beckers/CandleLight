//+------------------------------------------------------------------+
//|                                               CPinbarPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CPinbarPattern : public CBasePatternDetector
{
private: 
   
public:
   //+------------------------------------------------------------------+
   CPinbarPattern()
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      double body      = MathAbs(iClose(_symbol, _period, bar) - iOpen(_symbol, _period, bar));
      double lowerWick = LowerWick(bar);
      double upperWick = UpperWick(bar);
      double range     = iHigh(_symbol, _period, bar) - iLow(_symbol, _period, bar);
      double tail      = MathMax(lowerWick, upperWick);
      double nose      = MathMin(lowerWick, upperWick); 
      // The body of a pin bar must be no more than 20% of the measurement of the body to the tip of the wick
       
      //if ( (nose / tail) >= 0.4) return false; // doji
      
     if (upperWick >= 2 * body || lowerWick >= 2 * body)  
      {
        if (tail > 2 * nose)
         {
            return true;
         }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Pinbar pattern";
   }
};

