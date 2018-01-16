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
   CDojiPattern(int period) : CBasePatternDetector(period)
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      double body      = MathAbs(iClose(Symbol(), _period, bar) - iOpen(Symbol(), _period, bar));
      double lowerWick = LowerWick(bar);
      double upperWick = UpperWick(bar);
      double range     = iHigh(Symbol(), _period, bar) - iLow(Symbol(), _period, bar);
      double tail      = MathMax(lowerWick, upperWick);
      double nose      = MathMin(lowerWick, upperWick); 
      
      if (upperWick >= 2*body || lowerWick >= 2*body)  
      {
         if ( (nose / tail) >= 0.4)
         {
            return true;
         }
      }
      return false;
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

