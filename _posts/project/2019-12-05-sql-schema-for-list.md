---
layout: post
author: Graham Higgins
category: project
title: SQL schema for representing the list of first known occurrence prime gaps
tags: projectdoc
excerpt: Details and rationale of schema creation
---

#### Publication format

The list of first known occurrence gaps is published as a plaintext file of SQL statements `allgaps.sql` which, when read into a SQL-aware application, constructs two relational tables of data: `gaps` and `credits`.

The `gaps` table contains the data previously published by Dr Thomas Ray Nicely as a spatially-formatted plaintext file `allgaps.dat`. Archival versions of this data [remain accessible as captures](https://web.archive.org/web/*/http://www.trnicely.net/gaps/allgaps.dat) courtesy of archive.org’s “Wayback Machine”.

The `credits` table is taken from the one published by Dr. Nicely in a web page “First known occurrence of prime gaps”, [similarly accessible](https://web.archive.org/web/*/http://www.trnicely.net/gaps/gaplist.html) as captured by the “Wayback Machine”. The `credits` table provides a mapping from the abbreviations of names of discoverers used in the `gaps` table to the full details.

##### Database schema for `gaps` table

```sql
CREATE TABLE gaps(
  "gapsize" INTEGER,
  "ismax" BOOLEAN,
  "primecat" TEXT,
  "isfirst" TEXT,
  "primecert" TEXT,
  "discoverer" TEXT,
  "year" INTEGER,
  "merit" REAL,
  "primedigits" INTEGER,
  "startprime" TEXT
);
```

The domain semantics of the data fields are described [in a separate document](/prime-gap-record-data-fields/)

##### Database schema for `credits` table

```sql
CREATE TABLE credits(
  "abbreviation" TEXT,
  "name" TEXT,
  "ack" TEXT,
  "display" TEXT
);
```

In which `abbreviation` is a key to the abbreviations used in `gaps` for discoverers’ names and `name` is the indexed-to string originally published by Dr. Nicely (see below) with the credit acknowledgements (e.g. “(PGS)”, “Computer codes by Tomás Oliveira e Silva.”) separated out into the `ack` field. The `display` field is used for display purposes and is the discoverer’s name(s) plus a shortened form of the credit acknowledgement (e.g. “Robert W. Smith [Dana Jacobsen]”).

**“Abbreviations for Discoverers” as last published by Dr. Thomas Ray Nicely**

    ANair_MF---Anand S. Nair (PGS).
    APinhTOS---Armando Pinho. Computer codes by Tomás Oliveira e Silva.
    A.Walker---Andrew John Walker.
    AEWestrn---A. E. Western.
    Andersen---Jens Kruse Andersen.
    ApplRssr---Kenneth I. Appel and J. Barkley Rosser.
    ATeixTOS---António Teixera. Computer codes by Tomás Oliveira e Silva.
    Be.Nyman---Bertil Nyman.
    Blnchtte---Gilles Blanchette.
    CBastTOS---Carlos Bastos. Computer codes by Tomás Oliveira e Silva.
    CKernTOS---Cristian Kern. Computer codes by Tomás Oliveira e Silva.
    ColeStev---Steve Cole (PGS).
    DanielH.---Daniel Hermle.
    DBghFOH---D.; Baugh and F. O'Hara.
    DHLehmer---Derrick Henry Lehmer.
    DonKnuth---Donald Ervin Knuth.
    Erickson---Eddie Erickson.
    Euclid  ---Euclid.
    Fougeron---Jim Fougeron.
    GABandAR---F. J. Gruenberger, G. Armerding, and C. L. Baker (1959, 1961),
           and independently, Kenneth I. Appel and J. Barkley Rosser (1961).
    Gapcoin----The Gapcoin network,
           a Bitcoin derivative, employs a hashing algorithm which searches
           for prime gaps of high merit. Jonnie Frey, developer.
    Glaisher---J. W. L. Glaisher.
    H.Dubner---Harvey Dubner.
    HrzogTOS---Siegfried "Zig" Herzog. Computer codes by Tomás Oliveira e Silva.
    Jacobsen---Dana Jacobsen, running code using C and Perl.
    JamesFry---James Fry.
    JdeGroot---Jeroen de Groot.
    JFNSTOeS---John Fettig and Nahil Sobh, NCSA. Computer codes by Tomás Oliveira e Silva.
    JLGPardo---Jose Luis Gomez Pardo.
    JRdrgTOS---João Manuel Rodrigues. Computer codes by Tomás Oliveira e Silva.
    K.Conrow---Kenneth Conrow.
    KOGrndln---Kjell-Olav Grøndalen.
    _Kokales---David Kokales. Also contributed deterministic primality proofs.
    LLnhardy---Leif Leonhardy.
    LMorelli---Luigi Morelli (PGS).
    LndrPrkn---L. J. Lander and Thomas R. Parkin.
    M.Jansen---Michiel Jansen.
    MJandJKA---Michiel Jansen and Jens Kruse Andersen.
    MJPCJKA---Michiel; Jansen, Pierre Cami, and Jens Kruse Andersen.
    ML.Brown---Milton L. Brown.
    MrtnRaab---Martin Raab.
    NicelyHD---Thomas R. Nicely. Computer codes inspired by Harvey Dubner's work.
    NoAttrib---Anonymous contributors who do not wish attribution.
    NuuKuosa---Nuutti Kuosa.
    PardiTOS---Silvio Pardi. Computer codes by Tomás Oliveira e Silva.
    PDeGeest---Patrick De Geest.
    PierCami---Pierre Cami.
    Pinho_MF---Carlos Eduardo Leal de Pinho (PGS).
    R.Athale---Rahul Ramesh Athale.
    RFischer---Richard Fischer.
    Ritschel---Thomas Ritschel (PGS).
    RobSmith---Robert W. Smith. Some of Smith's results after 2014 employ
           Perl code written by Dana Jacobsen. Coordinator, PGS.
    Rosnthal---Hans Rosenthal.
    RosntlJA---Hans Rosenthal. Computer codes by Jens Kruse Andersen.
    RosntlJF---Hans Rosenthal. Computer codes by Jim Fougeron.
    RP.Brent---Richard P. Brent.
    Shepherd---Rick L. Shepherd.
    Spielaur---Helmut Spielauer.
    TAlmFMJA---Torbjörn Alm. Computer codes by Jens Kruse Andersen.
               Deterministic primality proofs by François Morain.
    T.Hadley---Thomas Hadley.
    TOeSilva---Tomás Oliveira e Silva.
    Toni_Key---Antonio Key, using Perl codes developed by Dana Jacobsen.
    TorAlmJA---Torbjörn Alm. Computer codes by Jens Kruse Andersen.
    TRNicely---Thomas R. Nicely.
    Weslwski---Arkadiusz Wesołowski.
    Yng&Ptlr---Jeff; Young and Aaron Potler.
    YPPauloR---Jeff Young and Aaron Potler, as reported by Paulo Ribenboim.

This list of discoverers was hand-formatted as SQL statements.

##### A relational database representation of the list of known first occurrence prime gaps

A [SQLite](https://www.sqlite.org/) database is a single disk file. The file format is cross-platform. A database that is created on one machine can be copied and used on a different machine with a different architecture. SQLite databases are portable across 32-bit and 64-bit machines and between big-endian and little-endian architectures.


Each value stored in an SQLite database (or manipulated by the database engine) has one of the following storage classes:

    NULL. The value is a NULL value.

    INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8
             bytes depending on the magnitude of the value.

    REAL. The value is a floating point value, stored as an 8-byte
          IEEE floating point number.

    TEXT. The value is a text string, stored using the database
          encoding (UTF-8, UTF-16BE or UTF-16LE).

    BLOB. The value is a blob of data, stored exactly as it was input.


**Create schema for `gaps` and `credits` tables**

(Lines split for presentation, so not copy’n’pastable as displayed, needs collapsing into one line)

```shell
printf 'CREATE TABLE gaps (
    gapsize INTEGER,
    ismax BOOLEAN,
    primecat TEXT,
    isfirst TEXT,
    primecert TEXT,
    discoverer TEXT,
    year INTEGER,
    merit REAL,
    primedigits INTEGER,
    startprime BLOB
    );\n
    CREATE TABLE credits (
        abbreviation TEXT,
        name TEXT,
        ack TEXT,
        display TEXT
    );\n
    .save allgaps.db\n' | sqlite3
```

---
