#!/usr/bin/env python3
"""
Script to add all missing files directly to Xcode project.pbxproj
"""

import os
import re
import uuid
import subprocess
from pathlib import Path

PROJECT_DIR = Path(__file__).parent.parent
PBXPROJ_PATH = PROJECT_DIR / "PatternSorcerer.xcodeproj" / "project.pbxproj"

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode project"""
    return ''.join(str(uuid.uuid4()).replace('-', '').upper()[:24])

def get_all_swift_files():
    """Get all Swift files from filesystem"""
    swift_files = []
    for root, dirs, files in os.walk(PROJECT_DIR):
        # Skip hidden directories and build artifacts
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']
        for file in files:
            if file.endswith('.swift'):
                full_path = Path(root) / file
                rel_path = full_path.relative_to(PROJECT_DIR)
                swift_files.append(str(rel_path))
    return sorted(swift_files)

def get_existing_file_refs(content):
    """Extract existing file references from pbxproj"""
    # Pattern: UUID /* filename.swift */ = {isa = PBXFileReference; ... path = filename.swift; ...}
    pattern = r'([A-F0-9]{24}) /\* ([^/\*]+\.swift) \*/ = \{isa = PBXFileReference[^}]+\}'
    matches = re.findall(pattern, content)
    return {filename: uuid for uuid, filename in matches}

def get_target_uuid(content, target_name="PatternSorcerer"):
    """Get the UUID of the main target"""
    # Find target section
    pattern = rf'{target_name} = {{isa = PBXNativeTarget; name = {target_name};'
    match = re.search(pattern, content)
    if match:
        # Get the UUID before the target name
        before_match = content[:match.start()]
        # Find the UUID (24 hex chars) before the target
        uuid_match = re.search(r'([A-F0-9]{24}) = \{', before_match[-100:])
        if uuid_match:
            return uuid_match.group(1)
    return None

def get_sources_build_phase_uuid(content, target_uuid):
    """Get the UUID of the Sources build phase for the target"""
    # Find the buildPhases array for the target
    pattern = rf'{target_uuid} = {{[^}}]*buildPhases = \(\s*([^)]+)\s*\);'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        build_phases = match.group(1)
        # Find Sources build phase
        sources_pattern = r'([A-F0-9]{24}) /\* Sources \*/'
        sources_match = re.search(sources_pattern, build_phases)
        if sources_match:
            return sources_match.group(1)

    # Alternative: find PBXSourcesBuildPhase section
    pattern = r'([A-F0-9]{24}) /\* Sources \*/ = \{isa = PBXSourcesBuildPhase'
    match = re.search(pattern, content)
    if match:
        return match.group(1)
    return None

def get_main_group_uuid(content):
    """Get the UUID of the main group"""
    pattern = r'rootObject = ([A-F0-9]{24}) /\* Project object \*/'
    match = re.search(pattern, content)
    if not match:
        return None

    project_uuid = match.group(1)
    # Find the mainGroup reference
    pattern = rf'{project_uuid} = \{{[^}}]*mainGroup = ([A-F0-9]{24});'
    match = re.search(pattern, content)
    if match:
        return match.group(1)
    return None

def add_file_to_project(content, file_path, existing_refs, main_group_uuid, sources_phase_uuid):
    """Add a file to the project if it doesn't exist"""
    filename = os.path.basename(file_path)

    # Check if file already exists
    if filename in existing_refs:
        print(f"  ✓ {filename} already in project")
        return content, existing_refs[filename]

    # Generate UUIDs
    file_ref_uuid = generate_uuid()
    build_file_uuid = generate_uuid()

    print(f"  + Adding {filename}")

    # Create file reference
    file_ref = f'\t\t{file_ref_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = "<group>"; }};\n'

    # Create build file
    build_file = f'\t\t{build_file_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* {filename} */; }};\n'

    # Find where to insert file references (after last PBXFileReference)
    file_ref_pattern = r'(PBXFileReference section\s*\n)'
    file_ref_match = re.search(file_ref_pattern, content)
    if file_ref_match:
        insert_pos = file_ref_match.end()
        # Find the end of PBXFileReference section
        end_pattern = r'(\t\t[A-F0-9]{24} /\* [^/\*]+ \*/ = \{isa = PBXFileReference[^}]+\};\n)(\s*/\* End PBXFileReference section \*/\n)'
        end_match = re.search(end_pattern, content[insert_pos:])
        if end_match:
            insert_pos = insert_pos + end_match.start() + len(end_match.group(1))
            content = content[:insert_pos] + file_ref + content[insert_pos:]
        else:
            # Insert before End PBXFileReference section
            end_section = content.find('/* End PBXFileReference section */', insert_pos)
            if end_section > 0:
                content = content[:end_section] + file_ref + '\t\t' + content[end_section:]
    else:
        # Fallback: insert before PBXGroup section
        group_pattern = r'/\* Begin PBXGroup section \*/'
        group_match = re.search(group_pattern, content)
        if group_match:
            content = content[:group_match.start()] + file_ref + content[group_match.start():]

    # Add build file
    build_file_pattern = r'(PBXBuildFile section\s*\n)'
    build_file_match = re.search(build_file_pattern, content)
    if build_file_match:
        insert_pos = build_file_match.end()
        end_pattern = r'(\t\t[A-F0-9]{24} /\* [^/\*]+ \*/ = \{isa = PBXBuildFile[^}]+\};\n)(\s*/\* End PBXBuildFile section \*/\n)'
        end_match = re.search(end_pattern, content[insert_pos:])
        if end_match:
            insert_pos = insert_pos + end_match.start() + len(end_match.group(1))
            content = content[:insert_pos] + build_file + content[insert_pos:]
        else:
            end_section = content.find('/* End PBXBuildFile section */', insert_pos)
            if end_section > 0:
                content = content[:end_section] + build_file + '\t\t' + content[end_section:]

    # Add to sources build phase
    if sources_phase_uuid:
        pattern = rf'({sources_phase_uuid} /\* Sources \*/ = {{[^}}]*files = \(\s*)([^)]*)(\s*\);'
        match = re.search(pattern, content, re.DOTALL)
        if match:
            files_list = match.group(2)
            new_file_entry = f'\t\t\t\t{build_file_uuid} /* {filename} in Sources */,\n'
            # Insert before the closing parenthesis
            files_list = files_list.rstrip() + '\n' + new_file_entry
            content = content[:match.start()] + match.group(1) + files_list + match.group(3) + content[match.end():]

    # Add to appropriate group (simplified - add to main group for now)
    if main_group_uuid:
        pattern = rf'({main_group_uuid} = {{[^}}]*children = \(\s*)([^)]*)(\s*\);'
        match = re.search(pattern, content, re.DOTALL)
        if match:
            children = match.group(2)
            new_child = f'\t\t\t\t{file_ref_uuid} /* {filename} */,\n'
            children = children.rstrip() + '\n' + new_child
            content = content[:match.start()] + match.group(1) + children + match.group(3) + content[match.end():]

    existing_refs[filename] = file_ref_uuid
    return content, file_ref_uuid

