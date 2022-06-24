---
layout: post
author: Graham Higgins
category: project
title:  Notes on “allgaps.dat”
tags: post project feature                   # Tags to relate multiple topics to a post
excerpt: "A description and rationale for the conversion of allgaps.dat spatial formatting to relational database format"
---

## Introduction and summary

The spatially-formatted content of the data contained in the file [allgaps.dat](http://trnicely.net/gaps/allgaps.dat) (maintained and published by Dr. Thomas R. Nicely up to his death in Sept. 2019) is relatively computationally intractable compared to contemporary computational representations. As a preliminary attempt to represent the data in a more structured and more computationally tractable format, the spatially-formatted data has been mapped into a more formal relational database format and a SQLite3 version is offered as an intial example of the result.

The sqlite database is just one formally-structured means of representing the existing informally-structured data that is contained in allgaps.txt.

(To help with reasoning and discussion, a small change in terminology seems advisable; rather than “the database”, it would be more accurate to refer to the list of prime gaps maintained by Dr. Nicely as “the data”.)

In essence, Dr. Nicely was maintaining the data as a rows-and-columns table in a spatial format, with the columns being delimited positionally (c.f. “The measure of the gap is shown in positions 1-9, right justified using leading blanks”) and the rows being delimited by a carriage return character.

### Issues arising from Dr. Nicely’s choice of representation scheme

This representational format suited Dr. Nicely’s own style of working and his model of publishing. However, over time it has become i) unwieldy, as the number of entries ballooned, ii) overloaded, as the size of the data in the cells overflowed the original space allocated and iii) inadequate in that it is unable to embrace the representation of additional related information such as the full expansion of the abbreviations used for discoverers along with necessary associated acknowledgments of contributions of program code.

### Problems arising from the growth of number of entries

Problematic in terms of standardisation of curation and maintenance, the positioning of the measure of the gap is inconsistent, rendering the positional definition incorrect.

> “In these tables, the size or measure of the gap (difference of the bounding primes) is shown in the first column (positions 1-6).”

In the following rendering, the character `^` represents one space.

The entry for line 1 conforms to the description:

         1* CFC Euclid   -300   1.44     1  2
    ^^^^^^
    123456789012345678901234567890123456789012345678901234567890123456789
             1         2         3         4

but the entry for line 96426 does not conform, the measure of the gap occupies positions 1-9:

      6582144  C?P MrtnRaab 2017  13.1829  216841  499973#/30030 - 4509212
    ^^^^^^^^^
    123456789012345678901234567890123456789012345678901234567890123456789
             1         2         3         4

### Problems arising from cell values overflowing the allocated space

Other time-wrought changes in the spatial positioning of the data are not reflected in the rubric. The positioning of the merit data no longer conforms to the description provided by Dr. Nicely:

> “The fifth column (positions 26-32) states a so-called figure of merit for the gap.”

The entry for line 1 conforms to Dr. Nicely’s *intention*, the start position is actually 27, not 26:

         1* CFC Euclid   -300   1.44     1  2
                              ^^^^^^
    123456789012345678901234567890123456789012345678901234567890123456789
             1         2         3         4

but the entry for line 96426 does not conform, the measure of the merit occupies positions 30-37):

      6582144  C?P MrtnRaab 2017  13.1829  216841  499973#/30030 - 4509212
                                 ^^^^^^^^
    123456789012345678901234567890123456789012345678901234567890123456789
             1         2         3         4

It is evident that later additions to the table overflowed the initially-allocated space and that in these later additions, the merit data occupies positions 29-37 (according to Dr. Nicely’s intention, the published list uses the range 30-37).

The spatial formatting is now comprehensively inconsistent with the original description.

### Problems arising from related data having to be represented separately

