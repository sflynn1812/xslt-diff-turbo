# xslt-diff-turbo
Faster implementation of Tree Comparison Algorithm using XSLT 1.0
<code>
A practical example is below. For instance if file a.xml is compared against file b.xml:
a.xml
-------------------------------
<?xml version="1.0" encoding="utf-8" ?>
<a>
  <b>test c</b>
  <c>
    <d>test</d>
  </c>
  <b>test</b>
  <c>
    <d>test</d>
  </c>
  <b>test</b>
  <c>
    <d>test</d>
  </c>
</a>

b.xml
-------------------------------
<?xml version="1.0" encoding="utf-8" ?>
<a>
  <b>test 2</b>
  <c>
    <d>test</d>
  </c>
  <b>test</b>
  <c>
    <d>test</d>
  </c>
  <b>test</b>
  <c>
    <d>test</d>
  </c>
</a>

The output would be as shown below, with the mismatches in a.xml not list in b.xml within tree->mismatch.  The mismatches between b.xml not
not in a.xml under compare->mismatch:
<?xml version="1.0" encoding="utf-8"?>
<root>
  <root>
    <tree>
      <mismatch>
        <a>
          <b>test 2</b>
        </a>
      </mismatch>
      <match>
        <a>
          <c>
            <d>test</d>
          </c>
          <b>test</b>
          <c>
            <d>test</d>
          </c>
          <b>test</b>
          <c>
            <d>test</d>
          </c>
        </a>
      </match>
    </tree>
    <compare>
      <mismatch>
        <a>
          <b>test c</b>
        </a>
      </mismatch>
      <match>
        <a>
          <c>
            <d>test</d>
          </c>
          <b>test</b>
          <c>
            <d>test</d>
          </c>
          <b>test</b>
          <c>
            <d>test</d>
          </c>
        </a>
      </match>
    </compare>
  </root>
</root>

This is a unordered xml comparison, though it is similar to many diff algorithms, this algorithm does not count order differences between
sibling matches as a difference. For instance:
a.xml
<a>
 <c/>
 <d/>
</a>

b.xml
<a>
  <d/>
  <c/>
</a>

The results of comparing these would show no differences therefore it is an unordered algorithm

For larger examples it was benchmarked with 10000 node tree (xml file) compared to another 10000 node tree with 2 known differences the correct output was
discovered in 12 seconds.

Generally speaking this algorithm as with any tree comparison algorithm performance becomes increasingly though slower.
Beyond a million nodes versus a similar million nodes xml file, the performance may be impractically slow.
</code>
