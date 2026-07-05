#!/usr/bin/env python3
"""Query /v1/models from any OpenAI-compatible endpoint.

Usage:
  ./models.py <base_url> [api_key] [--free]

Examples:
  ./models.py https://openrouter.ai/api/v1
  ./models.py https://openrouter.ai/api/v1 --free
  ./models.py https://api.freetheai.xyz/v1 $FREETHEAI_API_KEY --free
"""

import json
import sys
from collections import OrderedDict
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen


def fetch_json(url: str, headers: dict) -> dict:
  req = Request(url, headers=headers)
  with urlopen(req, timeout=15) as resp:
    return json.loads(resp.read().decode())


def is_free(model: dict) -> bool:
  pricing = model.get("pricing") or {}
  mid = model.get("id", "") or ""
  return (
    pricing.get("prompt") == "0"
    or pricing.get("completion") == "0"
    or ":free" in mid
    or mid.startswith("opc/")
    or mid.startswith("kai/")
  )


def provider_group(model_id: str) -> str:
  return model_id.split("/")[0] if "/" in model_id else "other"


def main():
  args = sys.argv[1:]

  if not args or args[0] in ("-h", "--help"):
    print((__doc__ or "").strip())
    sys.exit(1)

  base_url = args[0].rstrip("/")
  api_key = ""
  show_free = False
  mode = "all"

  if len(args) >= 3 and args[2] == "--free":
    show_free = True
    mode = "free"
    api_key = args[1]
  elif len(args) >= 2:
    if args[1] == "--free":
      show_free = True
      mode = "free"
    else:
      api_key = args[1]

  headers = {"Content-Type": "application/json"}
  if api_key:
    headers["Authorization"] = f"Bearer {api_key}"

  for path in ("/models/full", "/models"):
    url = f"{base_url}{path}"
    try:
      data = fetch_json(url, headers)
      break
    except (HTTPError, URLError):
      continue
  else:
    print(f"Failed to fetch models from {base_url}/models", file=sys.stderr)
    sys.exit(1)

  models = data.get("data", data) if isinstance(data, dict) else data
  if not isinstance(models, list):
    print(f"Unexpected response format: {type(models).__name__}", file=sys.stderr)
    sys.exit(1)

  filtered = [m for m in models if m.get("id") and (not show_free or is_free(m))]
  free_count = sum(1 for m in models if m.get("id") and is_free(m))

  groups = OrderedDict()
  for m in filtered:
    mid = m.get("id", "")
    group = provider_group(mid)
    groups.setdefault(group, []).append(m)

  groups = OrderedDict(sorted(groups.items()))
  for group in groups:
    groups[group].sort(key=lambda m: m.get("id", ""))

  host = base_url.replace("https://", "").replace("http://", "")
  print()
  print(f"  {host}")
  print(f"  mode: {mode}  |  {len(filtered)} shown / {len(models)} total (free: {free_count})")
  print()

  for group, items in groups.items():
    print(f"  {group}")
    for m in items:
      mid = m.get("id", "")
      tag = "  (free)" if is_free(m) else ""
      print(f"    {mid}{tag}")
    print()


if __name__ == "__main__":
  main()
