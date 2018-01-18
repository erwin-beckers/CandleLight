//+------------------------------------------------------------------+
//|                                         CDistributedSRFilter.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

#include <CDistributedSR.mqh>
#include <Patterns\CBasePatternDetector.mqh>;

//+------------------------------------------------------------------+
class CSRPair
{
public:
   string          _symbol;
   CDistributedSR* _srLevels;
   
   //+------------------------------------------------------------------+
   CSRPair(string symbol)
   {
      _symbol   = symbol;
      _srLevels = new CDistributedSR(symbol);
   }
   
   //+------------------------------------------------------------------+
   bool IsAtSRLevel(int period, int bar, int pips)
   {
      if (!_srLevels.HasLevels()) return true;
      
      double points   = MarketInfo(_symbol, MODE_POINT);
      double digits   = MarketInfo(_symbol, MODE_DIGITS);
      
      double mult = 1;
      if (digits ==3 || digits==5) mult = 10;
      double distance = pips * mult * points;
      
      return _srLevels.IsLevelAt(period, bar, distance);
   }
   
   //+------------------------------------------------------------------+
   void Draw()
   {
      _srLevels.DrawSR();
   }
};


//+------------------------------------------------------------------+
class CDistributedSRFilter : public CBasePatternDetector
{
private: 
   CSRPair* _pairs[];
   int      _pairCount;
   int      _pips;
   
public:
   //+------------------------------------------------------------------+
   CDistributedSRFilter(int pips)
   {
      _pips = pips;
      ArrayResize(_pairs, 50);
      _pairCount = 0;
   }

   //+------------------------------------------------------------------+
   ~CDistributedSRFilter()
   {
      for (int i=0; i < _pairCount;++i)
      {
         delete _pairs[i];
      }
      _pairCount = 0;
      ArrayFree(_pairs);
   }
   
   //+------------------------------------------------------------------+
   bool IsValid(string symbol, int period, int bar)
   {
      for (int i=0; i < _pairCount; ++i)
      {
         if (_pairs[i]._symbol == symbol)
         {
            return _pairs[i].IsAtSRLevel(period, bar, _pips);
         }
      }
      
      int idx = _pairCount;
      _pairCount++;
      _pairs[idx] = new CSRPair(symbol);
      return _pairs[idx].IsAtSRLevel(period, bar, _pips);
   }
   
   //+------------------------------------------------------------------+
   string PatternName()
   {
      return "SR Filter";
   }
   
   //+------------------------------------------------------------------+
   color PatternColor()
   {
      return clrChartreuse;
   }
   
   //+------------------------------------------------------------------+
   void Draw()
   {
      for (int i=0; i < _pairCount; ++i)
      {
         //Print("p:",i," ", _pairs[i]._symbol);
         if (_pairs[i]._symbol == Symbol())
         {
            //Print("  draw:",i," ", _pairs[i]._symbol);
            _pairs[i].Draw();
         }
      }
   }
};

