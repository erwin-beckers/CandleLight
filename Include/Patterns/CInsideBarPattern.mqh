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
   CInsideBarPattern(int period) : CBasePatternDetector(period)
   {
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
     return (iLow (Symbol(), _period, bar+1) < iLow (Symbol(), _period, bar) && 
             iHigh(Symbol(), _period, bar+1) > iHigh(Symbol(), _period, bar));

   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Inside bar pattern";
   }
   
   //+------------------------------------------------------------------+
   color PatternColor()
   {
      return clrChartreuse;
   }
};

