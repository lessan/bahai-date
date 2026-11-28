# History and historical dates

For anyone converting Bahá’í dates before 2015 or checking the dates of events in
Bahá’í history. Before Naw-Rúz 172 B.E. (21 March 2015) there was no single Badí‘
calendar: Bahá’ís in the West and in Iran reckoned it differently, several Holy Days
were kept on Islamic lunar dates in the East, and some event dates differ by a day
between sources. The [rules](rules.md) describe the calendar from 2015.

Each source is linked to its entry on the [sources page](sources.md). Where a source
is in Persian, this page summarises it rather than quoting an unofficial translation.
Statements marked *computed* were calculated with the bahai_date gem.

<div class="toc" markdown="1">

**On this page:** [At a glance](#at-a-glance) · [Event dates](#event-dates) ·
[Before 2015 in the West](#before-2015-in-the-west) · [Before 2015 in Iran](#before-2015-in-iran-and-the-east) ·
[What changed in 2015](#what-changed-in-2015) · [When each Holy Day began](#when-each-holy-day-began) ·
[Converting dates found in sources](#converting-dates-found-in-sources)

</div>

## At a glance

| | West, before 2015 | Iran and the East, before 2015 | Everywhere, from 2015 |
|---|---|---|---|
| Naw-Rúz | 21 March | The day of the equinox, by almanac times; no fixed reference place | The day of the equinox in Ṭihrán (20 or 21 March to 2064) |
| Ayyám-i-Há | 26 February to 1 March: 4 days, 5 in a Gregorian leap year | Whatever made the year end before the next Naw-Rúz | Whatever makes the year end before the next Naw-Rúz |
| The Fast | 2 to 20 March | The 19 days before Naw-Rúz | The 19 days before Naw-Rúz (1 or 2 March to 19 or 20 March) |
| Birth of the Báb | 20 October | 1 Muḥarram (lunar) | First day after the eighth new moon after Naw-Rúz |
| Birth of Bahá’u’lláh | 12 November | 2 Muḥarram (lunar) | The day after the Birth of the Báb |
| Declaration of the Báb | 23 May (7 ‘Aẓamat) | 5 Jamádí I (lunar) | 8 ‘Aẓamat |
| Martyrdom of the Báb | 9 July (16 Raḥmat) | 28 Sha‘bán (lunar) | 17 Raḥmat |
| Other Holy Days | Fixed Gregorian dates | Solar: fixed days of the Badí‘ year | Fixed Badí‘ dates |

Sources: West, [*The Bahá’í World*](sources.md#bahai-world); East, [‘Alá’í’s calendar,
INBA 95](sources.md#inba-95), the [89 B.E. almanac](sources.md#taqvim-89) and
[Walbridge](sources.md#walbridge-1996) pp. 188–189; from 2015, [Universal House of
Justice, 10 July 2014](sources.md#uhj-2014-07-10).

The [dataset](data/README.md) gives the Western dates for 1 to 171 B.E. (labelled
`convention`, or `convention-proleptic` before 1910) and, alongside, a reconstruction of
Naw-Rúz in Iran.

## Event dates

Many Gregorian dates in Bahá’í histories are conversions from Islamic lunar dates.
[*The Dawn-Breakers*](sources.md#dawn-breakers) converts with the Wüstenfeld–Mahler
tables, and the dates in [*God Passes By*](sources.md#god-passes-by) and *The Bahá’í
World* agree with those tables. Islamic months began with the sighting of the crescent,
so the day actually reckoned could differ from the tables by a day or two; a weekday
given in a source is often the best check. The same dates are in
[`data/events.json`](data/events.json).

| Event | Date in the sources | Badí‘ date observed | Sources agree? |
|---|---|---|---|
| Birth of Bahá’u’lláh | 12 November 1817 (2 Muḥarram 1233), Ṭihrán | Twin Holy Days rule | yes |
| Birth of the Báb | 20 October 1819 (1 Muḥarram 1235), Shíráz | Twin Holy Days rule | yes |
| [Declaration of the Báb](#declaration-of-the-bab-1844) | Evening of 22 May 1844, the day labelled 23 May (5 Jamádí I 1260), Shíráz | 8 ‘Aẓamat | yes (a matter of labelling) |
| [Martyrdom of the Báb](#martyrdom-of-the-bab-1850) | 9 July 1850, or 8 July (28 or 27 Sha‘bán 1266), noon, Tabríz | 17 Raḥmat | no |
| [First day of Riḍván](#ridvan-1863) | Wednesday 22 April 1863 (3 Dhi’l-Qa‘dih 1279), Baghdád | 13 Jalál | yes, but see below |
| [Ascension of Bahá’u’lláh](#ascension-of-bahaullah-1892) | 29 May 1892, or 28 May (2 Dhi’l-Qa‘dih 1309), Bahjí | 13 ‘Aẓamat | no |
| Ascension of ‘Abdu’l-Bahá | Shortly after 1:15 a.m., 28 November 1921, Haifa | 6 Qawl | yes |

Sources for the births: [*The Bahá’í World*](sources.md#bahai-world). For ‘Abdu’l-Bahá:
[*God Passes By*](sources.md#god-passes-by).

### Declaration of the Báb, 1844

The Báb declared His mission two hours and eleven minutes after sunset on the evening
of 22 May 1844, the eve of 5 Jamádí I 1260. Because the Islamic and Bahá’í day begins at
sunset, that evening belongs to the day labelled 23 May, and the anniversary is kept on
that day ([*Lights of Guidance*](sources.md#lights-of-guidance) nos. 1541–1542;
[*The Dawn-Breakers*](sources.md#dawn-breakers)). “22 or 23 May” is a matter of labelling,
not of fact.

Its Badí‘ date depends on the Naw-Rúz of 1844. The before-sunset rule gives Naw-Rúz on
20 March 1844 (*computed*: the equinox fell at about 15:23 in Ṭihrán), and then 23 May
is day 65 of the year, 8 ‘Aẓamat, the date ‘Abdu’l-Bahá gave
([*Ayyám-i-Tis‘ih*](sources.md#ayyam-i-tisih)). With the Western Naw-Rúz of 21 March,
23 May is 7 ‘Aẓamat.

### Martyrdom of the Báb, 1850

- Bahá’í histories give noon on Sunday 28 Sha‘bán 1266, 9 July 1850
  ([*The Dawn-Breakers*](sources.md#dawn-breakers)).
- The British consul in Tabríz reported the execution as on 8 July
  ([Momen 1981](sources.md#momen-1981)), and the Persian court historian Sipihr gives
  Monday 27 Sha‘bán, 8 July ([Walbridge](sources.md#walbridge-1996) p. 230).
- 9 July 1850 was a Tuesday and 8 July a Monday, so the “Sunday” of *The Dawn-Breakers*
  fits neither.
- With Naw-Rúz on 21 March 1850 (*computed*: the equinox fell at about 02:30 in Ṭihrán on
  21 March, under any rule), 9 July was 16 Raḥmat and 17 Raḥmat was 10 July.

The observance has been fixed on 17 Raḥmat since 2015, the date ‘Abdu’l-Bahá gave
([*Ayyám-i-Tis‘ih*](sources.md#ayyam-i-tisih)).

### Riḍván, 1863

Bahá’u’lláh entered the garden “on a Wednesday afternoon (April 22, 1863), thirty-one
days after Naw-Rúz, on the third of Dhi’l-Qa‘dih, 1279 A.H.”
([*God Passes By*](sources.md#god-passes-by)). The tables give the same weekday, and the
ninth and twelfth days were 30 April and 3 May.

“Thirty-one days after Naw-Rúz” implies Naw-Rúz on 22 March 1863, and some secondary
works say so. But the equinox fell before dawn on 21 March 1863 (*computed*), which by
any rule makes Naw-Rúz 21 March and 22 April the 14th day of Jalál. The festival is kept
from 13 Jalál, as the Kitáb-i-Aqdas lays down ([Questions and Answers 1](sources.md#aqdas)).
In the dataset, 1863 (20 B.E.) shows the Western convention’s 21 April with the status
`event-year`.

### Ascension of Bahá’u’lláh, 1892

- [*God Passes By*](sources.md#god-passes-by): “at the hour of dawn, on the 2nd of
  Dhi’l-Qa‘dih 1309 A.H. (May 29, 1892), eight hours after sunset”. *The Bahá’í World*
  gives 29 May from volume 7.
- [*The Bahá’í World*](sources.md#bahai-world) volume 4 gave 28 May.
- Nabíl’s contemporary account dates the night in several calendars at once
  ([*Ayyám-i-Tis‘ih*](sources.md#ayyam-i-tisih), Persian). Its Ottoman (Rúmí) date,
  16 Ayyár, is 28 May in the Gregorian calendar, and its count of seventy days from
  Naw-Rúz also gives 28 May if Naw-Rúz 1892 was 20 March, which the before-sunset rule
  gives (*computed*).

The Badí‘ date is not in doubt: the seventieth day of the year, 13 ‘Aẓamat, which is how
‘Abdu’l-Bahá referred to it. A letter on behalf of the Universal House of Justice names
the day of the Ascension as one of the historical discrepancies it set aside
([20 December 2017](sources.md#uhj-2017-12-20), Persian).

## Before 2015 in the West

The arrangements for the West were “put in place at the direction of Shoghi Effendi, as
described in the volumes of *The Bahá’í World*” ([Universal House of Justice, 10 July
2014](sources.md#uhj-2014-07-10)), in the article “Bahá’í Calendar, Festivals and Dates
of Historical Significance”, printed in volumes 4 to 20 ([*The Bahá’í
World*](sources.md#bahai-world); [Momen 2014](sources.md#momen-2014)). They fixed:

| | Gregorian date | Bahá’í date (Naw-Rúz on 21 March) |
|---|---|---|
| Naw-Rúz | 21 March | 1 Bahá |
| Riḍván | 21 April to 2 May | 13 Jalál to 5 Jamál |
| Declaration of the Báb | 23 May | 7 ‘Aẓamat |
| Ascension of Bahá’u’lláh | 29 May | 13 ‘Aẓamat |
| Martyrdom of the Báb | 9 July | 16 Raḥmat |
| Birth of the Báb | 20 October | 5 ‘Ilm |
| Birth of Bahá’u’lláh | 12 November | 9 Qudrat |
| Day of the Covenant | 26 November | 4 Qawl |
| Ascension of ‘Abdu’l-Bahá | 28 November | 6 Qawl |
| Ayyám-i-Há | 26 February to 1 March (4 days, or 5 in a Gregorian leap year) | |
| The Fast | 2 to 20 March | 1 to 19 ‘Alá’ |

**Naw-Rúz stayed on 21 March in practice.** The article says Naw-Rúz falls on 21 March
“only if the vernal Equinox precedes the setting of the sun on that day”, and a
[letter on Shoghi Effendi’s behalf of 15 May 1940](sources.md#letter-1940-05-15) says the
same, adding that the choice of a reference place was for the Universal House of
Justice. A United States bulletin of 1967 tied the hours of the Naw-Rúz Feast to the
equinox ([*U.S. Supplement* no. 109](sources.md#us-supplement-109)); by 1982 it said
“regardless of the date of the vernal equinox” ([*National Bahá’í Review*
no. 118](sources.md#nbr-118)). No Western community is known to have kept 20 or 22 March,
though that has not been proven.

**When the West began to use it.** *Bahai News* (later *Star of the West*) began on
21 March 1910 as “Baha No. 1”, numbered by Badí‘ months and printing their first days
([*Star of the West*](sources.md#star-of-the-west)). A chronology gives 1907 for its first
use in North America ([bahai-library.com](sources.md#chronology-1907)), not confirmed
here. The dataset labels years before 67 B.E. (1910) `convention-proleptic`.

## Before 2015 in Iran and the East

- **Naw-Rúz** was the day on which the equinox (*taḥvíl*) fell, by the rule that it counts
  “even should this occur no more than one minute before sunset”
  ([Kitáb-i-Aqdas](sources.md#aqdas), Questions and Answers 35). A Persian comparative
  calendar issued with the permission of the National Spiritual Assembly of Iran in 1977
  states this rule, contrasts it with the Iranian civil rule (the equinox before noon),
  and notes that no reference place had yet been fixed ([INBA 95](sources.md#inba-95)).
- **The times came from almanacs.** The Persian Bahá’í almanac for 89 B.E. gives the
  equinox of 1932 at 11:46 p.m. and of 1933 at 5:30 a.m. ([89 B.E.
  almanac](sources.md#taqvim-89)); modern computation puts them at about 11:20 p.m. and
  5:09 a.m. local time, so such almanacs could differ by 20 to 30 minutes.
- **Four Holy Days were kept on Islamic lunar dates**: the Birth of the Báb (1 Muḥarram),
  the Birth of Bahá’u’lláh (2 Muḥarram), the Declaration of the Báb (5 Jamádí I) and the
  Martyrdom of the Báb (28 Sha‘bán) ([89 B.E. almanac](sources.md#taqvim-89);
  [Walbridge](sources.md#walbridge-1996) pp. 188–189). A [letter on Shoghi Effendi’s
  behalf of 10 November 1955](sources.md#letter-1955-11-10) notes that “the Bahá’ís in the
  East follow the Lunar calendar, for certain of the Holy Days”. Lunar dates move about
  11 days earlier each solar year, so these days moved through the whole year; by the
  tables, the Twin Birthdays came twice in five Badí‘ years (28, 60, 93, 125 and 158 B.E.)
  (*computed*, tabular conversion).
- **Ayyám-i-Há** had whatever length made the year end the day before the next Naw-Rúz
  ([INBA 95](sources.md#inba-95)).
- **Persian chronologies may give the civil New Year as Naw-Rúz.** Ishráq-Khávarí’s
  *Taqvím-i-Táríkh-i-Amr* (1963) heads each year with its Naw-Rúz; of 106 years checked,
  100 match the civil before-noon rule and 80 the Bahá’í before-sunset rule
  ([*Taqvím-i-Táríkh-i-Amr*](sources.md#ishraq-taqvim); comparison *computed*).
- In 2018 the House of Justice wrote that “the age-old practice in Iran of marking the
  start of the Iranian festival of Naw-Rúz according to the exact moment of the
  occurrence of the vernal equinox is not relevant to the implementation of the Badí‘
  calendar” ([letter of 3 May 2018](sources.md#uhj-2018-05-03)).

**The reconstruction in the dataset.** For 1 to 171 B.E. the dataset’s
`eastern_reconstruction` applies the rule used since 2015 (the equinox before sunset in
Ṭihrán) to each year (*computed*). It gives a Naw-Rúz other than 21 March in 51 of the 171
years (44 on 20 March, 7 on 22 March) and a different length of Ayyám-i-Há in 69. In 1861,
1894, 1927, 1960 and 1993 the equinox fell within 15 minutes of sunset in Ṭihrán, and
those years are marked uncertain. In 1861 the gem puts it 1.4 minutes from sunset; a more
precise ephemeris (JPL DE440s) puts it 20 seconds after, which is why these years cannot
be settled by calculation. The reconstruction is not a record of what any community
observed: almanacs of the time could differ by tens of minutes.

## What changed in 2015

The Universal House of Justice fixed the Holy Days “in accordance with explicit
statements of Bahá’u’lláh, ‘Abdu’l-Bahá, and Shoghi Effendi”, setting aside “certain
discrepancies in the historical record” ([10 July 2014](sources.md#uhj-2014-07-10)).

- **The Declaration and the Martyrdom of the Báb** were fixed on 8 ‘Aẓamat and
  17 Raḥmat. ‘Abdu’l-Bahá had written that these are their Badí‘ dates (the day of Kamál
  of the month of ‘Aẓamat, and the day of Sulṭán of the month of Raḥmat), while noting
  that they were still kept on their lunar dates as in Bahá’u’lláh’s lifetime
  ([*Ayyám-i-Tis‘ih*](sources.md#ayyam-i-tisih)). In the West the same days had been
  7 ‘Aẓamat (23 May) and 16 Raḥmat (9 July). They now fall on 24 May and 10 July in a
  year whose Naw-Rúz is 21 March, and on 23 May and 9 July in a year whose Naw-Rúz is
  20 March.
- **The Ascension of Bahá’u’lláh** stayed on 13 ‘Aẓamat, the seventieth day of the year,
  as ‘Abdu’l-Bahá described it.
- **The Twin Holy Days** left 20 October and 12 November in the West, and 1 and 2 Muḥarram
  in the East, for the new-moon rule.
- **Naw-Rúz** in the West left a fixed 21 March, and Ayyám-i-Há stopped following the
  Gregorian leap year.

## When each Holy Day began

In order of the events:

| Holy Day | Event or institution | Earliest known observance | Source and confidence |
|---|---|---|---|
| Birth of Bahá’u’lláh | 1817 | During Bahá’u’lláh’s lifetime, probably from the 1860s; in the West from about 1904 | [Walbridge](sources.md#walbridge-1996) pp. 231–232 (secondary; years not given in a primary source) |
| Birth of the Báb | 1819 | Ṭáhirih in Karbilá, 30 December 1845 (1 Muḥarram); in the West, the last major Holy Day to be adopted | Walbridge pp. 217–218 (secondary) |
| Naw-Rúz | Ordained by the Báb in the Persian Bayán (1840s) | The Báb and the Bábís, from the 1840s | [Kitáb-i-Aqdas](sources.md#aqdas) note 26; [*Taqvím-i-Táríkh-i-Amr*](sources.md#ishraq-taqvim) (Persian) |
| Declaration of the Báb | 1844 | Its anniversary is mentioned in 1849, and was kept in Yazd in 1850 | Yazd: [*The Dawn-Breakers*](sources.md#dawn-breakers) (primary); 1849: Walbridge p. 221 (secondary) |
| Martyrdom of the Báb | 1850 | Kept during Bahá’u’lláh’s lifetime; first year not known | [Kitáb-i-Aqdas](sources.md#aqdas) note 140 |
| Riḍván | 1863 | Proclaimed by Bahá’u’lláh; made the Most Great Festival in the Kitáb-i-Aqdas (about 1873); first observance not documented | Kitáb-i-Aqdas ¶110, Questions and Answers 1 |
| Ascension of Bahá’u’lláh | 1892 | Added by ‘Abdu’l-Bahá after the Ascension, so from 1893 | Kitáb-i-Aqdas note 140 |
| Day of the Covenant | Appointed by ‘Abdu’l-Bahá in place of His own birthday, after 1892 | In the West from 1901 | Walbridge p. 245 (secondary) |
| Ascension of ‘Abdu’l-Bahá | 1921 | Listed in *The Bahá’í World* volume 4 (1930–32); presumably from 1922 | [*The Bahá’í World*](sources.md#bahai-world) |

In the dataset a Holy Day is not listed before the year of its event (the Day of the
Covenant not before 1892). In the year of the event it has the status `event-year`, and
the Day of the Covenant before 1901 has the status `proleptic`
([data](data/README.md#fields)).

## Converting dates found in sources

**Islamic lunar dates.** Convert with the tables (the civil epoch, 16 July 622) and allow
a day or two either way; check any weekday the source gives.

**“The night of”.** Persian and Arabic name a night by the day that follows it, as the
Bahá’í calendar does: the night of the 5th is the evening before the 5th.

**“The *n*th Naw-Rúz” in early sources.** Year 1 B.E. began at the Naw-Rúz of 1844,
before the Declaration ([*The Bahá’í World*](sources.md#bahai-world)). Nabíl counted his
own Naw-Rúz years from 1845, yet calls the Naw-Rúz of 1889 “the 46th”, which matches the
official year 46 B.E. by accident: he counted Hijri years (1261 to 1306 A.H. is 46 Hijri
years), and the Hijri year 1288 contained no Naw-Rúz, so his count gained one year back
(*computed*). Treat such counts as possibly one out and check them against any other date
given.

**The 65th or 66th day.** *The Bahá’í World* volume 4 says the Declaration fell on “the
sixty-sixth day after Naw-Rúz” in 1844; volume 7 and later say “sixty-fifth”. Day 65 fits
a Naw-Rúz on 20 March 1844 and matches 8 ‘Aẓamat.

**Julian and Ottoman (Rúmí) dates** are 12 days behind the Gregorian from March 1800 to
February 1900, and 13 days after that. Russian sources often use the Julian calendar.

**Persian solar dates** (the official Iranian calendar from 1925) have 12 months of 29 to
31 days, not 19 of 19, and their New Year (1 Farvardín) follows a before-noon rule rather
than a before-sunset rule, so even Naw-Rúz can differ by a day.

**Badí‘ dates on documents.** Shoghi Effendi’s Persian letters, and Iranian Bahá’í
circulars and periodicals, are often dated by Badí‘ month and year with a Gregorian or
solar date beside it; examples are in [*Ayyám-i-Tis‘ih*](sources.md#ayyam-i-tisih).
Converting one needs the Naw-Rúz of that year, so prefer any equivalent printed on the
document.

**Bábí and Azalí dates** may follow a different convention: the followers of Mírzá Yaḥyá
placed the intercalary days after ‘Alá’ ([*The Bahá’í World*](sources.md#bahai-world),
from Nabíl).

**Variants in *The Bahá’í World*.** Volume 4 gives 28 May for the Ascension of
Bahá’u’lláh, calls 26 November the “Fête Day of ‘Abdu’l-Bahá”, puts the Declaration on the
66th day, and swaps the 8th and 9th months. Prefer volume 7 or later, and cite the volume.
