//+------------------------------------------------------------------+
//|                                         CBasePatternDetector.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <Patterns\IPatternDetector.mqh>;
class CBasePatternDetector : public IPatternDetector
{
protected:   
   int _period;
   
   //+------------------------------------------------------------------+
   bool IsUp(int bar)
   {
     return iClose(Symbol(), _period, bar) >= iOpen(Symbol(), _period, bar);
   }
   
   //+------------------------------------------------------------------+
   double UpperWick(int bar)
   {
      double upperBody = MathMax(iClose(Symbol(), _period, bar), iOpen(Symbol(), _period, bar));
      return iHigh(Symbol(), _period, bar) - upperBody;
   }
   
   //+------------------------------------------------------------------+
   double LowerWick(int bar)
   {
      double lowerBody = MathMin(iClose(Symbol(), _period, bar), iOpen(Symbol(), _period, bar));
      return lowerBody - iLow(Symbol(), _period, bar);
   }
   
   //+------------------------------------------------------------------+
   int SpaceLeft(int bar)
   {
     double lowerWick = LowerWick(bar);
     double upperWick = UpperWick(bar);
     int cnt=0;
     for (int i=1; i < 20;++i)
     {
        if (upperWick > lowerWick)
        {
          if (iHigh(Symbol(), _period, bar+i) < iHigh(Symbol(), _period, bar)) cnt++;
          else break;
        }
        else
        {
          if (iLow(Symbol(), _period, bar+i) > iLow(Symbol(), _period, bar)) cnt++;
          else break;
        }
     }
     
     return cnt;
   }
   
   //+------------------------------------------------------------------+
   bool IsLargeCandle(int bar)
   {
      double body = MathAbs(iClose(Symbol(), _period, bar) - iOpen(Symbol(), _period, bar));
      
      double cnt     = 0;
      double barSize = 0;
      for (int i=1; i < 30;++i)
      {
         barSize += MathAbs(iClose(Symbol(), _period, bar+1) - iOpen(Symbol(), _period, bar+1));
         cnt++;
      }
      double avgBarSize = barSize / cnt;
      return (body >= avgBarSize);
   }
   
public: 
   //+------------------------------------------------------------------+
   CBasePatternDetector(int period)
   {
      _period = period;
   }
   
   //+------------------------------------------------------------------+
   virtual bool IsValid(int bar)
   {
      return false;
   }
   
   //+------------------------------------------------------------------+
   virtual string PatternName()
   {
      return "";
   }
};