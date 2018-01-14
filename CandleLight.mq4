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
bool DoesCrossSRLine(int bar)
{
   double mult = 1;
   if (Digits ==3 || Digits==5) mult = 10;
   double pips = PipsFromSRMargin * mult * Point();
   
   for (int i=0;i < ObjectsTotal(0, 0, -1); i++)
   {
      string name  = ObjectName(0, i); 
      if (ObjectType(name) == OBJ_HLINE)
      {
         double srPrice = ObjectGetDouble(0, name, OBJPROP_PRICE,0); 
         
         if (Low[bar] - pips <= srPrice)
         {
           if (High[bar] + pips  >= srPrice) return true;
         }
         if (High[bar] + pips >= srPrice)
         {
           if (Low[bar] - pips  <= srPrice) return true;
         }
      }
      else if (ObjectType(name) == OBJ_TREND)
      {
         datetime time1  = (datetime)ObjectGet(name, OBJPROP_TIME1); 
         datetime time2  = (datetime)ObjectGet(name, OBJPROP_TIME2); 
         if (time1 > time2){
            datetime dum = time1;
            time1 = time2;
            time2 = dum;
         }
         if (Time[bar] > time1 && Time[bar] <= time2)
         {
            double priceAtTrendline = ObjectGetValueByShift(name, bar);
            if (Low[bar] < priceAtTrendline && High[bar] >= priceAtTrendline)
            {  
               return true;
            }
         }
      } 
   }
   
   return false;
}

//+------------------------------------------------------------------+
bool IsUp(int bar)
{
  return Close[bar] >= Open[bar];
}

//+------------------------------------------------------------------+
double UpperWick(int bar)
{
   double upperBody = MathMax(Close[bar], Open[bar]);
   return High[bar] - upperBody;
}

//+------------------------------------------------------------------+
double LowerWick(int bar)
{
   double lowerBody = MathMin(Close[bar], Open[bar]);
   return lowerBody - Low[bar];
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
       if (High[bar+i] < High[bar]) cnt++;
       else break;
     }
     else
     {
       if (Low[bar+i] > Low[bar]) cnt++;
       else break;
     }
  }
  
  return cnt;
}

//+------------------------------------------------------------------+
bool IsLargeCandle(int bar)
{
   double body = MathAbs(Close[bar] - Open[bar]);
   
   double cnt     = 0;
   double barSize = 0;
   for (int i=1; i < 30;++i)
   {
      barSize += MathAbs(Close[bar+1] - Open[bar+1]);
      cnt++;
   }
   double avgBarSize = barSize / cnt;
   return (body >= avgBarSize);
}

//+------------------------------------------------------------------+
bool HiLoFilter(int bar)
{
   int space = SpaceLeft(bar);
   return space >= SwingHighLowBars;
}

//+------------------------------------------------------------------+
bool SizeFilter(int bar)
{
   double body = MathAbs(Close[bar] - Open[bar]);
   
   double cnt     = 0;
   double barSize = 0;
   for (int i=1; i < 30;++i)
   {
      barSize += MathAbs(Close[bar+1] - Open[bar+1]);
      cnt++;
   }
   double avgBarSize = barSize / cnt;
   return (body >= avgBarSize);
}

