<!-- hub-description: CPython 2.6-3.16 built from source on Debian trixie, own OpenSSL with RPATH -->
# Version Compablity

## Status of Python versions

https://endoflife.date/python
https://devguide.python.org/versions/
https://openssl-library.org/source/
https://openssl-library.org/source/old/
https://pypi.org/project/pip/
https://pypi.org/project/setuptools/


| Python   | OpenSSL                            | GCC   | Components                            | Comments                | Status |
| ------   | ---------------------------------- | ----- | ------------------------------------- | ----------------------- | ------ |
| 2.6      | 1.0.2u, End Of Life, 20 Dec 2019   | `4.9` | `pip` `9.0.3`, `setuptools` `36.8.0`, no SNI ⚠️ | End Of Life, 2013-10-29 | Ready ✅ |
| 2.7      | 1.1.1w, End Of Life, 20 Dec 2019   | `11`  | `pip` `20.3.4`, `setuptools` `44.1.1` | End Of Life, 2020-01-01 | Ready ✅ |
| 3.0      | 1.0.2u, End Of Life, 20 Dec 2019   | `4.9` | No `pip` and `setuptools`, no SNI ⚠️  | End Of Life, 2009-06-27 | Ready ✅ |
| 3.1      | 1.0.2u, End Of Life, 20 Dec 2019   | `4.9` | No `pip` and `setuptools`, no SNI ⚠️  | End Of Life, 2012-04-09 | Ready ✅ |
| 3.2      | 1.0.2u, End Of Life, 20 Dec 2019   | `4.9` | `pip` `7.1.2`, `setuptools` `29.0.1`  | End Of Life, 2016-02-20 | Ready ✅ |
| 3.3      | 1.0.2u, End Of Life, 20 Dec 2019   | `7`   | `pip` `10.0.1`, `setuptools` `39.2.0` | End Of Life, 2017-09-29 | Ready ✅ |
| 3.4      | 1.0.2u, End Of Life, 20 Dec 2019   | `7`   | `pip` `19.1.1`, `setuptools` `43.0.0` | End Of Life, 2019-03-18 | Ready ✅ |
| 3.5      | 1.1.1w, End Of Life, 12 Sep 2023   | `7`   | `pip` `20.3.4`, `setuptools` `50.3.2` | End Of Life, 2020-09-30 | Ready ✅ |
| 3.6      | 1.1.1w, End Of Life, 12 Sep 2023   | `9`   | `pip` `21.3.1`, `setuptools` `59.6.0` | End Of Life, 2021-12-23 | Ready ✅ |
| 3.7      | 1.1.1w, End Of Life, 12 Sep 2023   | `10`  | `pip` `24.0`, `setuptools` `68.0.0`   | End Of Life, 2023-06-27 | Ready ✅ |
| 3.8      | 1.1.1w, End Of Life, 12 Sep 2023   | `10`  | `pip` `25.0.1`, `setuptools` `75.3.2` | End Of Life, 2024-10-07 | Ready ✅ |
| 3.9      | 1.1.1w, End Of Life, 12 Sep 2023   | `10`  | `pip` `26.0.1`, `setuptools` `80.9.0` | End Of Life, 2025-10-31 | Ready ✅ |
| 3.10     | 3.5.x, LTS, 08 Apr 2030            | `13`  | `pip` `26.2.1`, `setuptools` `80.9.0` | security, 2026-10       | Ready ✅ |
| 3.11     | 3.5.x, LTS, 08 Apr 2030            | `13`  | `pip` `25.3`, `setuptools` `80.9.0`   | security, 2029-10       | Ready ✅ |
| 3.12     | 3.5.x, LTS, 08 Apr 2030            | `13`  | `pip` `25.3`, `setuptools` `80.9.0`   | security, 2028-10       | Ready  |
| 3.13     | 3.5.x, LTS, 08 Apr 2030            | `14`  | `pip` `25.3`, `setuptools` `80.9.0`   | bugfix, 2029-10         | Ready  |
| 3.14     | 3.5.x, LTS, 08 Apr 2030            | `14`  | `pip` `25.3`, `setuptools` `80.9.0`   | bugfix, 2030-10         | Ready  |
| 3.15     | 3.5.x, LTS, 08 Apr 2030            | `15`  | `pip` `25.3`, `setuptools` `80.9.0`   | pre-release, 2031-10    | Ready  |
| 3.16\dev | 3.5.x, LTS, 08 Apr 2030            | `15`  | `pip` `25.3`, `setuptools` `80.9.0`   | DEVELOPMENT             | Ready  |

