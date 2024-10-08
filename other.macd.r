//Other MACD developed by Chris Mody
//Modified by myself in certain areas

//@version=4
study(title="_CM_MacD_Ult_MTF_V2.1", shorttitle="MACD_Daniel'scustom")
//Plot Inputs
res           = input("",  "Indicator TimeFrame", type = input.resolution)
fast_length   = input(title="Fast Length", type=input.integer, defval=13)
slow_length   = input(title="Slow Length", type=input.integer, defval=21)
src           = input(title="Source", type=input.source, defval=close)
signal_length = input(title="Signal Smoothing", type=input.integer, minval = 1, maxval = 50, defval = 8)
sma_source    = input(title="Oscillator MA Type", type=input.string, defval="EMA", options=["SMA", "EMA"])
sma_signal    = input(title="Signal Line MA Type", type=input.string, defval="EMA", options=["SMA", "EMA"])
// Show Plots T/F
show_macd     = input(true, title="Show MACD Lines", group="Show Plots?", inline="SP10")
show_macd_LW  = input(3, minval=0, maxval=5, title = "MACD Width", group="Show Plots?", inline="SP11")
show_signal_LW= input(2, minval=0, maxval=5, title = "Signal Width", group="Show Plots?", inline="SP11")
show_Hist     = input(true, title="Show Histogram", group="Show Plots?", inline="SP20")
show_hist_LW  = input(5, minval=0, maxval=5, title = "-- Width", group="Show Plots?", inline="SP20")
show_trend    = input(true, title = "Show MACD Lines w/ Trend Color", group="Show Plots?", inline="SP30")
show_HB       = input(false, title="Show Highlight Price Bars", group="Show Plots?", inline="SP40")
show_cross    = input(false, title = "Show BackGround on Cross", group="Show Plots?", inline="SP50")
show_dots     = input(true, title = "Show Circle on Cross", group="Show Plots?", inline="SP60")
show_dots_LW  = input(5, minval=0, maxval=5, title = "-- Width", group="Show Plots?", inline="SP60")

