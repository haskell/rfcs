======================
RFCs for Haskell Prime
======================


**Before contributing, please read this entire document.**

This repository is used to discuss and keep track of proposals for the next
Haskell standard, in a process known as *Haskell Prime*. It is currently
intended to be used similar to `Rust’s RFCs repo`_.

While the process is open for everyone to participate, contributing entirely new
issues is currently limited to the members of the Core Language Committee.



.. contents:: Table of contents
    :local:
    :backlinks: none



.. _Rust’s RFCs repo: https://github.com/rust-lang/rfcs




-----------
Active RFCs
-----------

1. None so far!



--------------------------------------------
Is this the right place for my contribution?
--------------------------------------------

The key idea of this process is making changes to the Haskell language, as
described in the `Haskell Report`_. Here are some examples of RFCs a user might
want to discuss here:

Good:

- Standardize ``LambdaCase``, a GHC extension to Haskell
- Change Haskell syntax to allow trailing commas
- Change ``Monad`` to have ``Applicative`` as superclass
- Add ``for_`` to `Prelude`

Bad:

- Add a heap data structure to ``containers`` *(not part of
  Haskell-the-language)*
- Impactful, novel language change ideas not tested as an extension for a decent
  amount of time *(this is a standardization process, not research of new
  ideas)*

.. _Haskell Report: https://www.haskell.org/onlinereport/haskell2010/



----------------
Proposal process
----------------

1. For this repo at https://github.com/haskell/rfcs
2. Copy ``0000-template.rst`` to ``texts/0000-GOOD-NAME.rst``; do not assign a
   number yet
3. Fill in the template with your suggestion. Make sure the proposal is as
   well-written as you’d expect the final version of it to be; do not submit
   drafts with essential parts left out for discussion.
4. File a pull request to this repo. *(Do not rebase after this! You’re now
   live.)*
5. The request will be discussed in the comment thread of the pull request, if
   possible. A Core Language Committee member will be pronounced the *Shepherd*,
   and that member is responsible for guiding through the process, making sure
   it is not stalled, and an appropriate timeframe for the discussion is
   maintained.
6. The request ends with the pull request being closed.

.. _Haskell Report Repo: https://github.com/haskell/haskell-report/


Successful proposals
~~~~~~~~~~~~~~~~~~~~

Being successful means that a proposal may be implemented in the Haskell Report.

- The pull request is merged, giving the proposal an ID corresponding to the
  pull request.
- The document is added to the `Active RFCs`_
- The proposal contents are ready to be implemented in the `Haskell Report
  Repo`_.
- No one is appointed responsible for actually implementing the change, in
  particular neither the shepherd nor the author of the proposal.
- Changes to the proposal are now impossble, a new proposal is the place for
  this.

Unsuccessful proposals
~~~~~~~~~~~~~~~~~~~~~~

The proposal is discarded without further action. This does not necessarily mean
its ideas are never going to make it into Haskell, just that at this point it
was decided not to continue the idea further. Example scenarios:

- The change is is inappropriate for the Haskell Prime process
- Substantial changes are required to adapt the proposal, and a fresh start of
  the amended version is a good idea.