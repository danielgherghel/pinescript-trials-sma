Created a custom rsi with a line at 50
Then colored at overbought and oversold

//@version=4
//d91gherghel
study(title="Relative Strength Index", shorttitle="RSI", format=format.price, precision=2, resolution="")
len = input(13, minval=1,title="Length")
src = input(close, "Source", type = input.source)
up = rma(max(change(src), 0), len)
down = rma(-min(change(src), 0), len)
rsi = down == 0 ? 100 : up == 0 ? 0 : 100 - (100 / (1 + up / down))
oversold = rsi <21
overbought = rsi > 89
barcolor(oversold? #7fff00 : overbought? color.red : na)
// rsiOverbought = input(title="Rsi Overbought", type=input.integer, defval=80)
// rsiOversold = input (title="Rsi Oversold", type=input.integer, defval=20)
// EROB = rsi >= rsiOverbought
// EROS = rsi <= rsiOversold
// trdown = rsi >= 50
// plotshape(EROB, title="Overbought", location=location.top, color=color.red, transp=0, style=shape.triangledown)
// plotshape(EROS, title="Oversold", location=location.bottom, color=color.green, transp=0, style=shape.triangleup)
l80 = input(title= "rsi oversold", type=input.integer, defval=75)
l80_rsi = rsi > l80 ? rsi : l80
l20 = input(title= "rsi overbought", type=input.integer, defval=30)
l20_rsi = rsi < l20 ? rsi : l20

p1 = plot(series=l80, color = color.red, linewidth=1, transp=100)
p2 = plot(series=l80_rsi, color=color.red, linewidth=1, transp=100)
p3 = plot(series=l20, color=color.green, linewidth =1, transp=100)
p4 = plot(series=l20_rsi, color=color.green, linewidth=1, transp=100)

plot(rsi, "RSI", color=#00eaff)
band1 = hline(70, "Upper Band", color=#FF0000)
bandm = hline(50, "Middle Band",linestyle=hline.style_dashed, linewidth=2, color=#ffee00)
band0 = hline(14, "Lower Band", color=#00FF00)
// plotshape.delete(plotshape[1])
fill(band1, band0, color=#b3e8b3, transp=95, title="Background")
fill(p1, p2, color=color.red, transp=20)
fill(p3,p4, color=color.green, transp=20)