**Museum versions (2.6, 3.0–3.6)** are built as-is for legacy software, with a few build-only patches
(glibc 2.41 `sinpi`, ncurses 6, multiarch paths). Known limits:
- `2.6`, `3.0`, `3.1` have no SNI in `ssl`: HTTPS to SNI-only hosts (incl. PyPI) fails, so `pip install` from PyPI does not work there — use local wheels/sdists.
- `3.0`, `3.1` ship without `pip`/`setuptools`.
- Not built on any museum version: `nis` (no `rpc/rpc.h` in glibc); `_dbm` on 3.1–3.6; `_tkinter` on 2.6/3.0; `lzma` before 3.3.

Only supported versions will be automaticly updated at CI.

## [EOL Versions](https://devguide.python.org/versions/)
| Branch | Schedule | Status      | First release | End of life | Release manager                      |
|--------|----------|-------------|---------------|-------------|--------------------------------------|
| 3.9    | PEP 596  | end-of-life | 2020-10-05    | 2025-10-31  | Łukasz Langa                         |
| 3.8    | PEP 569  | end-of-life | 2019-10-14    | 2024-10-07  | Łukasz Langa                         |
| 3.7    | PEP 537  | end-of-life | 2018-06-27    | 2023-06-27  | Ned Deily                            |
| 3.6    | PEP 494  | end-of-life | 2016-12-23    | 2021-12-23  | Ned Deily                            |
| 3.5    | PEP 478  | end-of-life | 2015-09-13    | 2020-09-30  | Larry Hastings                       |
| 3.4    | PEP 429  | end-of-life | 2014-03-16    | 2019-03-18  | Larry Hastings                       |
| 3.3    | PEP 398  | end-of-life | 2012-09-29    | 2017-09-29  | Georg Brandl &amp; Ned Deily (3.3.7) |
| 3.2    | PEP 392  | end-of-life | 2011-02-20    | 2016-02-20  | Georg Brandl                         |
| 3.1    | PEP 375  | end-of-life | 2009-06-27    | 2012-04-09  | Benjamin Peterson                    |
| 3.0    | PEP 361  | end-of-life | 2008-12-03    | 2009-06-27  | Barry Warsaw                         |
| 2.7    | PEP 373  | end-of-life | 2010-07-03    | 2020-01-01  | Benjamin Peterson                    |
| 2.6    | PEP 361  | end-of-life | 2008-10-01    | 2013-10-29  | Barry Warsaw                         |

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `2.6` | [`2.6`](2.6/Dockerfile) |
| `2.7` | [`2.7`](2.7/Dockerfile) |
| `3.0` | [`3.0`](3.0/Dockerfile) |
| `3.1` | [`3.1`](3.1/Dockerfile) |
| `3.2` | [`3.2`](3.2/Dockerfile) |
| `3.3` | [`3.3`](3.3/Dockerfile) |
| `3.4` | [`3.4`](3.4/Dockerfile) |
| `3.5` | [`3.5`](3.5/Dockerfile) |
| `3.6` | [`3.6`](3.6/Dockerfile) |
| `3.7` | [`3.7`](3.7/Dockerfile) |
| `3.8` | [`3.8`](3.8/Dockerfile) |
| `3.9` | [`3.9`](3.9/Dockerfile) |
| `3.10` | [`3.10`](3.10/Dockerfile) |
| `3.11` | [`3.11`](3.11/Dockerfile) |
| `3.12` | [`3.12`](3.12/Dockerfile) |
| `3.13` | [`3.13`](3.13/Dockerfile) |
| `3.14` | [`3.14`](3.14/Dockerfile) |
| `3.15` | [`3.15`](3.15/Dockerfile) |
| `dev`, `3.16` | [`dev`](dev/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/python:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->
