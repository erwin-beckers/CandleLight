//+------------------------------------------------------------------+
//|                                            CInsideBarPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CInsideBarPattern : public CBasePatternDetector
{
private: 
   
public:
   //+------------------------------------------------------------------+
   CInsideBarPattern()
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol,int period, int bar)
   {
      _symbol = symbol;
      _period = period;
     return (iLow (_symbol, _period, bar+1) < iLow (_symbol, _period, bar) && 
             iHigh(_symbol, _period, bar+1) > iHigh(_symbol, _period, bar));

   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Inside bar pattern";
   }
};

