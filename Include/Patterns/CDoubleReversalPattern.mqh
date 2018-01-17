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
   CDoubleReversalPattern(int pipsMargin) 
   {
      _pipsMargin = pipsMargin;
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      bool isUp1 = IsUp(bar);
      bool isUp2 = IsUp(bar+1);
      if (isUp1 == isUp2) return false;
      
      double points   = MarketInfo(_symbol, MODE_POINT);
      double digits   = MarketInfo(_symbol, MODE_DIGITS);
      
      double mult = 1;
      if (digits ==3 || digits==5) mult = 10;
      double pips = _pipsMargin * mult * points;
      
      if (isUp2)
      {
         _patternName = "Bearish double reversal";
         if ( iLow(_symbol, _period, bar) < iLow(_symbol, _period, bar+1) && iHigh(_symbol, _period, bar) + pips > iHigh(_symbol, _period, bar+1)) return true;
      }
      else
      {
         _patternName = "Bullish double reversal";
         if ( iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1) && iLow(_symbol, _period, bar) - pips < iLow(_symbol, _period, bar+1)) return true;
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

