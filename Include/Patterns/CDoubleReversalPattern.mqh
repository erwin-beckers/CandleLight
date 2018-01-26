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
   int    _previousCandleCount;
   int    _bodySizePercentage;
   string _patternName;
   
public:
   //+------------------------------------------------------------------+
   CDoubleReversalPattern(int previousCandleCount=5, int bodySizePercentage=70) 
   {
      _previousCandleCount = previousCandleCount;
      _bodySizePercentage = bodySizePercentage;
   }

   //+------------------------------------------------------------------+
   // engulfing : 
   //  - bar is opposite from previous bar
   //  - range is greater then range of previous candles
   //  - range is greater then the range of the previous 5 candles
   //  - body is 70% or higher of the range
   //
   bool IsValid(string symbol, int period, int bar)
   {
      _symbol = symbol;
      _period = period;
      bool isUp1 = IsUp(bar);
      bool isUp2 = IsUp(bar+1);
      if (isUp1 == isUp2) return false;
      
      // check if bar has the highest range of the previous x bars
      double maxRange=0;
      double candleRange = GetCandleRangeSize(bar);
      for (int i=0; i < _previousCandleCount; ++i)
      {
         maxRange = MathMax(maxRange, GetCandleRangeSize(bar + 1 + i) );
      }
      if (candleRange < maxRange) return false;
      
      // check body size
      double bodySize = GetCandleBodySize(bar);
      double percentage = (bodySize / candleRange) * 100.0;
      if (percentage < _bodySizePercentage) return false;
    
     
      
      
      if (isUp2)
      {
         _patternName = "Bearish double reversal";
         if ( iLow (_symbol, _period, bar) < iLow (_symbol, _period, bar+1) && 
              iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1) ) return true;
      }
      else
      {
         _patternName = "Bullish double reversal";
         if ( iHigh(_symbol, _period, bar) > iHigh(_symbol, _period, bar+1) && 
              iLow (_symbol, _period, bar) < iLow (_symbol, _period, bar+1) ) return true;
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

