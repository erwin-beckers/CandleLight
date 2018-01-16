//+------------------------------------------------------------------+
//|                                             CPatternDetector.mqh |
//|                                    Copyright 2017, Erwin Beckers |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property strict

input string __pinbar__                = "------ Candle stick patterns ------"; 
input bool   DrawPinBars               = true;
input bool   DrawInsideBars            = true;
input bool   DrawDoubleBarReversal     = true;
input bool   DrawTrippleBarReversal    = false;
input bool   DrawReversalBars          = true;
input bool   DrawFakey                 = true;
input bool   DrawDoji                  = false;
input int    PipsMargin                = 5;

input string __sizefilter__            = "------ Bar size filter ------"; 
input bool   BarSizeFilterEnabled      = false;

input string __hilofilter__            = "------ Swing hi/lo filter ------"; 
input bool   SwingHiLoFilterEnabled    = true;
input int    SwingHighLowBars          = 5;

input string __srfilter__              = "------ Support/Resistance filter ------"; 
input bool   UseSRFilter               = false;
input int    PipsFromSRMargin          = 10;

bool     refresh=false;
datetime _prevTime;

#include <Patterns\CCandleSizeFilter.mqh>;
#include <Patterns\CSwingHiLoFilter.mqh>;
#include <Patterns\CSRFilter.mqh>;

#include <Patterns\CDojiPattern.mqh>;
#include <Patterns\CDoubleReversalPattern.mqh>;
#include <Patterns\CInsideBarPattern.mqh>;
#include <Patterns\CPinbarPattern.mqh>;
#include <Patterns\CTrippleReversalPattern.mqh>;
#include <Patterns\CReversalPattern.mqh>;
#include <Patterns\IPatternDetector.mqh>;
#include <Patterns\CDistributedSRFilter.mqh>;

//+------------------------------------------------------------------+
class CPatternDetector
{
private:
   IPatternDetector*       _patterns[];
   int                     _patternCount;
   
   IPatternDetector*       _filters[];
   int                     _filterCount;
   
   CDistributedSRFilter*   _srFilter;
   
public:   
   //+------------------------------------------------------------------+
   CPatternDetector()
   {
      _patternCount = 0;
      _filterCount  = 0;
      
      ArrayResize(_patterns, 20);
      _patterns[_patternCount++] = new CReversalPattern();
      _patterns[_patternCount++] = new CTrippleReversalPattern(PipsMargin);
      _patterns[_patternCount++] = new CDoubleReversalPattern(PipsMargin);
      _patterns[_patternCount++] = new CPinbarPattern();
      _patterns[_patternCount++] = new CInsideBarPattern();
      _patterns[_patternCount++] = new CDojiPattern();
      
      _srFilter = new CDistributedSRFilter(PipsFromSRMargin); 
      ArrayResize(_filters, 20);
      if (BarSizeFilterEnabled) _filters[_filterCount++] = new CCandleSizeFilter();
      if (SwingHiLoFilterEnabled) _filters[_filterCount++] = new CSwingHiLoFilter(SwingHighLowBars);
      if (UseSRFilter) _filters[_filterCount++] = _srFilter;
   }
   
   //+------------------------------------------------------------------+
   ~CPatternDetector()
   {
      for (int i=0; i < _patternCount; ++i)
      {
         delete _patterns[i];
      }
      ArrayFree (_patterns);
      
      for (int i=0; i < _filterCount; ++i)
      {
         delete _filters[i];
      }
      ArrayFree (_filters);
      
      delete _srFilter;
   }
   
   //+------------------------------------------------------------------+
   bool PassesFilter(string symbol, int period, int bar)
   {
      for (int i=0; i < _filterCount; ++i)
      {
         if (! _filters[i].IsValid(symbol, period, bar)) return false;
      }
      return true;
   }
   
   //+------------------------------------------------------------------+
   bool IsValidPattern(string symbol, int period, int bar, string& patternName)
   {
      for (int i=0; i < _patternCount; ++i)
      {
         if ( _patterns[i].IsValid(symbol, period, bar) ) 
         {
            patternName = _patterns[i].PatternName();
            return true;
         }
      }
      return false;
   }
   
   //+------------------------------------------------------------------+
   void DrawSR()
   {
      _srFilter.Draw();
   }
};

