//+------------------------------------------------------------------+
//|                                                   HiLoFilter.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CSwingHiLoFilter : public CBasePatternDetector
{
private:
   double _swingHiLoBars;
   
public:
   //+------------------------------------------------------------------+
   CSwingHiLoFilter(int swingHiLoBars)
   {
      _swingHiLoBars = swingHiLoBars;
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      int space = SpaceLeft(bar);
      return space >= _swingHiLoBars;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Swing Hi/Lo filter";
   }
};

