- Feature Name: Complete the relaxed dependency analysis, a.k.a. ``-XRelaxedPolyRec``
- Start Date: 2017-06-18
- RFC PR: Leave this empty, filled on proposal accept
- Haskell Report Issue: Leave this empty, filled on proposal accept



#######
Summary
#######

The `RelaxedDependencyAnalysis proposal <https://prime.haskell.org/wiki/RelaxedDependencyAnalysis>`_ that got adopted
into Haskell 2010 is only a half of GHC's ``-XRelaxedPolyRec`` language extension. This proposal is to adopt the rest of
the extension and make it Haskell's official type-checking algorithm.


##########
Motivation
##########

The only effect of the change would be to make more Haskell programs compile, with no negative consequences I can think
of. Furthermore, the ``-XRelaxedPolyRec`` extension has been thoroughly tested: it is implicitly activated by the widely
used ``-XScopedTypeVariables`` extension. If the present proposal is accepted, the feature pragma can be dropped from
the list of encouraged extensions in `section 12.3 of the language report
<https://www.haskell.org/onlinereport/haskell2010/haskellch12.html#x19-19100012.3>`_.


###############
Detailed design
###############

Section 4.5.2 of the Haskell 98 report describes the algorithm for type checking and inference of let bindings. In a
sentence: every syntactic group of ``let`` bindings is broken up in a list of subgroups of mutually recursive bindings
by dependency order, then the types of each subgroup are inferred in order, then some restrictions are imposed.

Section *11.6.3 Combined Binding Groups* of [MarkJones1999] identified several problems with this section of the Haskell
98 report:

1. the algorithm description is vague and gave rise to inconsistent implementations,
2. no distinction is made for bindings with explicit type signature, and
3. the last sentence of the section imposes an unnecessary constraint on the explicit contexts of mutually recursive
   bindings.

Neither this proposal nor the already adopted `RelaxedDependencyAnalysis proposal
<https://prime.haskell.org/wiki/RelaxedDependencyAnalysis>`_ aim to completely fix the first problem. This would require
a formal specification of the algorihm, which might constrain the implementations too tightly. This task is better left
to papers like [MarkJones1999].

The second problem has already been fixed by the RelaxedDependencyAnalysis proposal in Haskell 2010. The present
proposal is solely about the last problem, and the fix is to simply remove the last sentence of section 4.5.2:

     If the programmer supplies explicit type signatures for more than one variable in a declaration group, the contexts
     of these signatures must be identical up to renaming of the type variables.

As it happens, one language extension from the list of Haskell 2010 `encouraged language extensions
<https://www.haskell.org/onlinereport/haskell2010/haskellch12.html#x19-19100012.3>`_, namely `-XRelaxedPolyRec
<https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#generalised-typing-of-mutually-recursive-bindings>`_
in GHC has two effects on the language semantics which exactly correspond to issues #2 and #3 above. If this proposal is
accepted, therefore, the ``-XRelaxedPolyRec`` behaviour would become the default and the extension could then be removed
from the list.

#########
Drawbacks
#########

None whatsoever.


############
Alternatives
############

There may be other algorithms proposed for dealing with let binding groups. This is the one implemented by GHC and
tested by user code.



####################
Unresolved questions
####################


None in my mind.

.. [MarkJones1999] Jones, Mark P. *Typing haskell in haskell.* Haskell workshop. Vol. 7. 1999.
