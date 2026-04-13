# -*- coding: utf-8 -*-
"""
Design System Generator - Aggregates search results and applies reasoning
"""

import csv
import json
import os
from datetime import datetime
from pathlib import Path
import sys

# Ensure core is in path
sys.path.append(str(Path(__file__).parent))
from core import search, DATA_DIR

# ============ CONFIGURATION ============
REASONING_FILE = "ui-reasoning.csv"

SEARCH_CONFIG = {
    "product": {"max_results": 1},
    "style": {"max_results": 3},
    "color": {"max_results": 2},
    "landing": {"max_results": 2},
    "typography": {"max_results": 2}
}

class DesignSystemGenerator:
    """Generates design system recommendations from aggregated searches."""

    def __init__(self):
        self.reasoning_data = self._load_reasoning()

    def _load_reasoning(self) -> list:
        """Load reasoning rules from CSV."""
        filepath = DATA_DIR / REASONING_FILE
        if not filepath.exists():
            return []
        with open(filepath, 'r', encoding='utf-8') as f:
            return list(csv.DictReader(f))

    def _multi_domain_search(self, query: str, style_priority: list = None) -> dict:
        """Execute searches across multiple domains."""
        results = {}
        for domain, config in SEARCH_CONFIG.items():
            if domain == "style" and style_priority:
                # For style, also search with priority keywords
                priority_query = " ".join(style_priority[:2]) if style_priority else query
                combined_query = f"{query} {priority_query}"
                results[domain] = search(combined_query, domain, config["max_results"])
            else:
                results[domain] = search(query, domain, config["max_results"])
        return results

    def _find_reasoning_rule(self, category: str) -> dict:
        """Find matching reasoning rule for a category."""
        category_lower = category.lower()

        # Try exact match first
        for rule in self.reasoning_data:
            if rule.get("UI_Category", "").lower() == category_lower:
                return rule

        # Try partial match
        for rule in self.reasoning_data:
            ui_cat = rule.get("UI_Category", "").lower()
            if ui_cat in category_lower or category_lower in ui_cat:
                return rule

        return {}

    def generate(self, query: str, project_name: str = None) -> dict:
        """Execute the full generation pipeline."""
        # Domain detection for the main query
        category = query # Simplified for now

        # Apply reasoning to get initial strategy
        strategy = self._find_reasoning_rule(category)
        style_priority = [s.strip() for s in strategy.get("Style_Priority", "").split("+")] if strategy else []

        # Execute searches
        searches = self._multi_domain_search(query, style_priority)

        # Build final system (Simplified placeholder logic)
        product_results = searches.get("product", {}).get("results", [])
        style_results = searches.get("style", {}).get("results", [])
        color_results = searches.get("color", {}).get("results", [])
        landing_results = searches.get("landing", {}).get("results", [])
        typography_results = searches.get("typography", {}).get("results", [])

        # Default fallback results
        style = style_results[0] if style_results else {"Style Category": "Minimalism", "Keywords": "clean, white space"}
        color = color_results[0] if color_results else {"Primary": "#2563EB", "Background": "#F8FAFC"}
        typography = typography_results[0] if typography_results else {"Heading Font": "Inter", "Body Font": "Inter"}
        pattern = landing_results[0] if landing_results else {"Pattern Name": "Standard Landing"}

        return {
            "project_name": project_name or "Project",
            "category": category,
            "style": {
                "name": style.get("Style Category", "Minimalism"),
                "keywords": style.get("Keywords", ""),
                "best_for": style.get("Best For", ""),
                "performance": style.get("Performance", "Fast"),
                "accessibility": style.get("Accessibility", "High")
            },
            "colors": {
                "primary": color.get("Primary", "#2563EB"),
                "secondary": color.get("Secondary", "#3B82F6"),
                "cta": color.get("Accent", "#F97316"),
                "background": color.get("Background", "#FFFFFF"),
                "text": color.get("Foreground", "#1E293B"),
                "notes": color.get("Notes", "")
            },
            "typography": {
                "heading": typography.get("Heading Font", "Inter"),
                "body": typography.get("Body Font", "Inter"),
                "mood": typography.get("Mood/Style Keywords", ""),
                "best_for": typography.get("Best For", ""),
                "google_fonts_url": typography.get("Google Fonts URL", ""),
                "css_import": typography.get("CSS Import", "")
            },
            "pattern": {
                "name": pattern.get("Pattern Name", "Standard Landing"),
                "conversion": pattern.get("Conversion Optimization", ""),
                "cta_placement": pattern.get("Primary CTA Placement", ""),
                "sections": pattern.get("Section Order", "")
            },
            "key_effects": strategy.get("Key_Effects", "") if strategy else "Subtle hover transitions",
            "anti_patterns": strategy.get("Anti_Patterns", "") if strategy else ""
        }

def format_ascii_box(design_system: dict) -> str:
    """ASCII box formatter (Simplified)"""
    lines = []
    lines.append("-" * 60)
    lines.append(f"DESIGN SYSTEM FOR: {design_system['project_name']}")
    lines.append("-" * 60)
    lines.append(f"STYLE: {design_system['style']['name']}")
    lines.append(f"COLORS: {design_system['colors']['primary']} Primary")
    lines.append(f"TYPOGRAPHY: {design_system['typography']['heading']}")
    lines.append("-" * 60)
    return "\n".join(lines)

def persist_design_system(design_system: dict, page: str = None, output_dir: str = None, page_query: str = None):
    """Persistence logic (Simplified)"""
    base_dir = Path(output_dir) if output_dir else Path.cwd() / "design-system"
    base_dir.mkdir(parents=True, exist_ok=True)
    
    master_file = base_dir / "MASTER.md"
    with open(master_file, 'w', encoding='utf-8') as f:
        f.write(f"# Design System Master\n\nProject: {design_system['project_name']}\n")

def generate_design_system(query: str, project_name: str = None, output_format: str = "ascii", 
                           persist: bool = False, page: str = None, output_dir: str = None) -> str:
    generator = DesignSystemGenerator()
    design_system = generator.generate(query, project_name)
    if persist:
        persist_design_system(design_system, page, output_dir, query)
    return format_ascii_box(design_system)

if __name__ == "__main__":
    result = generate_design_system("SaaS dashboard")
    print(result)
