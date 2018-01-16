//+------------------------------------------------------------------+
//|                                       CDoubleReversalPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CDoubleReversalPattern : public CBasePatternDetector
{
private:
   int    _pipsMargin;
   string _patternName;
   
public:
   //+------------------------------------------------------------------+
   CDoubleReversalPattern(int period, int pipsMargin) : CBasePatternDetector(period)
   {
      _pipsMargin = pipsMargin;
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      bool isUp1 = IsUp(bar);
      bool isUp2 = IsUp(bar+1);
      if (isUp1 == isUp2) return false;
      double mult = 1;
      if (Digits ==3 || Digits==5) mult = 10;
      double pips = _pipsMargin * mult * Point();
      
      if (isUp2)
      {
         _patternName = "Bearish double reversal";
         if ( iLow(Symbol(), _period, bar) < iLow(Symbol(), _period, bar+1) && iHigh(Symbol(), _period, bar) + pips > iHigh(Symbol(), _period, bar+1)) return true;
      }
      else
      {
         _patternName = "Bullish double reversal";
         if ( iHigh(Symbol(), _period, bar) > iHigh(Symbol(), _period, bar+1) && iLow(Symbol(), _period, bar) - pips < iLow(Symbol(), _period, bar+1)) return true;
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

