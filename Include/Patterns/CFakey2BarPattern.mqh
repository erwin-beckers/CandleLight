//+------------------------------------------------------------------+
//|                                            CFakey2BarPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;


class CFakey2BarPattern : public CBasePatternDetector
{
private: 
   
public:
   //+------------------------------------------------------------------+
   CFakey2BarPattern()
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol,int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      if (IsPinBar(bar+3)) return false;
      if (IsPinBar(bar+2)) return false;
      if (IsPinBar(bar+1)) return false;
      if (IsPinBar(bar)) return false;
      
      if (IsInsideBar(bar+2))
      {
         bool isUp3 = IsUp(bar+2);
         bool isUp2 = IsUp(bar+2);
         bool isUp1 = IsUp(bar+1);
         bool isUp0 = IsUp(bar);
         if (isUp3 == isUp0 && isUp2 == isUp1)
         {
            if (iHigh(_symbol, _period, bar+1) < iHigh(_symbol, _period, bar+2) && iHigh(_symbol, _period, bar+1) < iHigh(_symbol, _period, bar+3))
            {
               if ( iLow(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1) && iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1))
               {
                  Print("found fakey ",bar," ", iTime(_symbol, _period, bar));
                  return true;
               }
            }
            
            if (iHigh(_symbol, _period, bar+1) > iHigh(_symbol, _period, bar+2) && iHigh(_symbol, _period, bar+1) > iHigh(_symbol, _period, bar+3))
            {
               if ( iHigh(_symbol, _period, bar) < iHigh(_symbol, _period, bar+1) && iHigh(_symbol, _period, bar) < iHigh(_symbol, _period, bar+1))
               {
                  Print("found fakey ",bar," ", iTime(_symbol, _period, bar));
                  return true;
               }
            }
         }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Fakey 2 bar pattern";
   }
};