In order to deference the abbreviations for discoverers, it is necessary to reference a separate spatially-formatted lookup table which is only published in the text of the [“First occurrence prime gaps”](https://web.archive.org/web/20191118035255/http://www.trnicely.net/gaps/gaplist.html) page on the trnicely.net web site (scroll down to the section titled “Abbreviations for Discoverers”.

### Issues of computational tractability

The issue of concern is that Dr. Nicely’s spatially-formatted table is relatively computationally intractable compared with even as basic an approach as a comma-separated table and that this relative intractability imposes an unneccessary technical demand in terms of parsing the informally-structured data.

## Preservation and curation of Dr. Nicely’s contribution

As part of a community program to migrate and curate Dr. Nicely's contribution, the captures of `allgaps.dat` made by the archival organisation [archive.org](https://archive.org) (aka “The Internet Archive”) were downloaded using the following [bash shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script (available from the community repository on Github):

---
```bash
#!/bin/bash

# Retrieve all versions of allgaps.dat captured by archive.org
# listing of captures: https://web.archive.org/web/*/http://www.trnicely.net/gaps/allgaps.dat
# Specifically ...
# https://web.archive.org/web/20160305015919/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20160308084512/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20160404153825/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20160622011044/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20160730000459/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20161030015200/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20181214094452/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20190115012342/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20190216134617/http://www.trnicely.net/gaps/allgaps.dat
# https://web.archive.org/web/20190419210135/http://www.trnicely.net/gaps/allgaps.dat

# Iterate over the known captures, saving each into a separate file
for i in 20160305015919 20160308084512 20160404153825 \
         20160622011044 20160730000459 20161030015200 \
         20181214094452 20190115012342 20190216134617 \
         20190419210135
do
curl -o allgaps-${i}.dat https://web.archive.org/web/${i}/http://www.trnicely.net/gaps/allgaps.dat
done
```

### Publishing the data as comma-separated values

As an initial trial, Dr. Nicely’s informal spatial encoding was replaced by a more formal [comma-separated values](https://en.wikipedia.org/wiki/Comma-separated_values) encoding. This replacement was effected via the following bash shell script:

---
```bash
#!/bin/bash
# Expand informal notation to a more tractable form
for i in allgaps-2*.dat
do
cat ${i} | sed -e 's/  */ /g' \
    -e 's/^ *\(.*\) *$/\1/' \
    -e 's/ - /_-_/g' \
    -e 's/ + /_+_/g' \
    -e 's/\* CFC/,1,C,F,C/g' \
    -e 's/ CFC/,0,C,F,C/g' \
    -e 's/ C?C/,0,C,?,C/g' \
    -e 's/ C??/,0,C,?,?/g' \
    -e 's/ C?P/,0,C,?,P/g' \
    -e 's/ C?P/,0,C,?,P/g' \
    -e 's/ /,/g' \
    -e 's/_-_/ - /g' \
    -e 's/_+_/ + /g' \
    > ${i%%.dat}.csv
done
```

The execution of the script produces a file of lines of comma-separated values representing the data:

---

    1,1,C,F,C,Euclid,-300,1.44,1,2
    ...
    6582144,0,C,?,P,MrtnRaab,2017,13.1829,216841,499973#/30030 - 4509212


#### Close but no cigar

Publishing the data as comma-separated values only addresses some of the problems. Whilst the comma-separated format avoids reliance on brittle spatial positioning, the format is not amenable to representing the related data of unabbreviated names of discoverers and acknowledgements of contribution. To avoid needless repetition in the data rows, related data still has to be maintained in a separate file of comma-separated values and as such represents an additional maintenance/curation task load of keeping the two files in synchrony.

Furthermore one domain-specific feature, that of very long primes more than two hundred thousand digits in size, prohibits the loading of the comma-separated data into standard desktop applications (i.e. spreadsheet applications such as Libre Office Calc) as the cell exceeds the size limits of the application. Purely programmatic manipulation is unaffected by this limitation and is rather well-supported by programming language libraries (such as Python's [sqlite3 package](https://docs.python.org/3/library/sqlite3.html#module-sqlite3)) but without application support, this acts to impose an undesirable technical requirement of some degree of programming skill, directly impacting curators/maintainers.


### Publishing the data as SQL INSERT statements

Usefully, the computational tractability of the data represented as comma-separated values enables the data to be imported into a relational database with trivial effort.

One key advantage of adopting a relational database format to represent the data is that the format is *not* subject to the issue of very long primes overflowing a cell limit. In practice, no special manœuvers are required for a relational database application to import data rendered in (computationally tractable) comma-separated value format.

Many relational database GUI applications (SQLiteBrowser, for example) provide direct GUI support for this via menu selection, typically labelled “Import from CSV” and “Export to CSV”.

The following image illustrates SQLiteBrower’s import and export menu options:

![SQLiteBrowser import from CSV](/img/news/sqlitebrowser-import-export.png)


### Second trial

As a second stab at creating a manageable and sustainable representation of the data, the comma-separated values were imported into SQLite3 (via SQLiteBrowser’s GUI) and exported as SQL (again using the SQLiteBrowser GUI).

Although SQLiteBrowser will straightforwardly import the data as comma-separated values, the resulting inferred data schema (employed by relational databases to characterise the data formally) is of a relatively uninformative generic form. Good practice militates the creation of a domain-specific schema that accurately characterises the data in the context of the domain.

Fortunately, creating an appropriate data schema for `allgaps.dat` is not taxing:

---

```sql
CREATE TABLE IF NOT EXISTS `gaps` (
    `gapsize`       INT,
    `ismax`         BOOLEAN,
    `primecat`      TEXT,
    `isfirst`       TEXT,
    `primecert`     TEXT,
    `discoverer`    TEXT,
    `year`          INT,
    `merit`         REAL,
    `primedigits`   INT,
    `startprime`    BLOB
);
```

(where `BLOB` is an acronym for “Binary Large OBject” and happily accepts very long primes as strings)

The related data of keys to abbreviations, discoverers full names and ackowledgements of contribution is maintained in the same file. As such, the file of SQL INSERT statements and data schema specifications is a standalone representation of all the related data.

#### The exported data remains in plaintext form

As with CSV, SQL acts as a general data transport mechanism effective across applications, operating systems and machine architectures. Exported data is rendered as a text file of SQL INSERT statements which fully preserve the data format and characterisation:

---
```sql
INSERT INTO `gaps` VALUES (1,1,'C','F','C','Euclid',-300,1.44,1,'2');
...
INSERT INTO `gaps` VALUES (6582144,0,'C','?','P','MrtnRaab',2017,13.1829,216841,'499973#/30030 - 4509212');
```

Files of SQL statements act as self-contained databases, rendered in plaintext which can be trivially imported back into relational database applications for marshalling and/or interrogation via SQL statements and/or algebra.

#### Representing change history

Whilst relational database applications are quite capable of representing the historical arc of changes to the data, this involves considerable additional work and demands a relatively high degree of operational familarity, neither of which are appropriate for this particular purpose or group.

The issue of keeping a public record of changes is also pertinent to authors and maintainers of open source software, typically developed in the context of a contributive but distributed community. Many open source groups have exploited the advantages of modern distributed version control solutions (such as git or mercurial) to offload the record-keeping task to the commit history mechanism offered by these solutions.

The generated files of comma-separated values for each version of allgaps.dat captured by archive.org were imported into SQLiteBrowser and then exported as SQL.

The resulting files of SQL INSERT data were commited to a git repository, made [publicly accessible on GitHub](https://github.com/gjhiggins/prime-gap-list). Dates and times of commits preserve (via mimicry) the archive.org date and time of capture:

---
```bash
#!/bin/bash
# Copying SQL INSERT translations of archive.org's preserved versions of allgaps.dat into a git repository.

# Initialise new git repository
git init;
# Commit each dated retrieval as allgaps.sql, using the retrieval date as the commit date.
cp -f allgaps-20160305015919.sql allgaps.sql;
git add allgaps.sql;
WHEN='2016-03-05T01:59:19 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'initial commit 2016-03-05' allgaps.sql
cp -f allgaps-20160308084512.sql allgaps.sql;
WHEN='2016-03-08T08:45:12 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2016-03-08' allgaps.sql
cp -f allgaps-20160404153825.sql allgaps.sql;
WHEN='2016-04-04T15:38:25 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2016-04-04' allgaps.sql
cp -f allgaps-20160622011044.sql allgaps.sql;
WHEN='2016-06-22T01:10:44 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2016-06-22' allgaps.sql
cp -f allgaps-20160730000459.sql allgaps.sql;
WHEN='2016-07-30T00:04:59 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2016-07-30' allgaps.sql
cp -f allgaps-20161030015200.sql allgaps.sql;
WHEN='2016-10-30T01:52:00 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2016-10-30' allgaps.sql
cp -f allgaps-20181214094452.sql allgaps.sql;
WHEN='2018-12-14T09:44:52 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2018-12-14' allgaps.sql
cp -f allgaps-20190115012342.sql allgaps.sql;
WHEN='2019-01-15T01:23:42 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2019-01-15' allgaps.sql
cp -f allgaps-20190216134617.sql allgaps.sql;
WHEN='2019-02-16T13:46:17 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2019-02-16' allgaps.sql
cp -f allgaps-20190319223137.sql allgaps.sql;
WHEN='2019-03-19T22:31:37 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2019-03-19' allgaps.sql
cp -f allgaps-20190419210135.sql allgaps.sql;
WHEN='2019-04-19T21:01:35 -0000' \
GIT_AUTHOR_DATE=${WHEN} GIT_COMMITTER_DATE=${WHEN} git commit -m 'update 2019-04-19' allgaps.sql
# allgaps.dat is now up to date and includes the last changes changes made by Dr Thomas R. Nicely ()
```

#### Illustrations of commit history

---

The commit history maintains a record of each set of changes, here illustrated as presented by Github's web ui:


![Github commit history](/img/news/github-commits.png)

---

The buttons on the right-hand side offer access to more detailed information such as this graphical display of which entries were changed:


![commit history detail](/img/news/git-commit-history.png)


Whilst Github offers a convenient means of centralised storage and of co-ordinating community activity, as a *distributed* version control system, the git repository can also be downloaded and used locally, independently of Github, either via command-line calls or via platorm-native GUI applications such as [gitk](https://git-scm.com/docs/gitk), illustrated below showing the same history information as the Github web UI in the previous image:

![gitk](/img/news/gitk.png)

#### Co-ordinating community contributions

Github excels at supporting open source community co-ordination. Changes to the data, in the form of new entries can be submitted either in the form of "issues" raised by members who do not have commit rights:

![submission via github issue](/img/news/github-issue.png)

Members with commit access can review the issue and if approved, apply the patch to the dataset and commit the change as per normal or, by using Github’s "pull request" facility, shorten the process by simply accepting the pull request:

![submission via github pull request](/img/news/github-pull-request.png)

This latter approach is much favoured by open source maintainers as it spreads the administrative load. Submitters use the Github "fork" (see web gui top right) to create a copy of the repository in their own space on github ([as I have done](https://github.com/DOACC/prime-gap-list), make and commit the changes to the dataset in the copied repository and use the Github web gui to issue a pull request for the changed data which then appears in the main repository as illustrated above.

Typically, users use the Github "Clone or download" button ([prominently featured](https://github.com/gjhiggins/prime-gap-list)) to copy their repository URL and then download the repository, work on it locally, commit the changes to their forked copy on Github and then issue a pull request. This approach enables users to simply update their local copy, commit the changes and repeat the process.

