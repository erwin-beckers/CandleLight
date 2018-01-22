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
   CSRFilter(int pips)
   {
      _pips = pips;
   }

   //+------------------------------------------------------------------+
   bool IsValid(string symbol,int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      
      // chart objects only work for current chart
      if (Symbol() != _symbol) return true;
      
      double points   = MarketInfo(_symbol, MODE_POINT);
      double digits   = MarketInfo(_symbol, MODE_DIGITS);
      
      double mult = 1;
      if (digits ==3 || digits==5) mult = 10;
      double pips = _pips * mult * points;
      
      for (int i=0;i < ObjectsTotal(0, 0, -1); i++)
      {
         string name  = ObjectName(0, i); 
         if (ObjectType(name) == OBJ_HLINE)
         {
            double srPrice = ObjectGetDouble(0, name, OBJPROP_PRICE,0); 
            
            if (iLow(_symbol, _period, bar) - pips <= srPrice)
            {
              if (iHigh(_symbol, _period, bar) + pips  >= srPrice) return true;
            }
            if (iHigh(_symbol, _period, bar) + pips >= srPrice)
            {
              if (iLow(_symbol, _period, bar) - pips  <= srPrice) return true;
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
            if (iTime(_symbol, _period, bar) > time1 && iTime(_symbol, _period, bar) <= time2)
            {
               double priceAtTrendline = ObjectGetValueByShift(name, bar);
               if (iLow(_symbol, _period, bar) < priceAtTrendline && iHigh(_symbol, _period, bar) >= priceAtTrendline)
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