//show_trend    = input(true, title = "Colors MACD Lines w/ Trend Color", group="Show Plots?", inline="SP5")
// MACD Lines colors
col_macd      = input(#FF6D00, "MACD Line  ", input.color, group="Color Settings", inline="CS1")
col_signal    = input(#2962FF, "Signal Line  ", input.color, group="Color Settings", inline="CS1")
col_trnd_Up   = input(#4BAF4F, "Trend Up      ", input.color, group="Color Settings", inline="CS2")
col_trnd_Dn   = input(#B71D1C, "Trend Down    ", input.color, group="Color Settings", inline="CS2")
// Histogram Colors
col_grow_above = input(#26A69A, "Above   Grow", input.color, group="Histogram Colors", inline="Hist10")
col_fall_above = input(#B2DFDB, "Fall", input.color, group="Histogram Colors", inline="Hist10")
col_grow_below = input(#FF5252, "Below Grow", input.color, group="Histogram Colors", inline="Hist20")
col_fall_below = input(#FFCDD2, "Fall", input.color, group="Histogram Colors", inline="Hist20")
// Alerts T/F Inputs
alert_Long    = input(true, title = "MACD Cross Up", group = "Alerts", inline="Alert10")
alert_Short   = input(true, title = "MACD Cross Dn", group = "Alerts", inline="Alert10")
alert_Long_A  = input(false, title = "MACD Cross Up & > 0", group = "Alerts", inline="Alert20")
alert_Short_B = input(false, title = "MACD Cross Dn & < 0", group = "Alerts", inline="Alert20")
// Calculating
fast_ma = security(syminfo.tickerid, res, sma_source == "SMA" ? sma(src, fast_length) : ema(src, fast_length))
slow_ma = security(syminfo.tickerid, res, sma_source == "SMA" ? sma(src, slow_length) : ema(src, slow_length))
macd = fast_ma - slow_ma
signal = security(syminfo.tickerid, res, sma_signal == "SMA" ? sma(macd, signal_length) : ema(macd, signal_length))
hist = macd - signal
// MACD Trend and Cross Up/Down conditions
trend_up   = macd > signal
trend_dn   = macd < signal
cross_UP   = signal[1] >= macd[1] and signal < macd
cross_DN   = signal[1] <= macd[1] and signal > macd
cross_UP_A = (signal[1] >= macd[1] and signal < macd) and macd > 0
cross_DN_B = (signal[1] <= macd[1] and signal > macd) and macd < 0
// Condition that changes Color of MACD Line if Show Trend is turned on..
trend_col = show_trend  and trend_up ? col_trnd_Up : trend_up ? col_macd : show_trend  and trend_dn ? col_trnd_Dn: trend_dn ? col_macd : na 

//Var Statements for Histogram Color Change
var bool histA_IsUp = false
var bool histA_IsDown = false
var bool histB_IsDown = false
var bool histB_IsUp = false
histA_IsUp   := hist == hist[1] ? histA_IsUp[1] : hist > hist[1] and hist > 0
histA_IsDown := hist == hist[1] ? histA_IsDown[1] : hist < hist[1] and hist > 0
histB_IsDown := hist == hist[1] ? histB_IsDown[1] : hist < hist[1] and hist <= 0
histB_IsUp   := hist == hist[1] ? histB_IsUp[1] : hist > hist[1] and hist <= 0

hist_col =  histA_IsUp ? col_grow_above : histA_IsDown ? col_fall_above : histB_IsDown ? col_grow_below : histB_IsUp ? col_fall_below :color.silver 

// Plot Statements
//Background Color
bgcolor(show_cross and cross_UP ? col_trnd_Up : na, editable=false)
bgcolor(show_cross and cross_DN ? col_trnd_Dn : na, editable=false)
//Highlight Price Bars
barcolor(show_HB and trend_up ? col_trnd_Up : na, title="Trend Up", offset = 0, editable=false)
barcolor(show_HB and trend_dn ? col_trnd_Dn : na, title="Trend Dn", offset = 0, editable=false)
//Regular Plots
plot(show_Hist and hist ? hist : na, title="Histogram", style=plot.style_columns, color=color.new(hist_col ,0),linewidth=show_hist_LW)
plot(show_macd  and signal ? signal : na, title="Signal", color=color.new(col_signal, 0),  style=plot.style_line ,linewidth=show_signal_LW)
plot(show_macd  and macd ? macd : na, title="MACD", color=color.new(trend_col, 0),  style=plot.style_line ,linewidth=show_macd_LW)
hline(0, title="0 Line", color=color.new(color.gray, 0), linestyle=hline.style_dashed, linewidth=1, editable=false)
plot(show_dots and cross_UP ? macd : na, title="Dots", color=color.new(trend_col ,0), style=plot.style_circles, linewidth=show_dots_LW, editable=false)
plot(show_dots and cross_DN ? macd : na, title="Dots", color=color.new(trend_col ,0), style=plot.style_circles, linewidth=show_dots_LW, editable=false)

//Alerts
if alert_Long and cross_UP
    alert("Symbol = (" + syminfo.tickerid + ") TimeFrame = (" + timeframe.period + ") Current Price (" + tostring(close) + ") MACD Crosses Up.", alert.freq_once_per_bar_close)

if alert_Short and cross_DN
    alert("Symbol = (" + syminfo.tickerid + ") TimeFrame = (" + timeframe.period + ") Current Price (" + tostring(close) + ") MACD Crosses Down.", alert.freq_once_per_bar_close)
//Alerts - Stricter Condition - Only Alerts When MACD Crosses UP & MACD > 0 -- Crosses Down & MACD < 0
if alert_Long_A and cross_UP_A
    alert("Symbol = (" + syminfo.tickerid + ") TimeFrame = (" + timeframe.period + ") Current Price (" + tostring(close) + ") MACD > 0 And Crosses Up.", alert.freq_once_per_bar_close)

if alert_Short_B and cross_DN_B
    alert("Symbol = (" + syminfo.tickerid + ") TimeFrame = (" + timeframe.period + ") Current Price (" + tostring(close) + ") MACD < 0 And Crosses Down.", alert.freq_once_per_bar_close)

//End Code
