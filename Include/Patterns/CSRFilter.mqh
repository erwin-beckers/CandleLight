//+------------------------------------------------------------------+
//|                                                     SRFilter.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict


#include <Patterns\CBasePatternDetector.mqh>;

class CSRFilter : public CBasePatternDetector
{
private:
   double _pips;
public:
   //+------------------------------------------------------------------+
   CSRFilter(int period, int pips) : CBasePatternDetector(period)
   {
      _pips = pips;
   }

   //+------------------------------------------------------------------+
   bool IsValid(int bar)
   {
      double mult = 1;
      if (Digits ==3 || Digits==5) mult = 10;
      double pips = _pips * mult * Point();
      
      for (int i=0;i < ObjectsTotal(0, 0, -1); i++)
      {
         string name  = ObjectName(0, i); 
         if (ObjectType(name) == OBJ_HLINE)
         {
            double srPrice = ObjectGetDouble(0, name, OBJPROP_PRICE,0); 
            
            if (iLow(Symbol(), _period, bar) - pips <= srPrice)
            {
              if (iHigh(Symbol(), _period, bar) + pips  >= srPrice) return true;
            }
            if (iHigh(Symbol(), _period, bar) + pips >= srPrice)
            {
              if (iLow(Symbol(), _period, bar) - pips  <= srPrice) return true;
            }
         }
         else if (ObjectType(name) == OBJ_TREND)
         {
            datetime time1  = (datetime)ObjectGet(name, OBJPROP_TIME1); 
            datetime time2  = (datetime)ObjectGet(name, OBJPROP_TIME2); 
            if (time1 > time2)
            {
               datetime dum = time1;
               time1 = time2;
               time2 = dum;
            }
            if (iTime(Symbol(), _period, bar) > time1 && iTime(Symbol(), _period, bar) <= time2)
            {
               double priceAtTrendline = ObjectGetValueByShift(name, bar);
               if (iLow(Symbol(), _period, bar) < priceAtTrendline && iHigh(Symbol(), _period, bar) >= priceAtTrendline)
               {  
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
      return "SR Cross";
   }
};

