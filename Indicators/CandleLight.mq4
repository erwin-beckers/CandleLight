//+------------------------------------------------------------------+
//|                                                  CandleLight.mq4 |
//|                        Copyright 2017, Erwin Beckers             |
//|                                      https://www.erwinbeckers.nl |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Erwin Beckers"
#property link      "https://www.erwinbeckers.nl"
#property version   "1.00"
#property strict
#property indicator_chart_window

input string __history__               = "------ History ------"; 
input int    MaxBarsHistory            = 100;



#include <Patterns\CPatternDetector.mqh>;

CPatternDetector* _detectD1;
CPatternDetector* _detectH4;

//+------------------------------------------------------------------+
void SendAlert(string period, string pattern )
{
   SendNotification(Symbol() + " " + pattern);
   Alert(Symbol() + " " + pattern);
}


//+------------------------------------------------------------------+
void ClearAll()
{ 
   bool deleted = false;
   do
   {
      deleted = false;
      for(int i = 0;i < ObjectsTotal(0, 0, -1); i++)
      {
        string name = ObjectName(0, i);
        int len = StringLen(name);
        if (StringSubstr(name, len-1, 1) == "_")
        {
            ObjectDelete(0,name);
            deleted = true;
            break;
        }
      }
   } while (deleted);
}


//+------------------------------------------------------------------+
void DrawBar(int bar)
{
   string key="";
   string patternName;
   
   if (!_detectD1.PassesFilter(bar)) return;
   bool isValid = _detectD1.IsValidPattern(bar, patternName);
   if (!isValid) return;
   
   key =key + " " + TimeToStr( Time[bar], TIME_DATE | TIME_MINUTES); 
   key =key + " " + IntegerToString(bar) + "_" ;
   ObjectCreate(0,key,OBJ_RECTANGLE,0, Time[bar], Low[bar],  Time[bar] ,High[bar]);
   ObjectSetInteger(0,key,OBJPROP_COLOR,Yellow);
   ObjectSetInteger(0,key,OBJPROP_BACK,false);
   
   ObjectSetInteger(0,key,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,key,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,key,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,key,OBJPROP_SELECTED,false);
}

//+------------------------------------------------------------------+
int start()
{  
   int secondsleft = Time[0]+Period()*60-TimeCurrent();//-timeshiftsec;
   int d,h,m,s;
   s=secondsleft%60;
   m=((secondsleft-s)/60)%60;
   //h=(secondsleft-s-m*60)/3600;
   h=((secondsleft-s-m*60)/3600)%24;
   d=(secondsleft-s-m*60-h*3600)/86400; //1day=86400sec
   string displaystr;
   // Note, the prefix of spaces below is intentional and necessary to keep the top-middle-anchored text off of Bar[0]!
   if (secondsleft >= 0 && h==0 && d==0) 
   {
      displaystr = StringSubstr(TimeToStr(secondsleft,TIME_MINUTES|TIME_SECONDS),3);
   }
   else if (secondsleft >= 0 && d>0) 
   {
      displaystr = StringConcatenate(d,"_",h,":",StringSubstr(TimeToStr(secondsleft,TIME_MINUTES|TIME_SECONDS),3));
   }
   else if (secondsleft >= 0 && h>0) 
   {
      displaystr = StringConcatenate(h,":",StringSubstr(TimeToStr(secondsleft,TIME_MINUTES|TIME_SECONDS),3));
   }
   else if (h==0 && d==0)
   {
     
      displaystr = StringSubstr(TimeToStr(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3);
   }
   else if (d==0) //h<0
   {
      displaystr = StringConcatenate(-1*h,":",StringSubstr(TimeToStr(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3));
   }
   else //d<0 AND h<0
   {
      displaystr = StringConcatenate(-1*d,"_",-1*h,":",StringSubstr(TimeToStr(-1*secondsleft,TIME_MINUTES|TIME_SECONDS),3));
   }
   
   
   double mult = (Digits==3 || Digits==5) ? 10.0:1.0;
   Comment("Spread:", DoubleToStr(MathAbs(Ask-Bid) / (Point()*mult), 2)+" pips. Next candle in: "+displaystr);
   datetime currentTime = TimeCurrent();
   if (TimeHour(currentTime) != TimeHour(_prevTime))
   {
       refresh = true;
   }
   return 0;
}

//+------------------------------------------------------------------+
void OnTimer()
{
   if (refresh)
   {
     _prevTime = TimeCurrent();
      refresh = false;
      ClearAll();
      int bars = MathMin(MaxBarsHistory, Bars(Symbol(), 0)); 
      for (int bar=1; bar < bars; bar++)
      {
         DrawBar(bar);
      }
   }
}


//+------------------------------------------------------------------+
int init()
{   
   _prevTime = 0;
   refresh=true;
   _detectD1 = new CPatternDetector(PERIOD_D1);
   _detectH4 = new CPatternDetector(PERIOD_H4);
   ClearAll();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void deinit()
{
   delete _detectD1;
   delete _detectH4;
   ClearAll();
}

//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string& sparam)  // Parameter of type string events
{
   if(id == CHARTEVENT_OBJECT_DELETE || id == CHARTEVENT_OBJECT_CREATE || id == CHARTEVENT_OBJECT_DRAG)
   { 
     if (StringSubstr(sparam, 0, 1) != "_")
     {
       refresh = true;
     }
   }
}
