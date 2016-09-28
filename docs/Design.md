Design decisions so far
=======================

DRY as much as possible
-----------------------

Regardless if called by a 1.0 or 2.0 processor the transformation from TEI to HTML should
be that same and be universally useful. On the other hand that means a fix or ammendment
could potentially break sites that use this framework. Tests are crucial here.