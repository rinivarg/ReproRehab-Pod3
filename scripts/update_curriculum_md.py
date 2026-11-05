#!/usr/bin/env python3
from __future__ import annotations

import os
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README_PATH = ROOT / "README.md"
OUTPUT_PATH = ROOT / "Curriculum" / "CURRICULUM.md"


def extract_curriculum_section(readme_text: str) -> str:
    start_match = re.search(r"(?m)^#\s+Curriculum\s*$", readme_text)
    if not start_match:
        raise RuntimeError("Could not find '# Curriculum' section in README.md.")

    section_start = start_match.end()
    remainder = readme_text[section_start:]
    next_header_match = re.search(r"(?m)^#\s+.+$", remainder)
    section_end = section_start + next_header_match.start() if next_header_match else len(readme_text)

    section = readme_text[section_start:section_end].strip()
    if not section:
        raise RuntimeError("The Curriculum section in README.md is empty.")
    return section


def extract_cohort_year(readme_text: str) -> str:
    description = os.getenv("REPO_DESCRIPTION", "")
    if description:
        description_match = re.search(r"(20\d{2}(?:[-/]\d{2,4})?)", description)
        if description_match:
            return description_match.group(1)

    readme_match = re.search(r"(?m)^#.*\((20\d{2}(?:[-/]\d{2,4})?)\)", readme_text)
    if readme_match:
        return readme_match.group(1)

    return "Unknown Cohort"


def main() -> None:
    readme_text = README_PATH.read_text(encoding="utf-8")
    curriculum_section = extract_curriculum_section(readme_text)
    cohort_year = extract_cohort_year(readme_text)

    content = (
        f"# Curriculum ({cohort_year})\n\n"
        "_This file is auto-generated from the Curriculum section in the parent README.md._\n\n"
        f"{curriculum_section}\n"
    )
    OUTPUT_PATH.write_text(content, encoding="utf-8")


if __name__ == "__main__":
    main()
