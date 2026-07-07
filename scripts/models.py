#!/usr/bin/env python3
"""Query /v1/models from any OpenAI or OpenAI-compatible endpoint.

Usage:
  ./models.py <base_url> [api_key] [--free]

Examples:
  # Native OpenAI (Note: Requires a billing-active key to list all models)
  ./models.py https://api.openai.com/v1 $OPENAI_API_KEY

  # Groq Cloud
  ./models.py https://api.api.groq.com/openai/v1 $GROQ_API_KEY

  # OpenRouter (Aggregator)
  ./models.py https://openrouter.ai/api/v1 --free
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
    """Detects if a model is free.
    Handles OpenRouter style custom fields safely without crashing on native OpenAI.
    """
    pricing = model.get("pricing") or {}
    mid = model.get("id", "") or ""

    # Check explicitly defined free pricing, OpenRouter conventions, or free tags
    return (
        str(pricing.get("prompt")) == "0"
        or str(pricing.get("completion")) == "0"
        or ":free" in mid
        or mid.startswith("opc/")
        or mid.startswith("kai/")
    )


def provider_group(model_id: str, base_url: str) -> str:
    """Groups models logically.
    If it's OpenRouter, it groups by provider (e.g. 'meta-llama').
    If it's native OpenAI or a single-provider endpoint, it groups by category or vendor.
    """
    if "openrouter" in base_url and "/" in model_id:
        return model_id.split("/")[0]

    # Group native OpenAI or common prefixes
    if (
        model_id.startswith("gpt-")
        or model_id.startswith("o1")
        or model_id.startswith("o3")
    ):
        return "openai"
    elif model_id.startswith("llama"):
        return "meta"
    elif model_id.startswith("claude"):
        return "anthropic"
    elif "/" in model_id:
        return model_id.split("/")[0]

    return "other"


def main():
    args = sys.argv[1:]

    if not args or args[0] in ("-h", "--help"):
        print((__doc__ or "").strip())
        sys.exit(1)

    # Normalize Base URL: Ensure it doesn't end with a slash, and auto-append '/v1' if missing
    base_url = args[0].rstrip("/")
    if not base_url.endswith("/v1") and not "/v1/" in base_url:
        # Don't append if it's already a deeply nested proxy path, but do for common domains
        if any(
            domain in base_url
            for domain in ["openai.com", "groq.com", "openrouter.ai", "together.xyz"]
        ):
            base_url = f"{base_url}/v1"

    api_key = ""
    show_free = False
    mode = "all"

    # Parse arguments more reliably
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

    headers = {
        "Content-Type": "application/json",
        "User-Agent": "OpenAI-Model-Scanner/1.0",
    }
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"

    # Try paths sequentially. Standard OpenAI relies solely on '/models'
    paths = ("/models", "/models/full")
    data = None

    for path in paths:
        url = f"{base_url}{path}"
        try:
            data = fetch_json(url, headers)
            break
        except (HTTPError, URLError) as e:
            # If it's a 401/403, fail immediately instead of looping (it's an auth error)
            if isinstance(e, HTTPError) and e.code in (401, 403):
                print(
                    f"Authentication Error: Received {e.code} from {url}. Check your API key.",
                    file=sys.stderr,
                )
                sys.exit(1)
            continue

    if data is None:
        print(
            f"Failed to fetch models from {base_url}. Ensure the endpoint is correct.",
            file=sys.stderr,
        )
        sys.exit(1)

    # Unify model parsing (Standard OpenAI payload encapsulates objects under a 'data' array)
    models = data.get("data", data) if isinstance(data, dict) else data
    if not isinstance(models, list):
        print(f"Unexpected response format: {type(models).__name__}", file=sys.stderr)
        sys.exit(1)

    filtered = [m for m in models if m.get("id") and (not show_free or is_free(m))]
    free_count = sum(1 for m in models if m.get("id") and is_free(m))

    groups = OrderedDict()
    for m in filtered:
        mid = m.get("id", "")
        group = provider_group(mid, base_url)
        groups.setdefault(group, []).append(m)

    groups = OrderedDict(sorted(groups.items()))
    for group in groups:
        groups[group].sort(key=lambda m: m.get("id", ""))

    host = base_url.replace("https://", "").replace("http://", "")
    print()
    print(f"  {host}")
    print(
        f"  mode: {mode}  |  {len(filtered)} shown / {len(models)} total (free: {free_count})"
    )
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
