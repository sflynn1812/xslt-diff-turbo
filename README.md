Truthfully I do not give f()ck what you do with this software.  Use it in software systems to support in totalitarian regimes, make terminator robots and make the planet uninhabitable with pollution.  You are only hurting yourself with such behaviour.
Just promise me one thing.  Do not buy a pickup truck and not use it for any practical hauling.  Like why waste the gasoline (or petrol if you prefer)?  Its just annoying to see someone drive a hemi truck who uses it once a year to take a cooler to the beach.  You are not cool, you look like an 1d01t.




Warning: has edge cases that do not work. New version under construction.

#&nbsp;xslt-diff-turbo

Faster&nbsp;implementation&nbsp;of&nbsp;Tree&nbsp;Comparison&nbsp;Algorithm&nbsp;using&nbsp;XSLT&nbsp;1.0<br/>
A&nbsp;practical&nbsp;example&nbsp;is&nbsp;below.&nbsp;For&nbsp;instance&nbsp;if&nbsp;file&nbsp;a.xml&nbsp;is&nbsp;compared&nbsp;against&nbsp;file&nbsp;b.xml:<br/>
a.xml<br/>
-------------------------------<br/>
&lt;a&gt;<br/>
  &nbsp;&nbsp;&lt;b&gt;<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;b&lt;/b&gt;<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;c&lt;/d&gt;<br/>
  &nbsp;&nbsp;&lt;/b&gt;<br/>
  &nbsp;&nbsp;&lt;d&gt;d&lt;/d&gt;<br/>
  &nbsp;&nbsp;&lt;e&gt;e&lt;/e&gt;<br/>
&nbsp;&nbsp;&lt;/a&gt;<br/>
<br/>
b.xml<br/>
-------------------------------<br/>
&lt;a&gt;<br/>
  &nbsp;&nbsp;&lt;b&gt;<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;b&lt;/b&gt;<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;c&lt;/d&gt;<br/>
  &nbsp;&nbsp;&lt;/b&gt;<br/>
  &nbsp;&nbsp;&lt;d&gt;d&lt;/d&gt;<br/>
  &nbsp;&nbsp;&lt;g&gt;g&lt;/g&gt;<br/>
&lt;/a&gt;<br/>
Results in:<br/>
&lt;?xml version="1.0" encoding="utf-8"?&gt;<br/>
&lt;root&gt;<br/>
  &nbsp;&nbsp;&lt;root&gt;<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&lt;left-not-in-right&gt;<br/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;<br/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;b&lt;/b&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/b&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;<br/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;c&lt;/d&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/b&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;d&lt;/d&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&lt;mismatch&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;g&gt;g&lt;/g&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/mismatch&gt;<br/>
    &lt;/left-not-in-right&gt;<br/>
    &lt;right-not-in-left&gt;<br/>
      &nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;<br/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;b&lt;/b&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/b&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;b&gt;<br/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;c&lt;/d&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/b&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&lt;match&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;d&gt;d&lt;/d&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/match&gt;<br/>
      &nbsp;&nbsp;&lt;mismatch&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;a&gt;<br/>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;e&gt;e&lt;/e&gt;<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/a&gt;<br/>
      &nbsp;&nbsp;&lt;/mismatch&gt;<br/>
    &lt;/right-not-in-left&gt;<br/>
  &lt;/root&gt;<br/>
&lt;/root&gt;<br/>
<br/>
