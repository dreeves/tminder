pi = (s) -> parseInt(s, 10)

# Turn a string like "3pm" or "15:30" into [H,M]
# Idea from http://stackoverflow.com/a/14787410/4234
@parseTime = (time) ->
  pm = time.search(/p/i) != -1      # whether it's PM
  am = time.search(/a/i) != -1      # whether it's AM
  da = time.replace(/[^0-9]/g, '')  # digit array
  nd = da.length                    # number of digits

  if nd==0 or nd>4 or nd==2 and time.search(/:/) != -1 then return [-1, -1]

  if      nd==4       then [h,m] = [pi(da[0]+da[1]),          pi(da[2]+da[3])]
  else if nd==3       then [h,m] = [pi(da[0]),                pi(da[1]+da[2])]
  else if nd in [1,2] then [h,m] = [pi(da[0]+(da[1] or '')),  0              ]

  if not (0 <= m < 60) or h > 29 then return [-1, -1]
  if pm and 0 < h < 12 then h += 12  # make sure it's 24-hour time
  if am and h==12 then h = 0         # 12am means 0:00 (tho 12pm means 12:00)
  [h % 24, m]

# Number of seconds till the given time of day (default midnight)
@pumpkin = (hour=0, minute=0) ->
  d = new Date()
  now = d.getTime()
  d.setHours(hour)
  d.setMinutes(minute)
  d.setSeconds(0)
  x = (d.getTime() - now)/1000
  if x < 0 then x + 86400 else x

# Convert seconds to hours/minutes/seconds, like 65 -> "1m5s" or 3600 -> 1h0m0s
@s2hms = (s) ->
  x = ""
  h = Math.floor(s/3600)
  s %= 3600
  m = Math.floor(s/60)
  s %= 60
  if h > 0                  then x += h+"h"
  if m > 0 or (h>0 and s>0) then x += m+"m"
  if s > 0                  then x += s+"s"
  x

# Convert number of hours to "H:M"
@h2hm = (h) ->
  H = Math.floor(h)
  M = Math.round((h-H)*60)
  H + ":" + (if M<10 then "0"+M else M)
