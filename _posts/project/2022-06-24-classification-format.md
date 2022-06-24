---
layout: page
title: Modern format for prime gap records
description: Description of the newer format for prime gap record data
author: Michiel Jansen, Seth Troisi
category: project
tags: project
excerpt: An explanation of the gap classification and rationale
---

<style>
  td, th {
    border: 1px solid black;
    padding: 4px
  }
</style>

# Prime Gap Classifications

## Introduction

One of the challenges of the prime gap pages is making sure the submitted gaps are correct.
Ideally there would be a check on the bounding integers: are they prime? And the
intermittent numbers: are they composite? If this double check confirms the submitted gap,
only then would it should be accepted.


In the real world the larger the starting value of the gap the longer and longer the
certification of the bounding integers takes. The current record gap with proven bounding primes
is a gap of 1113106, proving the bounding integers (both with 18,662 digits), are prime took
over 6 weeks with 12 threads. For gaps of this size and larger it's infeasible for the server
to certify the bounding integers let alone the compositeness of the intermittent/interal integers.


The classification of a gap is meant to express the level of certainty has that the gap is valid;
meaning both bounds are prime and there are no intermediate primes. A mix of certification,
verification, spot checking, double check, and trust of submitters forms the basis for this lists
and the classification.

## Level of certainty

There are different levels of certainty the gap entry code can award the gaps that are
submitted. The combinations can be summarized in the following table:

|Bounding integers -> | **Certified** | **Double Checked** | **Trusted discoverer** |
|---|---|---|---|
|If internal gap double-checked | **C**\* | **D**\* | T |
|otherwise | c | **d**\* | t |

\* Only these classifications are regurarly used

Table 1: The levels of certainty of prime gaps

The highest level of certainty is achieved when the bounding integers are certified (e.g. using
ECPP, FastECPP, ECPP-DJ, or Primo and ideally submitted to factordb) and the interal integers are
double checked as composite (e.g. using OpenPfgw, Pari/GP, etc.). If this is the case, a capital
"C" will be used as the classification. In the uncommon situation that the bounding integers are
certified, but no double check has been performed on the internal gap, a lower-case "c" will be
used as the classification.


The majority of the gaps will have PRP performed on the endpoints and either a complete or partial
double check on the internal gap. These will be classified "D" or "d" depending on if the internal
gap was fully double checked.

Very large gaps (think top 20 sized gaps) can take too long to check these will be added with the
lowest classification, lower-case "d" (the server always checks the endpoints) or manually as "t".
If the internal gap is fully checks later, the classification can be upgraded to "D".

## How does the GitHub prime gap page check the gaps?

Prime Gap Records submission page: [https://primegaps.cloudygo.com](https://primegaps.cloudygo.com/)
([code](https://github.com/sethtroisi/prime-gap-record-server/))

For gaps less than <= 100,000 \* the server performs a PRP (probable prime) test using libGMP or
PFGW on the endpoints and on all internal integers (after an aggressive sieving process). These
gaps are marked as having been double checked with a capital "D".

For medium sized gaps (100,000 < gap <= 300,000) only some of the internal integers are
spot-checked and the range is marked as "d".

For gaps > 300,000 the code only checks the bounding integers but requires the discover be trusted.
These gaps are marked "d" and can be upgraded later (see next section).

At this time the server lacks ECPP capability and can't certify endpoints.
[In the future](https://github.com/sethtroisi/prime-gap-record-server/issues/1)
small gaps (think gap <= 5000) will have bounding primes certified prime and all intermittent
integers checked. This is the highest level of certainty that can be achieved and these gaps
would/will be marked with a capital "C".


## How can I upgrade the classification?

For small gaps Seth can manually run Sage's ECPP using
[`script/endpoint_test.sh`](https://github.com/primegap-list-project/prime-gap-list/tree/master/script)

For large gaps (with high merit or that have reached mega-gap status) it's easiest to ask for
formal double check on the
[MersenneForum thread](https://www.mersenneforum.org/showthread.php?t=25313&page=11)
.
