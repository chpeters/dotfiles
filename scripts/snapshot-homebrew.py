#!/usr/bin/env python3
"""Refresh the installed Homebrew inventory without installing or upgrading."""
import datetime
import json
from pathlib import Path
import subprocess

inventory = json.loads(subprocess.check_output(
    ["brew", "info", "--json=v2", "--installed"], text=True
))
snapshot = {
    "captured_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "homebrew_version": subprocess.check_output(["brew", "--version"], text=True).strip(),
    "formulae": {
        item["full_name"]: sorted({version["version"] for version in item["installed"]})
        for item in sorted(inventory["formulae"], key=lambda item: item["full_name"])
    },
    "casks": {
        item["full_token"]: item["installed"]
        for item in sorted(inventory["casks"], key=lambda item: item["full_token"])
    },
}
target = Path(__file__).resolve().parents[1] / "macos/Brewfile.snapshot.json"
temporary = target.with_suffix(".json.tmp")
temporary.write_text(json.dumps(snapshot, indent=2) + "\n")
temporary.replace(target)
print(f"Wrote {target}")
