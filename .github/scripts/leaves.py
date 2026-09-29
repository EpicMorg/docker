#!/usr/bin/env python3
"""Discover buildable leaves (dirs with Dockerfile + Makefile) for CI matrices.

Prints a compact JSON array of {"name": ..., "paths": ...} objects, where
"paths" is a newline-separated list of leaf dirs (relative to the repo root)
to build in that order within one job.

  leaves.py flat DIR... [--min N] [--max N] [--include RE] [--exclude RE]
      every leaf below DIR(s) at depth min..max (depth 0 = DIR itself),
      one leaf per matrix entry.

  leaves.py group DIR TEMPLATE...
      one entry per key; TEMPLATE contains '{}' (e.g. '{}/light' or 'pure/{}'),
      keys are the children of DIR/<part of the first template before '{}'>.
      Paths are the templates that exist for that key, in the given order.

--include/--exclude are regexes matched (re.search) against the entry name.
Matrix entries are capped at 256 (GitHub limit) -- exceeding it is an error.
"""
import argparse
import json
import os
import re
import sys

PREFIXES = (
    "linux/ecosystem/apps/",
    "linux/ecosystem/base/",
    "linux/advanced/",
    "linux/obsolete/epicmorg/",
    "linux/",
)


def is_leaf(path):
    return os.path.isfile(os.path.join(path, "Dockerfile")) and os.path.isfile(
        os.path.join(path, "Makefile")
    )


def short(path):
    for p in PREFIXES:
        if path.startswith(p):
            return path[len(p):]
    return path


def vkey(s):
    return [(0, int(t), "") if t.isdigit() else (1, 0, t) for t in re.split(r"(\d+)", s) if t]


def flat(dirs, lo, hi):
    out = []
    for d in dirs:
        d = d.rstrip("/")
        base_depth = d.count("/")
        for root, subdirs, _ in os.walk(d):
            subdirs[:] = [s for s in subdirs if not s.startswith(".")]
            depth = root.count("/") - base_depth
            if depth > hi:
                subdirs[:] = []
                continue
            if depth >= lo and is_leaf(root):
                out.append({"name": short(root), "paths": root})
    return out


def group(d, templates):
    d = d.rstrip("/")
    prefix = templates[0].split("{}")[0].rstrip("/")
    kdir = os.path.join(d, prefix) if prefix else d
    out = []
    if not os.path.isdir(kdir):
        return out
    for key in os.listdir(kdir):
        if key.startswith(".") or not os.path.isdir(os.path.join(kdir, key)):
            continue
        paths = [os.path.join(d, t.replace("{}", key)) for t in templates]
        paths = [p for p in paths if is_leaf(p)]
        if paths:
            out.append({"name": short(os.path.join(d, key)) if not prefix else key,
                        "paths": "\n".join(paths)})
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", choices=("flat", "group"))
    ap.add_argument("args", nargs="+")
    ap.add_argument("--min", type=int, default=0)
    ap.add_argument("--max", type=int, default=1)
    ap.add_argument("--include")
    ap.add_argument("--exclude")
    a = ap.parse_args()

    if a.mode == "flat":
        items = flat(a.args, a.min, a.max)
    else:
        if len(a.args) < 2:
            ap.error("group needs DIR and at least one TEMPLATE")
        items = group(a.args[0], a.args[1:])

    if a.include:
        items = [i for i in items if re.search(a.include, i["name"])]
    if a.exclude:
        items = [i for i in items if not re.search(a.exclude, i["name"])]
    items.sort(key=lambda i: vkey(i["name"]))

    if len(items) > 256:
        sys.exit(f"{len(items)} matrix entries > 256 (GitHub limit); split the job")
    print(json.dumps(items, separators=(",", ":")))


if __name__ == "__main__":
    main()