def main():
    print("=== Adding files to Xcode project ===")
    print()

    if not PBXPROJ_PATH.exists():
        print(f"Error: {PBXPROJ_PATH} not found!")
        return 1

    # Read current project file
    with open(PBXPROJ_PATH, 'r') as f:
        content = f.read()

    # Get all Swift files
    swift_files = get_all_swift_files()
    print(f"Found {len(swift_files)} Swift files on disk")

    # Get existing file references
    existing_refs = get_existing_file_refs(content)
    print(f"Found {len(existing_refs)} existing file references in project")
    print()

    # Get target and build phase UUIDs
    target_uuid = get_target_uuid(content)
    sources_phase_uuid = get_sources_build_phase_uuid(content, target_uuid)
    main_group_uuid = get_main_group_uuid(content)

    print(f"Target UUID: {target_uuid}")
    print(f"Sources phase UUID: {sources_phase_uuid}")
    print(f"Main group UUID: {main_group_uuid}")
    print()

    # Add missing files
    added_count = 0
    for file_path in swift_files:
        if os.path.basename(file_path) not in existing_refs:
            try:
                content, _ = add_file_to_project(content, file_path, existing_refs, main_group_uuid, sources_phase_uuid)
                added_count += 1
            except Exception as e:
                print(f"  ✗ Error adding {os.path.basename(file_path)}: {e}")

    if added_count > 0:
        # Backup original
        backup_path = PBXPROJ_PATH.with_suffix('.pbxproj.backup')
        with open(backup_path, 'w') as f:
            f.write(open(PBXPROJ_PATH).read())
        print(f"\nBackup created: {backup_path}")

        # Write updated content
        with open(PBXPROJ_PATH, 'w') as f:
            f.write(content)
        print(f"\n✓ Added {added_count} files to project")
        print("Please close and reopen Xcode to see changes")
    else:
        print("\n✓ All files already in project")

    return 0

if __name__ == '__main__':
    exit(main())

