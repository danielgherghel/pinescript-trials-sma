// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © dagherghel

//@version=4
study("MACD")
fast = 12, slow=26
fastMA= ema(close, fast)
slowMA= ema(close, slow)
macd = fastMA - slowMA
signal = sma(macd, 9)
plot(macd, color=color.green)
plot(signal, color=color.red)

//create a macd signal with distance between the lines as confirmation
