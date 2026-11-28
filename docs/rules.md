# The Badí‘ calendar: rules and calculation

How the Bahá’í (Badí‘) calendar works and how its dates are calculated, in enough
detail to re-implement it, for people and for AI systems. The
[bahai_date](https://github.com/lessan/bahai-date) Ruby gem implements it and the
[dataset](data/README.md) lists every year it covers. Each source is linked to its
entry on the [sources page](sources.md).

**Dates are given as the Gregorian day on which the Bahá’í day ends.** A Bahá’í day
begins at sunset, so it begins on the evening before the date given.

<div class="toc" markdown="1">

**On this page:** [Structure](#structure) · [Holy Days and Feasts](#holy-days-and-feasts) ·
[The rules from 2015](#the-rules-from-172-be-2015) · [The rules before 2015](#the-rules-before-172-be) ·
[How to calculate](#how-to-calculate-the-dates) · [Worked example](#worked-example-183-be-20262027) ·
[Edge cases](#edge-cases) · [Accuracy and limits](#accuracy-and-limits) ·
[How the dates are checked](#how-the-dates-are-checked)

</div>

## Structure

**Days.** A day runs from sunset to sunset ([Kitáb-i-Aqdas](sources.md#aqdas), note 26).

**Weeks.** Seven days, beginning on Saturday. Friday is the day of rest
([*Lights of Guidance*](sources.md#lights-of-guidance) no. 372).

| | Name | Meaning | Gregorian equivalent |
|---|---|---|---|
| 1 | Jalál | Glory | Saturday |
| 2 | Jamál | Beauty | Sunday |
| 3 | Kamál | Perfection | Monday |
| 4 | Fiḍál | Grace | Tuesday |
| 5 | ‘Idál | Justice | Wednesday |
| 6 | Istijlál | Majesty | Thursday |
| 7 | Istiqlál | Independence | Friday |

**Months.** Nineteen months of nineteen days. The days of each month have the same
names as the months, in the same order.

| | Month | Meaning |
|---|---|---|
| 1 | Bahá | Splendour |
| 2 | Jalál | Glory |
| 3 | Jamál | Beauty |
| 4 | ‘Aẓamat | Grandeur |
| 5 | Núr | Light |
| 6 | Raḥmat | Mercy |
| 7 | Kalimát | Words |
| 8 | Kamál | Perfection |
| 9 | Asmá’ | Names |
| 10 | ‘Izzat | Might |
| 11 | Mashíyyat | Will |
| 12 | ‘Ilm | Knowledge |
| 13 | Qudrat | Power |
| 14 | Qawl | Speech |
| 15 | Masá’il | Questions |
| 16 | Sharaf | Honour |
| 17 | Sulṭán | Sovereignty |
| 18 | Mulk | Dominion |
| | *Ayyám-i-Há* | *Intercalary days* |
| 19 | ‘Alá’ | Loftiness |

**Ayyám-i-Há** (“the Days of Há”; the letter Há has the numerical value five) are four
or five intercalary days between the 18th and 19th months, so that 19 × 19 + Ayyám-i-Há
equals the length of the year, 365 or 366 days ([Kitáb-i-Aqdas](sources.md#aqdas) ¶16,
note 28).

**The Fast** is the 19th month, ‘Alá’ ([Kitáb-i-Aqdas](sources.md#aqdas) ¶16).

**Years.** Each year has a name within a cycle of nineteen years called a Váḥid
(“unity”, numerical value 19). Nineteen Váḥids make a Kull-i-Shay’ (“all things”,
numerical value 361) ([*The Bahá’í World*](sources.md#bahai-world)).

| | Year | Meaning | | Year | Meaning |
|---|---|---|---|---|---|
| 1 | Alif | A | 11 | Bahháj | Delightful |
| 2 | Bá’ | B | 12 | Javáb | Answer |
| 3 | Ab | Father | 13 | Aḥad | Single |
| 4 | Dál | D | 14 | Vahháb | Bountiful |
| 5 | Báb | Gate | 15 | Vidád | Affection |
| 6 | Váv | V | 16 | Badí‘ | Beginning |
| 7 | Abad | Eternity | 17 | Bahí | Luminous |
| 8 | Jád | Generosity | 18 | Abhá | Most Luminous |
| 9 | Bahá | Splendour | 19 | Váḥid | Unity |
| 10 | Ḥubb | Love | | | |

**The epoch.** Year 1 of the Bahá’í Era (B.E.) began at the Naw-Rúz of 1844, before
the Declaration of the Báb in May of that year (1260 A.H.). Year *n* B.E. begins in
March of Gregorian year 1843 + *n*. The year 171 B.E., ending in March 2015, closed
the ninth Váḥid of the first Kull-i-Shay’ ([*The Bahá’í World*](sources.md#bahai-world);
[Universal House of Justice, 10 July 2014](sources.md#uhj-2014-07-10)).

## Holy Days and Feasts

| Holy Day | Bahá’í date | Work suspended | Commemorated at |
|---|---|---|---|
| Naw-Rúz | 1 Bahá | yes | |
| First Day of Riḍván | 13 Jalál | yes | late in the afternoon, about 3 p.m. |
| Ninth Day of Riḍván | 2 Jamál | yes | |
| Twelfth Day of Riḍván | 5 Jamál | yes | |
| Declaration of the Báb | 8 ‘Aẓamat | yes | 2 hours and 11 minutes after sunset, the evening the day begins |
| Ascension of Bahá’u’lláh | 13 ‘Aẓamat | yes | about 8 hours after sunset (3 a.m.), by the sun |
| Martyrdom of the Báb | 17 Raḥmat | yes | about noon |
| Birth of the Báb | moves ([see below](#the-twin-holy-days)) | yes | |
| Birth of Bahá’u’lláh | the day after the Birth of the Báb | yes | |
| Day of the Covenant | 4 Qawl | no | |
| Ascension of ‘Abdu’l-Bahá | 6 Qawl | no | about one hour after midnight, by the sun |

The Festival of Riḍván runs from 13 Jalál to 5 Jamál. The Birth of the Báb and the
Birth of Bahá’u’lláh are together the Twin Holy Birthdays. The Nineteen Day Feast falls
on the first day of each month.

Sources: the dates, [Universal House of Justice, 10 July 2014](sources.md#uhj-2014-07-10);
the nine days on which work is suspended, [Kitáb-i-Aqdas](sources.md#aqdas) (Questions
and Answers 1, note 140) and [*The Bahá’í World*](sources.md#bahai-world); the hours,
which the House of Justice said in 2014 remain in force: Riḍván, Questions and Answers 1
and [Walbridge](sources.md#walbridge-1996) p. 238 (quoting Shoghi Effendi); the
Declaration, [*Lights of Guidance*](sources.md#lights-of-guidance) no. 1541; the
Martyrdom, [*The Dawn-Breakers*](sources.md#dawn-breakers); the Ascensions, “according
to the sun and regardless of daylight saving time”, *Lights of Guidance* no. 1024, and
for 3 a.m. the [letter of 20 December 2017](sources.md#uhj-2017-12-20) (Persian).

## The rules from 172 B.E. (2015)

The Universal House of Justice set these rules for the whole Bahá’í world from
Naw-Rúz 172 B.E., 21 March 2015 ([message of 10 July 2014](sources.md#uhj-2014-07-10)).

### Naw-Rúz

Bahá’u’lláh wrote that Naw-Rúz falls on the day the sun enters Aries, “even should this
occur no more than one minute before sunset” ([Kitáb-i-Aqdas](sources.md#aqdas),
Questions and Answers 35). The House of Justice decided that Ṭihrán is the place that
determines, “by means of astronomical computations from reliable sources,” the moment
of the vernal equinox and so the day of Naw-Rúz for the whole Bahá’í world.

So **Naw-Rúz is the Bahá’í day, reckoned from sunset to sunset in Ṭihrán, in which the
March equinox occurs.** If the equinox comes after sunset in Ṭihrán, Naw-Rúz is the next
Gregorian date. A letter on behalf of the House of Justice explains: “The moment of the
vernal equinox is independent of any geographical location on the earth. However … to
determine the Bahá’í day on which the vernal equinox occurs, this moment must be
compared with sunset.” In 2018 the equinox came at 19:45 Iran time on 20 March, after
sunset, so Naw-Rúz was 21 March. The equinox marks the day of Naw-Rúz; it is not the
moment the celebration begins ([letter of 3 May 2018](sources.md#uhj-2018-05-03)).

### The Twin Holy Days

The Birth of the Báb and the Birth of Bahá’u’lláh are observed “on the first and the
second day following the occurrence of the eighth new moon after Naw-Rúz, as determined
in advance by astronomical tables using Ṭihrán as the point of reference”
([10 July 2014](sources.md#uhj-2014-07-10)). They move between the months of Mashíyyat,
‘Ilm and Qudrat, from mid-October to mid-November.

The new moon is the astronomical conjunction of the Moon with the Sun, not the first
sighting of the crescent: “This refers to the day of the moon’s conjunction with the
sun, that is, the moon’s dark phase” ([Department of the Secretariat, 24 November
2014](sources.md#uhj-2014-11-24)). Its example: in 172 B.E. the eighth new moon fell
after sunset on 11 November 2015, in the Bahá’í day 9 Qudrat, so the Birthdays were
10 and 11 Qudrat (13 and 14 November).

### Everything else follows

The other Holy Days are fixed Bahá’í dates. The length of Ayyám-i-Há is whatever makes
the year end the day before the next Naw-Rúz: 4 days if the year has 365 days, 5 if it
has 366.

### The official dates

In December 2014 the Bahá’í World Centre issued [*Bahá’í Dates 172 to 221
B.E.*](sources.md#uhj-dates-172-221), prepared “using data provided by Her Majesty’s
Nautical Almanac Office in the United Kingdom,” with the point of reference for Ṭihrán
“taken from the World Geodetic System 1984.” In those fifty years Naw-Rúz falls on 20 or
21 March. [bahai.org](sources.md#bahai-org-calendar) publishes the same dates. No
official dates have been published after 221 B.E. (2064–2065).

## The rules before 172 B.E.

Before 2015 there was no single calendar for the whole Bahá’í world.

- **In the West**, under arrangements made at Shoghi Effendi’s direction
  ([*The Bahá’í World*](sources.md#bahai-world)), Naw-Rúz was kept on 21 March,
  Ayyám-i-Há from 26 February to 1 March (four days, or five in a Gregorian leap year),
  the Fast from 2 to 20 March, and every Holy Day on a fixed Gregorian date: the
  Declaration of the Báb on 23 May, the Martyrdom on 9 July, the Birth of the Báb on
  20 October and the Birth of Bahá’u’lláh on 12 November.
- **In Iran and the East**, Naw-Rúz was the day on which the equinox fell, by times
  taken from Iranian almanacs, and four Holy Days were kept on Islamic lunar dates: the
  Birth of the Báb (1 Muḥarram), the Birth of Bahá’u’lláh (2 Muḥarram), the Declaration
  of the Báb (5 Jamádí I) and the Martyrdom of the Báb (28 Sha‘bán).

The gem and the dataset follow the Western convention for 1 to 171 B.E. Under it the
Declaration and the Martyrdom fall on 7 ‘Aẓamat and 16 Raḥmat; from 172 B.E. they are
8 ‘Aẓamat and 17 Raḥmat, the dates ‘Abdu’l-Bahá gave. Before 1910 the Western
convention is applied backwards, to years before the calendar was kept in the West.
For each of these years the dataset also gives the Naw-Rúz that the 2014 rule would
have given, as a reconstruction of practice in Iran.
[History and historical dates](history.md) sets this out in full.

## How to calculate the dates

All times are compared in Ṭihrán. The gem uses 35.696111° N, 51.423056° E. (The
official table used a point from WGS 84 that it does not state; the gem matches the
official table in every year it covers.) **Sunset** is when the centre of the Sun is
90°50′ from the zenith: its upper edge on the horizon, allowing for refraction.

### Calculating Naw-Rúz

For Gregorian year *g* (from 2015):

1. Compute the moment of the March equinox in *g*, in Terrestrial Time, from a solar
   theory (the gem uses [Meeus](sources.md#meeus), chapters 25 and 27).
2. Convert it to Universal Time by subtracting ΔT ([below](#accuracy-and-limits)), then
   to Ṭihrán clock time (UTC+3:30). The offset only decides which calendar date a moment
   is labelled with, so any offset within a few hours gives the same result.
3. Let *d* be the Ṭihrán date of the equinox. If the equinox is after sunset in Ṭihrán
   on *d*, Naw-Rúz is *d* + 1; otherwise it is *d*.

### Calculating the months and Ayyám-i-Há

For the year beginning at Naw-Rúz *N*, with the next Naw-Rúz at *N′*:

- Month *m* (1 to 18) begins on *N* + 19(*m* − 1).
- Ayyám-i-Há begins on *N* + 342 and lasts (*N′* − *N*) − 361 days.
- ‘Alá’ (month 19) begins on *N′* − 19.

### Calculating the Twin Holy Days

For the year beginning at Naw-Rúz *N*:

1. Let *E* be the sunset in Ṭihrán that ends the day of Naw-Rúz (sunset on *N*).
2. Find the first new moon after *E*, then the seventh new moon after that one: the
   eighth new moon after Naw-Rúz ([Meeus](sources.md#meeus), chapter 49).
3. Let *d* be the Ṭihrán date of that new moon, plus one day if it is after sunset on
   that date: the Bahá’í day in which the new moon occurs.
4. The Birth of the Báb is *d* + 1 and the Birth of Bahá’u’lláh is *d* + 2.

A new moon during the day of Naw-Rúz itself is not counted (step 1). The official table
confirms this reading ([edge cases](#edge-cases)).

### Converting a date

To convert Gregorian date *x*: find the latest Naw-Rúz *N* on or before *x*. The year is
*g* − 1843, where *g* is the Gregorian year of *N*; for a date from 1 January to the day
before Naw-Rúz, that is the previous Gregorian year. Then count days from *N* with the
month layout above. This gives the Bahá’í day that ends at sunset on *x*.

### Today’s date

“Today” depends on where you are. After local sunset, the Bahá’í date is the one for
the next Gregorian date. A server’s “today” is in the server’s time zone, not the
reader’s.

### High latitudes

Bahá’u’lláh permitted clocks in place of the sun “in regions where the days and nights
grow long” ([Kitáb-i-Aqdas](sources.md#aqdas) ¶10; Questions and Answers 64). The House
of Justice extended this to fasting and to “fixing the ending of each day in the Bahá’í
calendar in determining the time for the starting of each Holy Day and the holding of
the Nineteen Day Feasts”, leaving its application to the National Spiritual Assembly of
each country in the high latitudes (letter on its behalf, 13 June 1978,
[*Lights of Guidance*](sources.md#lights-of-guidance) no. 1532). Dublin was told to use
the actual sunset (no. 781). So in the far north or south the day may end at a clock
time set by the National Assembly; check with the Bahá’í community of the country. (The
[badiDate](sources.md#badidate) library uses 18:00 for northern Canada, Alaska, Finland,
Iceland, Norway and Sweden; it cites no source for these times.)

## Worked example: 183 B.E. (2026–2027)

Computed with the gem, step by step:

| Step | Result |
|---|---|
| March equinox 2026 (Terrestrial Time) | 20 March 2026, 14:47:04 |
| ΔT | 75 seconds |
| Equinox in Universal Time | 20 March, 14:45:49 |
| In Ṭihrán (UTC+3:30) | 20 March, 18:15:49 |
| Sunset in Ṭihrán on 20 March | 18:15:38 |
| The equinox is 11 seconds after sunset, so Naw-Rúz is | **21 March 2026** (1 Bahá 183) |
| Next Naw-Rúz (2027) | 21 March 2027, so the year has 365 days |
| Ayyám-i-Há | 365 − 361 = 4 days: 26 February to 1 March 2027 |
| ‘Alá’ (the Fast) | 2 to 20 March 2027 |
| First new moon after sunset on 21 March 2026 | 17 April 2026, 15:21 Ṭihrán time |
| Seventh after it (the eighth after Naw-Rúz) | 9 November 2026, 10:31, before sunset (17:02) |
| Birth of the Báb, Birth of Bahá’u’lláh | **10 and 11 November 2026** (7 and 8 Qudrat) |
| 15 February 2027 is in the year that began in March 2026 | 9 Mulk 183, a Monday (Kamál) |

These agree with the official dates for 183 B.E. 2026 is one of the closest years. The
gem’s sunset agrees with an independent calculation (badiDate’s) to within about a
minute, so in a year this close its answer could have gone either way; it matches the
official date ([edge cases](#edge-cases)).

## Edge cases

These figures are computed with the gem.

**The equinox close to sunset.** Naw-Rúz turns on which side of a Ṭihrán sunset the
equinox falls. In 2026 the equinox came about 11 seconds after sunset (Naw-Rúz
21 March), and in 2059 it comes about 98 seconds before (Naw-Rúz 20 March); the official
dates agree with both. In 2418 the equinox falls about 15 seconds before the exact
sunset time; the gem gives 21 March only because it rounds sunset down to the minute, as
RubySunrise did. Small errors in the astronomy matter in these years and in no others.

**A new moon during Naw-Rúz.** In 2034 a new moon falls at about 13:44 Ṭihrán time on
20 March, the day of Naw-Rúz. Counting it would put the Twin Holy Days on 13 and
14 October 2034; the official table gives 12 and 13 November (10 and 11 Qudrat), so it
is not counted. 2053 is the same (a new moon at about 10:41 on Naw-Rúz; official dates
11 and 12 November, not 13 and 14 October). Between 2015 and 3001 this happens in 32
years.

**The eighth new moon close to sunset.** In 2027 the eighth new moon falls within
6 minutes of sunset in Ṭihrán; the official date (30 October 2027, 15 ‘Ilm) agrees.

**Ayyám-i-Há is not tied to the Gregorian leap year.** It depends only on two successive
Naw-Rúz: in 174 B.E. it had five days though February 2018 had 28, and in 176 B.E. four
days though February 2020 had 29.

[`data/test-vectors.json`](data/test-vectors.json) lists these cases with their answers,
for checking an implementation.

## Accuracy and limits

The positions of the Sun and Moon are not the limiting factor. The limit is ΔT, the
difference between the uniform time scale the astronomy uses and clock time, which
follows the Earth’s rotation. The rotation slows through tidal friction and also changes
irregularly, so ΔT can be measured but not predicted. [NASA’s](sources.md#nasa-delta-t)
polynomials for ΔT run to the year 3000, and NASA puts the standard error of the
prediction at about 10 minutes in 2500 and 31 minutes in 3000. Between 2501 and 3001
the equinox falls within 30 minutes of sunset in 21 years (computed with the gem), so
some computed dates in that range will be a day out. The gem supports years 1 to
1157 B.E., which ends in March 3001.

The dataset labels each year:

| Years | Label | Meaning |
|---|---|---|
| 1–66 (1844–1910) | `convention-proleptic` | The Western convention, applied before it was kept in the West |
| 67–171 (1910–2015) | `convention` | The Western convention, as kept in the West |
| 172–221 (2015–2065) | `published` | Matches the official dates |
| 222–507 (2065–2351) | `cross-checked` | Computed; agrees with an independent implementation |
| 508–1157 (2351–3001) | `estimate` | Computed; some years may be a day out |

## How the dates are checked

The gem’s tests (bahai_date 2.0.1) compare it with:

- Table A of the official [*Bahá’í Dates 172 to 221 B.E.*](sources.md#uhj-dates-172-221):
  Naw-Rúz, the Twin Holy Days and Ayyám-i-Há, every year.
- The calendar on [bahai.org](sources.md#bahai-org-calendar) for 172 to 221 B.E.: every
  month start, every day, every Holy Day.
- The independent [badiDate](sources.md#badidate) JavaScript library, which uses the JPL
  DE405 ephemeris to 2200 and VSOP87 after, for 172 to 507 B.E. (to 2351): Naw-Rúz, the
  Twin Holy Days and Ayyám-i-Há.

All agree in every year. The figures above marked as computed come from the gem’s own
astronomy: Meeus for the equinox and new moons, and the [*Almanac for
Computers*](sources.md#almanac-for-computers) formula for sunset.
