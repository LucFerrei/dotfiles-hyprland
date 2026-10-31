#!/usr/bin/env python3
"""Validate structured config files that do not need a running application."""

from __future__ import annotations

import configparser
import json
import re
import sys
import tomllib
import xml.etree.ElementTree as ET
from pathlib import Path

import json5
import tinycss2
import yaml

ROOT = Path(__file__).resolve().parents[2]
ERRORS: list[str] = []


def rel(path: Path) -> Path:
    return path.relative_to(ROOT)


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def add_error(path: Path, message: str) -> None:
    ERRORS.append(f"{rel(path)}: {message}")


def check_toml(path: Path) -> dict:
    try:
        data = tomllib.loads(read(path))
    except Exception as exc:  # noqa: BLE001 - report the parser message
        add_error(path, f"invalid TOML: {exc}")
        return {}
    return data


def check_json(path: Path, *, jsonc: bool = False) -> None:
    try:
        if jsonc:
            json5.loads(read(path))
        else:
            json.loads(read(path))
    except Exception as exc:  # noqa: BLE001
        add_error(path, f"invalid {'JSONC' if jsonc else 'JSON'}: {exc}")


def check_yaml(path: Path) -> None:
    try:
        yaml.safe_load(read(path))
    except Exception as exc:  # noqa: BLE001
        add_error(path, f"invalid YAML: {exc}")


def check_css(path: Path) -> None:
    try:
        nodes = tinycss2.parse_stylesheet(
            read(path), skip_comments=True, skip_whitespace=True
        )
    except Exception as exc:  # noqa: BLE001
        add_error(path, f"invalid CSS: {exc}")
        return

    for node in nodes:
        if node.type == "error":
            add_error(path, f"CSS line {node.source_line}: {node.message}")


def check_xml(path: Path) -> None:
    try:
        ET.parse(path)
    except Exception as exc:  # noqa: BLE001
        add_error(path, f"invalid XML: {exc}")


def check_ini(path: Path) -> None:
    parser = configparser.ConfigParser(strict=False)
    try:
        parser.read_string(read(path), source=str(rel(path)))
    except Exception as exc:  # noqa: BLE001
        add_error(path, f"invalid INI: {exc}")


def check_alacritty_imports(path: Path, data: dict) -> None:
    imports = data.get("general", {}).get("import", [])
    if not isinstance(imports, list):
        add_error(path, "general.import must be a list")
        return

    for entry in imports:
        if not isinstance(entry, str):
            add_error(path, "general.import entries must be strings")
            continue
        relative = entry.replace("~/.config/alacritty/", "")
        target = ROOT / "alacritty" / relative
        if not target.exists():
            add_error(path, f"imported config not found: {entry}")


def check_hypr_sources(path: Path) -> None:
    prefixes = (
        "$HOME/personal/dotfiles-hyprland/",
        "~/.config/hypr/",
        "$HOME/.config/hypr/",
    )

    for line_number, line in enumerate(read(path).splitlines(), start=1):
        match = re.match(r"\s*source\s*=\s*(.+?)\s*$", line)
        if not match:
            continue

        source = match.group(1)
        for prefix in prefixes:
            source = source.replace(prefix, "")

        target = ROOT / source
        if not target.exists():
            add_error(path, f"line {line_number}: sourced file not found: {source}")


def main() -> int:
    toml_files = sorted(
        set(ROOT.glob("alacritty/*.toml"))
        | set(ROOT.glob("i3status-rust/*.toml"))
        | set(ROOT.glob("tmx/*.toml"))
        | set(ROOT.glob("yazi/**/*.toml"))
        | set(ROOT.glob("zmx/*.toml"))
    )
    for path in toml_files:
        data = check_toml(path)
        if path.parent.name == "alacritty" and data:
            check_alacritty_imports(path, data)

    check_json(ROOT / "waybar/config.jsonc", jsonc=True)
    check_json(ROOT / "nvim_scratch/lazy-lock.json")

    check_yaml(ROOT / "eza/theme.yml")

    for path in (ROOT / "waybar/style.css", ROOT / "wofi/style.css"):
        check_css(path)

    check_xml(ROOT / "xournalpp/settings.xml")
    check_ini(ROOT / "mimeapps.list")

    for path in sorted((ROOT / "hypr").glob("*.conf")):
        check_hypr_sources(path)

    if ERRORS:
        for error in ERRORS:
            print(f"::error title=config validation::{error}")
            print(error, file=sys.stderr)
        return 1

    print(
        "structured configs: "
        f"{len(toml_files)} TOML, 2 JSON/JSONC, 1 YAML, 2 CSS, 1 XML, "
        f"{len(list((ROOT / 'hypr').glob('*.conf')))} Hyprland source files ok"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
