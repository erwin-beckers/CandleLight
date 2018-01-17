//+------------------------------------------------------------------+
//|                                     CTripplerReversalPattern.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\CBasePatternDetector.mqh>;

class CTrippleReversalPattern : public CBasePatternDetector
{
private:
   int _pipsMargin;
   
public:
   //+------------------------------------------------------------------+
   CTrippleReversalPattern(int pipsMargin)
   {
      _pipsMargin = pipsMargin;
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol,int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      
      double points   = MarketInfo(_symbol, MODE_POINT);
      double digits   = MarketInfo(_symbol, MODE_DIGITS);
      
      bool isUp1 = IsUp(bar);
      bool isUp2 = IsUp(bar+1);
      bool isUp3 = IsUp(bar+2);
      if (isUp1 == isUp2 && isUp2 != isUp3)
      {
         double mult = 1;
         if (digits ==3 || digits==5) mult = 10;
         double pips = _pipsMargin * mult * points;
         
         if (isUp3)
         {
            if ( iLow(_symbol, _period, bar) < iLow(_symbol, _period, bar+2) && iHigh(_symbol, _period, bar+1) + pips > iHigh(_symbol, _period, bar+2)) return true;
         }
         else
         {
            if ( iHigh(_symbol, _period, bar)  > iHigh(_symbol, _period, bar+2) && iLow(_symbol, _period, bar) - pips < iLow(_symbol, _period, bar+2)) return true;
         }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "Double Reversal";
   }
};