//+------------------------------------------------------------------+
bool IsDoubleReversal(int bar)
{
   bool isUp1 = IsUp(bar);
   bool isUp2 = IsUp(bar+1);
   if (isUp1 == isUp2) return false;
   double mult = 1;
   if (Digits ==3 || Digits==5) mult = 10;
   double pips = PipsMargin * mult * Point();
   
   if (isUp2)
   {
      if ( Low[bar]< Low[bar+1] && High[bar]+pips > High[bar+1]) return true;
   }
   else
   {
      if ( High[bar] > High[bar+1] && Low[bar]-pips < Low[bar+1]) return true;
   }
   return false;
}
//+------------------------------------------------------------------+
bool IsTrippleReversal(int bar)
{
   bool isUp1 = IsUp(bar);
   bool isUp2 = IsUp(bar+1);
   bool isUp3 = IsUp(bar+2);
   if (isUp1 == isUp2 && isUp2 != isUp3)
   {
      double mult = 1;
      if (Digits ==3 || Digits==5) mult = 10;
      double pips = PipsMargin * mult * Point();
      
      if (isUp3)
      {
         if ( Low[bar]< Low[bar+2] && High[bar+1] + pips > High[bar+2]) return true;
      }
      else
      {
         if ( High[bar] > High[bar+2] && Low[bar] - pips < Low[bar+2]) return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsPinBar(int bar)
{
   double body      = MathAbs(Close[bar] - Open[bar]);
   double lowerWick = LowerWick(bar);
   double upperWick = UpperWick(bar);
   double range     = High[bar] - Low[bar];
   double tail      = MathMax(lowerWick, upperWick);
   double nose      = MathMin(lowerWick, upperWick); 
   // The body of a pin bar must be no more than 20% of the measurement of the body to the tip of the wick
    
   //if ( (nose / tail) >= 0.4) return false; // doji
   
  if (upperWick >= 2 * body || lowerWick >= 2 * body)  
   {
     if (tail > 2 * nose)
      {
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsDoji(int bar)
{
   double body      = MathAbs(Close[bar] - Open[bar]);
   double lowerWick = LowerWick(bar);
   double upperWick = UpperWick(bar);
   double range     = High[bar] - Low[bar];
   double tail      = MathMax(lowerWick, upperWick);
   double nose      = MathMin(lowerWick, upperWick); 
   
   if (upperWick >= 2*body || lowerWick >= 2*body)  
   {
      if ( (nose / tail) >= 0.4)
      {
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsInsideBar(int bar)
{
   return (Low[bar+1] < Low[bar] && High[bar+1] > High[bar]);
   
}

//+------------------------------------------------------------------+
bool IsReversalBar(int bar)
{
   if (IsUp(bar) && !IsUp(bar+1))
   {
      double bodySize = MathAbs(Open[bar+1] - Close[bar+1]);
      double half = Close[bar+1] + bodySize * 0.5;
      if (Close[bar] > half)
      {
         if (Low[bar] < Low[bar+1])
         {
            return true;
         }
      }
   }
   else if (!IsUp(bar) && IsUp(bar+1))
   {
      double bodySize = MathAbs(Open[bar+1] - Close[bar+1]);
      double half     = Close[bar+1] - bodySize * 0.5;
      if (Close[bar] < half)
      {
         if (High[bar] > High[bar+1])
         {
            return true;
         }
      }
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsFakeyPinbar(int bar)
{
   if (IsPinBar(bar+2)) return false;
   if (IsPinBar(bar+1)) return false;
   if (IsInsideBar(bar+1))
   {
      if (IsPinBar(bar))
      {
         bool isUp2 = IsUp(bar+2);
         bool isUp1 = IsUp(bar+1);
         bool isUp0 = IsUp(bar);
         
         if (isUp2 != isUp1 && isUp0 == isUp2)
         {      
            if (Low[bar] < Low[bar+2]) 
            {
               if (High[bar] < High[bar+1])
               {
                  return true;
               }
            }
            else if (High[bar] > High[bar+2])
            {
               if (Low[bar] > Low[bar+1])
               {
                  return true;
               }
            }
         }  
       }
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsFakeyTwoBars(int bar)
{
   if (IsPinBar(bar+3)) return false;
   if (IsPinBar(bar+2)) return false;
   if (IsPinBar(bar+1)) return false;
   if (IsPinBar(bar)) return false;
   
   if (IsInsideBar(bar+2))
   {
      bool isUp3 = IsUp(bar+2);
      bool isUp2 = IsUp(bar+2);
      bool isUp1 = IsUp(bar+1);
      bool isUp0 = IsUp(bar);
      if (isUp3 == isUp0 && isUp2 == isUp1)
      {
         if (High[bar+1] < High[bar+2] && High[bar+1] < High[bar+3])
         {
            if ( Low[bar] > High[bar+1] && High[bar] > High[bar+1])
            {
               Print("found fakey ",bar," ", Time[bar]);
               return true;
            }
         }
         
         if (High[bar+1] > High[bar+2] && High[bar+1] > High[bar+3])
         {
            if ( High[bar] < High[bar+1] && High[bar] < High[bar+1])
            {
               Print("found fakey ",bar," ", Time[bar]);
               return true;
            }
         }
      }
   }
   return false;
}

//+------------------------------------------------------------------+
void OnBar(int bar)
{
   string key="";
   int  width=1;
   
   bool isDoji           = DrawDoji && IsDoji(bar);
   bool isPinBar         = DrawPinBars && IsPinBar(bar);
   bool isInsideBar      = DrawInsideBars && IsInsideBar(bar);
   bool isDoubleReversal = DrawDoubleBarReversal && IsDoubleReversal(bar);
   bool isTrippleReversal= DrawTrippleBarReversal && IsTrippleReversal(bar);
   bool isFakeyPinbar    = DrawFakey && IsFakeyPinbar(bar);
   bool isFakeyTwoBars   = DrawFakey && IsFakeyTwoBars(bar);
   bool isReversalBar    = DrawReversalBars && IsReversalBar(bar);
   bool crossedSR        = DoesCrossSRLine(bar);
   
   if (!isPinBar && !isInsideBar && !isDoubleReversal && !isFakeyPinbar && !isFakeyTwoBars && !isDoji && !isTrippleReversal && !isReversalBar) 
   {
     return;
   }
   
   color clr=Yellow;
   if (isInsideBar) 
   {
      clr = clrChartreuse;
      key += " Inside bar";
   }
   else if (isPinBar) 
   {
      clr = Yellow;
      key += " Pinbar";
      if (BarSizeFilterEnabled && !SizeFilter(bar))
      {
         return;
      }
      if (SwingHiLoFilterEnabled && !HiLoFilter(bar))
      {
         return;
      }
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   } 
   else if (isDoji) 
   {
      clr = clrDarkSalmon;
      key += " Doji bar";
   }
   else if (isTrippleReversal)
   {
      clr = clrGold;
      key += " 3 bar Reversal";
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   }
   else if (isDoubleReversal)
   {
      clr = clrGold;
      key += " 2 bar Reversal";
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   }
   else if (isFakeyPinbar)
   {
      key += " Fakey (Pinbar)";
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   }
   else if (isFakeyTwoBars)
   {
      key += " Fakey (Two bars)";
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   }
   else if (isReversalBar) 
   {
      clr = Yellow;
      key += " Reversal";
      if (BarSizeFilterEnabled && !SizeFilter(bar))
      {
         return;
      }
      if (SwingHiLoFilterEnabled && !HiLoFilter(bar))
      {
         return;
      }
      if (UseSRFilter && !crossedSR)
      {
         return;
      }
   } 
   else 
   {
      clr = clrAliceBlue;
      key += " S/R cross";
   }
   
   key =key + " " + TimeToStr( Time[bar], TIME_DATE | TIME_MINUTES); 
   key =key + " " + IntegerToString(bar) + "_" ;
   if (crossedSR) width=2;
   
   if (isDoubleReversal)
   {
      double l=MathMin(Low[bar] , Low[bar+1]);
      double h=MathMax(High[bar], High[bar+1]);
      ObjectCreate(0,key,OBJ_RECTANGLE,0, Time[bar+1],l,Time[bar],h);
      ObjectSetInteger(0,key,OBJPROP_COLOR,clrBurlyWood);
      ObjectSetInteger(0,key,OBJPROP_BACK,true);
   }
   else if (isFakeyPinbar || isTrippleReversal)
   {
      double l=MathMin(MathMin(Low[bar] , Low[bar+1]) ,Low[bar+2]);
      double h=MathMax(MathMax(High[bar], High[bar+1]),High[bar+2]); 
      ObjectCreate(0,key,OBJ_RECTANGLE,0, Time[bar+2],l,Time[bar],h);
      ObjectSetInteger(0,key,OBJPROP_COLOR,clrPowderBlue);
      ObjectSetInteger(0,key,OBJPROP_BACK,true);
   }
   else if (isFakeyTwoBars)
   {
      double l=MathMin(MathMin(MathMin(Low[bar] , Low[bar+1]) ,Low[bar+2]) ,Low[bar+3]);
      double h=MathMax(MathMax(MathMax(High[bar], High[bar+1]),High[bar+2]),High[bar+3]);
      ObjectCreate(0,key,OBJ_RECTANGLE,0, Time[bar+3],l,Time[bar],h);
      ObjectSetInteger(0,key,OBJPROP_COLOR,clrPowderBlue);
      ObjectSetInteger(0,key,OBJPROP_BACK,true);
   }
   else
   {
      ObjectCreate(0,key,OBJ_RECTANGLE,0, Time[bar],Low[bar],Time[bar],High[bar]);
      ObjectSetInteger(0,key,OBJPROP_COLOR,clr);
      ObjectSetInteger(0,key,OBJPROP_BACK,false);
   }
   ObjectSetInteger(0,key,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,key,OBJPROP_WIDTH,width);
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
      Print("candle light refresh ", bars);
      for (int bar=1; bar < bars; bar++)
      {
        OnBar(bar);
      }
   }
}


//+------------------------------------------------------------------+
int init()
{   
   _prevTime = 0;
   refresh=true;
   ClearAll();
   EventSetTimer(5);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void deinit()
{
   ClearAll();
}

//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string& sparam)  // Parameter of type string events
{
   if(id==CHARTEVENT_OBJECT_DELETE || id==CHARTEVENT_OBJECT_CREATE || id==CHARTEVENT_OBJECT_DRAG)
   { 
     if (StringSubstr(sparam, 0, 1) != "_")
     {
       refresh=true;
     }
   }
}
