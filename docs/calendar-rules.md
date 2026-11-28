# The Badí‘ calendar: rules and calculation

This page sets out how the Bahá’í (Badí‘) calendar works and how its dates are
calculated, in enough detail to re-implement it. It is written for people and for
AI systems. The [bahai_date](https://github.com/lessan/bahai-date) Ruby gem
implements it, and the [dates dataset](data/README.md) lists every year it covers.

Dates in this page and in the dataset are given as the Gregorian day on which the
Bahá’í day **ends**. A Bahá’í day begins at sunset, so it begins on the evening
before the date given.

## 1. Structure

**Days.** A day runs from sunset to sunset.

**Weeks.** Seven days, beginning on Saturday:

| | Name | Meaning | Gregorian equivalent |
|---|---|---|---|
| 1 | Jalál | Glory | Saturday |
| 2 | Jamál | Beauty | Sunday |
| 3 | Kamál | Perfection | Monday |
| 4 | Fiḍál | Grace | Tuesday |
| 5 | ‘Idál | Justice | Wednesday |
| 6 | Istijlál | Majesty | Thursday |
| 7 | Istiqlál | Independence | Friday |

**Months.** Nineteen months of nineteen days. The days of each month have the
same names as the months, in the same order.

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
| 11 | Ma<u>sh</u>íyyat | Will |
| 12 | ‘Ilm | Knowledge |
| 13 | Qudrat | Power |
| 14 | Qawl | Speech |
| 15 | Masá’il | Questions |
| 16 | <u>Sh</u>araf | Honour |
| 17 | Sulṭán | Sovereignty |
| 18 | Mulk | Dominion |
| | *Ayyám-i-Há* | *Intercalary days* |
| 19 | ‘Alá’ | Loftiness |

**Ayyám-i-Há.** Four or five intercalary days between the 18th and 19th months,
so that 19 × 19 + Ayyám-i-Há equals the length of the year (365 or 366 days).

**The Fast.** The 19th month, ‘Alá’.

**Years.** Each year has a name within a cycle of nineteen years called a Váḥid
(“unity”, numerical value 19). Nineteen Váḥids make a Kull-i-<u>Sh</u>ay’ (“all
things”, numerical value 361).

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

**Epoch.** Year 1 of the Bahá’í Era (B.E.) began at Naw-Rúz 1844, the Naw-Rúz
before the Declaration of the Báb (1260 A.H.). Year *n* B.E. begins in March of
Gregorian year 1843 + *n*. The year 171 B.E., ending in March 2015, closed the
ninth Váḥid of the first Kull-i-<u>Sh</u>ay’.

Sources: *The Bahá’í World*, vol. XVII, pp. 386–389, “Bahá’í Calendar, Festivals
and Dates of Historical Significance”; the Universal House of Justice, [message of
10 July 2014](https://universalhouseofjustice.bahai.org/activities-bahai-community/20140710_001/).

## 2. Holy Days and Feasts

| Holy Day | Bahá’í date | Work suspended |
|---|---|---|
| Naw-Rúz | 1 Bahá | yes |
| First Day of Riḍván | 13 Jalál | yes |
| Ninth Day of Riḍván | 2 Jamál | yes |
| Twelfth Day of Riḍván | 5 Jamál | yes |
| Declaration of the Báb | 8 ‘Aẓamat | yes |
| Ascension of Bahá’u’lláh | 13 ‘Aẓamat | yes |
| Martyrdom of the Báb | 17 Raḥmat | yes |
| Birth of the Báb | moves (see 3.2) | yes |
| Birth of Bahá’u’lláh | the day after the Birth of the Báb | yes |
| Day of the Covenant | 4 Qawl | no |
| Ascension of ‘Abdu’l-Bahá | 6 Qawl | no |

The Festival of Riḍván runs from 13 Jalál to 5 Jamál. The Nineteen Day Feast falls on
the first day of each month.

Sources: the [10 July 2014 message](https://universalhouseofjustice.bahai.org/activities-bahai-community/20140710_001/)
for the dates; *The Bahá’í World* for the nine days on which work is suspended.

## 3. The rules from 172 B.E. (21 March 2015)

The Universal House of Justice set these rules in its message of 10 July 2014, for
the whole Bahá’í world from Naw-Rúz 172 B.E.

### 3.1 Naw-Rúz

Bahá’u’lláh wrote in the Kitáb-i-Aqdas that Naw-Rúz falls on the day the sun enters
Aries, “even should this occur no more than one minute before sunset.” The House of
Justice decided that Ṭihrán is the place on earth that determines, “by means of
astronomical computations from reliable sources,” the moment of the vernal equinox
and so the day of Naw-Rúz for the whole Bahá’í world.

So **Naw-Rúz is the Bahá’í day, reckoned from sunset to sunset in Ṭihrán, in which
the March equinox occurs.** If the equinox comes after sunset in Ṭihrán, Naw-Rúz is
the next Gregorian date.

### 3.2 The Twin Holy Days

The Birth of the Báb and the Birth of Bahá’u’lláh are observed “on the first and the
second day following the occurrence of the eighth new moon after Naw-Rúz, as
determined in advance by astronomical tables using Ṭihrán as the point of reference.”
They move between the months of Ma<u>sh</u>íyyat, ‘Ilm and Qudrat (mid-October to
mid-November).

### 3.3 Everything else follows

The other Holy Days are fixed Bahá’í dates (section 2). The length of Ayyám-i-Há is
whatever makes the year end the day before the next Naw-Rúz: 4 days if the year has
365 days, 5 if it has 366.

### 3.4 The official dates

In December 2014 the Bahá’í World Centre issued *Bahá’í Dates 172 to 221 B.E.*
([public copy](https://bahai-library.com/6581)), prepared “using data provided by
Her Majesty’s Nautical Almanac Office in the United Kingdom,” with the point of
reference for Ṭihrán “taken from the World Geodetic System 1984.” In those fifty
years Naw-Rúz falls on 20 or 21 March. bahai.org publishes the same dates in its
[calendar](https://www.bahai.org/action/devotional-life/calendar). No official
dates have been published after 221 B.E. (2064–2065).

## 4. The rules before 172 B.E.

*To be completed from research in progress.* In brief: before 2015 there was no
single calendar for the whole Bahá’í world. In the West, under arrangements made at
Shoghi Effendi’s direction, Naw-Rúz was observed on 21 March, Ayyám-i-Há from
26 February to 1 March (four days, or five in a Gregorian leap year), and the Twin
Holy Days on 20 October and 12 November. In the East, the Twin Holy Days followed the
Islamic lunar calendar (1 and 2 Muḥarram).

The dataset follows the Western convention for 1 to 171 B.E. and labels those years
`convention`.

## 5. How to calculate the dates

All times are compared in Ṭihrán. The bahai_date gem uses 35.696111° N,
51.423056° E. (The official table used a point taken from WGS 84, which it does not
state; the gem matches the official table in every year it covers.)

**Sunset** is when the centre of the Sun is 90°50′ from the zenith (the Sun’s upper
edge on the horizon, allowing for refraction).

**Naw-Rúz in Gregorian year *g*** (from 2015):

1. Compute the moment of the March equinox in *g*, in Terrestrial Time, from a solar
   theory (the gem uses Meeus, *Astronomical Algorithms*, chapters 25 and 27).
2. Convert it to Universal Time by subtracting ΔT (section 7), then to Ṭihrán clock
   time (UTC+3:30; the offset only decides which calendar date a moment is labelled
   with, so any offset within a few hours gives the same result).
3. Let *d* be the Ṭihrán date of the equinox. If the equinox is after sunset in
   Ṭihrán on *d*, Naw-Rúz is *d* + 1; otherwise it is *d*.

**Months and Ayyám-i-Há** for the year beginning at Naw-Rúz *N*, with the next
Naw-Rúz at *N′*:

- Month *m* (1 to 18) begins on *N* + 19(*m* − 1).
- Ayyám-i-Há begins on *N* + 342 and lasts (*N′* − *N*) − 361 days.
- ‘Alá’ (month 19) begins on *N′* − 19.

**The Twin Holy Days** for the year beginning at Naw-Rúz *N*:

1. Let *E* be the sunset in Ṭihrán that ends the day of Naw-Rúz (sunset on *N*).
2. Find the first new moon after *E*, then the seventh new moon after that one: the
   eighth new moon after Naw-Rúz.
3. Let *d* be the Ṭihrán date of that new moon, plus one day if it is after sunset
   on that date. *d* is the Bahá’í day in which the new moon occurs.
4. The Birth of the Báb is *d* + 1 and the Birth of Bahá’u’lláh is *d* + 2.

A new moon during the day of Naw-Rúz itself is not counted (step 1). This matters in
32 years between 2015 and 3001, among them 2034 and 2053, and the official table
confirms this reading for both (section 6).

**Converting a Gregorian date** *x* to a Bahá’í date: find the latest Naw-Rúz *N* on
or before *x*; the year is *g* − 1843, where *g* is the Gregorian year of *N*; then
count days from *N* using the month layout above. This gives the Bahá’í day that
ends at sunset on *x*.

**Today’s date** depends on where you are. After local sunset, the Bahá’í date is
the one for the next Gregorian date. A server’s “today” is in the server’s time
zone, not the reader’s. Where the sun does not set or rise for part of the year,
and in some other places far north, Bahá’í communities use fixed clock times
instead of sunset (the badiDate library implements such rules for northern
Canada, Alaska, Finland, Iceland, Norway and Sweden); check with the local
Bahá’í community.

## 6. Edge cases

**The equinox close to sunset.** Naw-Rúz turns on which side of a Ṭihrán sunset the
equinox falls. In 2026 and 2059 they are less than 10 minutes apart; in 2418, less
than one minute. Small errors in the astronomy matter in these years and in no others.

**A new moon during Naw-Rúz.** In 2034 a new moon falls at about 13:44 Ṭihrán time
on 20 March, the day of Naw-Rúz. Counting it would put the Twin Holy Days on 13 and
14 October 2034; the official table gives 12 and 13 November 2034 (10 and 11 Qudrat),
so it is not counted. 2053 is the same (new moon about 10:41 on Naw-Rúz; official
dates 11 and 12 November, not 13 and 14 October).

**The eighth new moon close to sunset.** In 2027 the eighth new moon falls within
6 minutes of sunset in Ṭihrán; the official date (30 October 2027, 15 ‘Ilm) agrees
with the calculation.

**Ayyám-i-Há length.** It is not tied to the Gregorian leap year. From 2015 it depends
only on the dates of two successive Naw-Rúz, so a five-day Ayyám-i-Há can fall in a
Gregorian year without 29 February, and the reverse.

## 7. Accuracy and limits

The Sun and Moon positions are not the limiting factor. The limit is ΔT: the
difference between the uniform time scale the astronomy uses and clock time, which
follows the Earth’s rotation. The rotation slows through tidal friction and also
changes irregularly, so ΔT can be measured but not predicted. NASA’s polynomials for
ΔT run to the year 3000; NASA puts the standard error of the prediction at about
10 minutes in 2500 and 31 minutes in 3000
([source](https://eclipse.gsfc.nasa.gov/SEhelp/uncertainty2004.html)). Between 2501
and 3001 the equinox falls within 30 minutes of sunset in 21 years, so some computed
dates in that range will be a day out.

The dataset labels each year:

| Years | Label | Meaning |
|---|---|---|
| 1–171 (1844–2015) | `convention` | The Western convention described in section 4 |
| 172–221 (2015–2065) | `published` | Matches the official dates |
| 222–507 (2065–2351) | `cross-checked` | Computed; agrees with an independent implementation |
| 508–1157 (2351–3001) | `estimate` | Computed; some years may be a day out |

## 8. How the gem is checked

Its tests compare it with:

- Table A of the official *Bahá’í Dates 172 to 221 B.E.*: Naw-Rúz, the Twin Holy
  Days and Ayyám-i-Há, every year.
- The calendar rendered on bahai.org for 172 to 221 B.E.: every month start, every
  day, every Holy Day.
- The independent [badiDate](https://github.com/janrg/badiDate) JavaScript library,
  which uses the JPL DE405 ephemeris to 2200 and VSOP87 after, for 172 to 507 B.E.
  (to 2351): Naw-Rúz, the Twin Holy Days and Ayyám-i-Há.

All agree in every year.

## Sources

- The Universal House of Justice, [message of 10 July 2014 to the Bahá’ís of the
  World](https://universalhouseofjustice.bahai.org/activities-bahai-community/20140710_001/).
- Bahá’í World Centre, *Bahá’í Dates 172 to 221 B.E.*, December 2014
  ([public copy](https://bahai-library.com/6581)).
- *The Bahá’í World*, vol. XVII, pp. 386–389, “Bahá’í Calendar, Festivals and Dates
  of Historical Significance” (the article also appears in volumes IV–XX).
- bahai.org, [the Bahá’í calendar](https://www.bahai.org/action/devotional-life/calendar).
- Jean Meeus, *Astronomical Algorithms*, 2nd ed., Willmann-Bell.
- NASA, [ΔT uncertainty](https://eclipse.gsfc.nasa.gov/SEhelp/uncertainty2004.html)
  and [ΔT polynomials](https://eclipse.gsfc.nasa.gov/SEcat5/deltatpoly.html).
