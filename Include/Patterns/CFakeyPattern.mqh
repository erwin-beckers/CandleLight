//+------------------------------------------------------------------+
//|                                                CFakeyPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CFakeyPattern : public CBasePatternDetector
{
private: 
   
public:
   //+------------------------------------------------------------------+
   CFakeyPattern()
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol,int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      if (IsPinBar(bar+2)) return false;
      if (IsPinBar(bar+1)) return false;
      if (IsInsideBar(bar+1))
      {
         if (IsPinBar(bar))
         {
            bool isUp2 = IsUp(bar+2);
            bool isUp1 = IsUp(bar+1);
            bool isUp0 = IsUp(bar);
            
            if (isUp2 != isUp1 && isUp0 == isUp2)
            {      
               if (iLow(_symbol, _period, bar) < iLow(_symbol, _period, bar+2)) 
               {
                  if (iHigh(_symbol, _period, bar) < iHigh(_symbol, _period, bar+1))
                  {
                     return true;
                  }
               }
               else if (iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+2))
               {
                  if (iLow(_symbol, _period, bar) > iLow(_symbol, _period, bar+1))
                  {
                     return true;
                  }
               }
            }  
          }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Fakey pattern";
   }
};

