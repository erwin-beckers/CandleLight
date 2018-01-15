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
   CTrippleReversalPattern(int period, int pipsMargin) : CBasePatternDetector(period)
   {
      _pipsMargin = pipsMargin;
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      bool isUp1 = IsUp(bar);
      bool isUp2 = IsUp(bar+1);
      bool isUp3 = IsUp(bar+2);
      if (isUp1 == isUp2 && isUp2 != isUp3)
      {
         double mult = 1;
         if (Digits ==3 || Digits==5) mult = 10;
         double pips = _pipsMargin * mult * Point();
         
         if (isUp3)
         {
            if ( iLow(Symbol(), _period, bar) < iLow(Symbol(), _period, bar+2) && iHigh(Symbol(), _period, bar+1) + pips > iHigh(Symbol(), _period, bar+2)) return true;
         }
         else
         {
            if ( iHigh(Symbol(), _period, bar)  > iHigh(Symbol(), _period, bar+2) && iLow(Symbol(), _period, bar) - pips < iLow(Symbol(), _period, bar+2)) return true;
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

