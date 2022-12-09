//+------------------------------------------------------------------+
//|                               close_all_positions_and_orders.mq5 |
//|                                                   Ruslan Kadirov |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ruslan Kadirov"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\OrderInfo.mqh>

CPositionInfo a_position;
COrderInfo a_order;
CTrade        a_trade;
CSymbolInfo   a_symbol;


input bool close_all_positions_and_orders = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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

   if(close_all_positions_and_orders == true)
     {
      close_all_positions_and_orders();
     }
   
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
void close_all_positions_and_orders()
  {


    for(int i=PositionsTotal() - 1; i>=0; i--)
    {
       if (a_position.SelectByIndex(i))
       {
              a_trade.PositionClose(a_position.Ticket());
       }
    }
    
    for(int i=OrdersTotal() - 1; i>=0; i--)
    {
       if (a_order.SelectByIndex(i))
       {
              a_trade.OrderDelete(a_order.Ticket());
       }
    }
    
  }





//+------------------------------------------------------------------+