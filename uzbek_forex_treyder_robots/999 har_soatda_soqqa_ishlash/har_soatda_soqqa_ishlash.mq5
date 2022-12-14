

#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\OrderInfo.mqh>

CPositionInfo a_position;
COrderInfo a_order;
CTrade        a_trade;
CSymbolInfo   a_symbol;

datetime  current_bar_open_time = 0;
input string           MagicNumber      = "har_soatda";

double oldingi_positsiya_max = 0;
double oldingi_positsiya_min = 0;
double oldingi_positsiya_open = 0;
double oldingi_positsiya_close = 0;
string oldingi_positsiya_yonalishi = "";

input double          lot             = 1; 
input double          foyda_foizda     = 111;
double          foyda_foizda_not_input     = 0;
int trail_stop_1_ishga_tushdi = 0;
double          trail_stop     = 0;
input double          trail_stop_foizi     = 70;
input int stop_0_trade_1 = 0;
input double order_quyish_mumkin_bulgan_marja = 30;
input int close_immediately_1 = 0;

datetime position_open_time = 0;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
         if (!a_symbol.Name(Symbol()))
      return(INIT_FAILED);
      
   RefreshRates();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
//---

      if (!RefreshRates())
      return;


      int position_count = PosCount();


      current_bar_open_time = iTime(NULL, PERIOD_H1, 0);
      
      oldingi_positsiya_max = iHigh(NULL, PERIOD_H1,1);
      oldingi_positsiya_min = iLow(NULL, PERIOD_H1,1);
      oldingi_positsiya_open = iOpen(NULL, PERIOD_H1,1);
      oldingi_positsiya_close = iClose(NULL, PERIOD_H1,1);
      
      if(oldingi_positsiya_open>=oldingi_positsiya_close)
      {
         oldingi_positsiya_yonalishi="down";
      }
      else
        {
           oldingi_positsiya_yonalishi="up";
        }



      if(position_count==1)
      {
         //ochiq positsiya bor
         
         //очиқ позиция ҳозирги свечада очилганми ёки олдингида очилганми?
         if(position_open_time<current_bar_open_time)
           {
              //олдинги свечада очилган. Ёпамиз. 
              close_all_positions_and_orders();
           }
         
    
      }
      else
      {
         //ochiq positsiya yo`q
         if(oldingi_positsiya_yonalishi=="up" && oldingi_positsiya_close<a_symbol.Bid())
         {
            //open buy
            a_trade.Buy(lot, NULL, 0, 0,0,MagicNumber);
         }
         
         if(oldingi_positsiya_yonalishi=="down" && oldingi_positsiya_close>a_symbol.Bid())
         {
            //open buy
            a_trade.Sell(lot, NULL, 0, 0,0,MagicNumber);
         }
     
      }
      

      
      a_symbol.Bid();

      Comment(
      "bar oper time: ", current_bar_open_time, "\n",
      "position_count: ",position_count,"\n",
      "oldingi_positsiya_max: ",oldingi_positsiya_max,"\n",
      "oldingi_positsiya_min: ",oldingi_positsiya_min,"\n",
      "oldingi_positsiya_open: ",oldingi_positsiya_open,"\n",
      "oldingi_positsiya_close: ",oldingi_positsiya_close,"\n",
      "oldingi_positsiya_yonalishi: ",oldingi_positsiya_yonalishi,"\n",
      "current price: ",a_symbol.Bid(),"\n"
      );

      //Print("hi tick.");

   }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
int PosCount()
{
   int count = 0;
   for (int i = PositionsTotal()-1; i>=0; i--)
   {
       if (a_position.SelectByIndex(i))
       {
           if (a_position.Symbol() == a_symbol.Name() && a_position.Comment() == MagicNumber)
           //if (a_position.Symbol() == a_symbol.Name())
           position_open_time=a_position.Time();
              count++;
       }
   }
   
   return(count);
}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool RefreshRates()
{
   if (!a_symbol.RefreshRates())
   {
      Print("не удалось обновить котировки валютной пары!");
      return(false);
   } 
   
   if (a_symbol.Ask() == 0 || a_symbol.Bid() == 0)
      return(false);
      
   return(true);   
}
//+------------------------------------------------------------------+


void close_all_positions_and_orders()
  {


    for(int i=PositionsTotal() - 1; i>=0; i--)
    {
       if (a_position.SelectByIndex(i))
       {
           if (a_position.Comment() == MagicNumber && a_position.Symbol() == a_symbol.Name())
           //if (a_position.Symbol() == a_symbol.Name())
              a_trade.PositionClose(a_position.Ticket());
              //Print("posittion comment: " + a_position.Comment());
       }
    }
    
    for(int i=OrdersTotal() - 1; i>=0; i--)
    {
       if (a_order.SelectByIndex(i))
       {
           if (a_order.Comment() == MagicNumber && a_order.Symbol() == a_symbol.Name())
           //if (a_order.Symbol() == a_symbol.Name())
              a_trade.OrderDelete(a_order.Ticket());
              //Print("order comment: " + a_order.Comment());
       }
    }
     
     trail_stop_1_ishga_tushdi = 0;
     trail_stop =0;
     
     position_open_time=0;
    
  }
  
//+------------------------------------------------------------------+  
  
 