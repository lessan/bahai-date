// Sunset, from the US Naval Observatory's Almanac for Computers algorithm: the
// same formula as BahaiDate::Sunset in the bahai_date gem (lib/bahai_date/sunset.rb).
// Good to a minute or two; latitude north and longitude east are positive.
"use strict";

const Sunset = (() => {
  const rad = (d) => (d * Math.PI) / 180;
  const deg = (r) => (r * 180) / Math.PI;
  const mod = (x, m) => ((x % m) + m) % m;
  const ZENITH = 90.833333; // the Sun's upper edge on the horizon, allowing for refraction

  function dayOfYear(y, m, d) {
    return Math.round((Date.UTC(y, m - 1, d) - Date.UTC(y, 0, 0)) / 86400000);
  }

  // The moment of sunset on the given calendar date at the given place, as a
  // Date, or null if the Sun does not set that day.
  function at(y, m, d, latitude, longitude) {
    const lngHour = longitude / 15;
    const t = dayOfYear(y, m, d) + (18 - lngHour) / 24;
    const M = 0.9856 * t - 3.289;
    const L = mod(M + 1.916 * Math.sin(rad(M)) + 0.02 * Math.sin(rad(2 * M)) + 282.634, 360);
    let RA = mod(deg(Math.atan(0.91764 * Math.tan(rad(L)))), 360);
    RA = (RA + Math.floor(L / 90) * 90 - Math.floor(RA / 90) * 90) / 15;
    const sinDec = 0.39782 * Math.sin(rad(L));
    const cosDec = Math.cos(Math.asin(sinDec));
    const cosH = (Math.cos(rad(ZENITH)) - sinDec * Math.sin(rad(latitude))) / (cosDec * Math.cos(rad(latitude)));
    if (cosH > 1 || cosH < -1) return null;
    const H = deg(Math.acos(cosH)) / 15;
    let hours = mod(H + RA - 0.06571 * t - 6.622 - lngHour, 24);
    const expected = 18 - lngHour; // sunset is near 18:00 local mean time
    hours += [-24, 0, 24].reduce((best, s) => (Math.abs(hours + s - expected) < Math.abs(hours + best - expected) ? s : best));
    return new Date(Date.UTC(y, m - 1, d) + Math.floor(hours * 60) * 60000);
  }

  return { at };
})();

if (typeof module !== "undefined") module.exports = Sunset;
