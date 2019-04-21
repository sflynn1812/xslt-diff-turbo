# xslt-diff-turbo
Faster implementation of Tree Comparison Algorithm using XSLT 1.0<br/>
A practical example is below. For instance if file a.xml is compared against file b.xml:<br/>
a.xml<br/>
-------------------------------<br/>
&lt;?xml version="1.0" encoding="utf-8" ?&gt;<br/>
&lt;a&gt;<br/>
  &lt;b&gt;test c&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
  &lt;b&gt;test&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
  &lt;b&gt;test&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
&lt;/a&gt;<br/>
<br/>
b.xml<br/>
-------------------------------<br/>
&lt;?xml version="1.0" encoding="utf-8" ?&gt;<br/>
&lt;a&gt;<br/>
  &lt;b&gt;test 2&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
  &lt;b&gt;test&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
  &lt;b&gt;test&lt;/b&gt;<br/>
  &lt;c&gt;<br/>
    &lt;d&gt;test&lt;/d&gt;<br/>
  &lt;/c&gt;<br/>
&lt;/a&gt;<br/>

The output would be as shown below, with the mismatches in a.xml not list in b.xml within tree-&gt;mismatch.  The mismatches between b.xml not<br/>
not in a.xml under compare-&gt;mismatch:<br/>
&lt;?xml version="1.0" encoding="utf-8"?&gt;<br/>
&lt;root&gt;<br/>
  &lt;root&gt;<br/>
    &lt;tree&gt;<br/>
      &lt;mismatch&gt;<br/>
        &lt;a&gt;<br/>
          &lt;b&gt;test 2&lt;/b&gt;<br/>
        &lt;/a&gt;<br/>
      &lt;/mismatch&gt;<br/>
      &lt;match&gt;<br/>
        &lt;a&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
          &lt;b&gt;test&lt;/b&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
          &lt;b&gt;test&lt;/b&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
        &lt;/a&gt;<br/>
      &lt;/match&gt;<br/>
    &lt;/tree&gt;<br/>
    &lt;compare&gt;<br/>
      &lt;mismatch&gt;<br/>
        &lt;a&gt;<br/>
          &lt;b&gt;test c&lt;/b&gt;<br/>
        &lt;/a&gt;<br/>
      &lt;/mismatch&gt;<br/>
      &lt;match&gt;<br/>
        &lt;a&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
          &lt;b&gt;test&lt;/b&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
          &lt;b&gt;test&lt;/b&gt;<br/>
          &lt;c&gt;<br/>
            &lt;d&gt;test&lt;/d&gt;<br/>
          &lt;/c&gt;<br/>
        &lt;/a&gt;<br/>
      &lt;/match&gt;<br/>
    &lt;/compare&gt;<br/>
  &lt;/root&gt;<br/>
&lt;/root&gt;<br/>
<br/>
This is a unordered xml comparison, though it is similar to many diff algorithms, this algorithm does not count order differences between<br/>
sibling matches as a difference. For instance:<br/>
a.xml<br/>
&lt;a&gt;<br/>
 &lt;c/&gt;<br/>
 &lt;d/&gt;<br/>
&lt;/a&gt;<br/>
<br/>
b.xml<br/>
&lt;a&gt;<br/>
  &lt;d/&gt;<br/>
  &lt;c/&gt;<br/>
&lt;/a&gt;<br/>
<br/>
The results of comparing these would show no differences therefore it is an unordered algorithm<br/>
<br/>
For larger examples it was benchmarked with 10000 node tree (xml file) compared to another 10000 node tree with 2 known differences the correct output was<br/>
discovered in 12 seconds.<br/>
<br/>
Generally speaking this algorithm as with any tree comparison algorithm performance becomes increasingly though slower.<br/>
Beyond a million nodes versus a similar million nodes xml file, the performance may be impractically slow.<br/>
