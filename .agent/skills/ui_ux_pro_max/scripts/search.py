# -*- coding: utf-8 -*-
"""
UI/UX Pro Max Search - BM25 search engine for UI/UX style guides
"""

import argparse
import sys
import io
import os
from pathlib import Path

# Fix for Windows encoding issues
if sys.stdout.encoding != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
if sys.stderr.encoding != 'utf-8':
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# Ensure core scripts are in path
sys.path.append(str(Path(__file__).parent))

from core import CSV_CONFIG, AVAILABLE_STACKS, MAX_RESULTS, search, search_stack
from design_system import generate_design_system, persist_design_system

def main():
    parser = argparse.ArgumentParser(description="UI/UX Pro Max Search")
    parser.add_argument("query", help="Search query")
    parser.add_argument("--domain", "-d", type=str, default=None, help="Domain to search")
    parser.add_argument("--stack", "-s", type=str, default=None, help="Stack to search")
    parser.add_argument("--max-results", "-n", type=int, default=MAX_RESULTS, help="Max results")
    parser.add_argument("--design-system", action="store_true", help="Generate design system")
    parser.add_argument("--persist", action="store_true", help="Persist design system")
    parser.add_argument("--project-name", "-p", type=str, default=None, help="Project name")
    parser.add_argument("--page", type=str, default=None, help="Page name for override")

    args = parser.parse_args()

    if args.design_system:
        result = generate_design_system(args.query, args.project_name, persist=args.persist, page=args.page)
        print(result)
    elif args.stack:
        result = search_stack(args.query, args.stack, args.max_results)
        print(result)
    else:
        result = search(args.query, args.domain, args.max_results)
        print(result)

if __name__ == "__main__":
    main()
