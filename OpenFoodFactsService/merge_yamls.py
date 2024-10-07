import os
import yaml
import re

def load_yaml(file_path):
    if os.path.isdir(file_path):
        print(f"Error: {file_path} is a directory, not a file.")
        return None
    print(f"Loading YAML file: {file_path}")
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

def replace_references_bottom_up(openapi_data, current_file_path):
    base_path = os.path.dirname(current_file_path)
    # Find all references and replace them in a bottom-up manner
    references_to_replace = []
    if isinstance(openapi_data, dict):
        for key, value in openapi_data.items():
            if key == '$ref' and isinstance(value, str):
                references_to_replace.append((key, value))
            else:
                replace_references_bottom_up(value, current_file_path)
    elif isinstance(openapi_data, list):
        for item in openapi_data:
            replace_references_bottom_up(item, current_file_path)
    
    # Replace references after traversing deeply
    for key, value in references_to_replace:
        ref_file_path, ref_anchor = parse_reference(value, base_path)
        print(f"Resolving reference for key: {key}, from file: {ref_file_path}, anchor: {ref_anchor}")
        if os.path.exists(ref_file_path) and not os.path.isdir(ref_file_path):
            referenced_data = load_yaml(ref_file_path)
            if referenced_data is None:
                continue
            # Traverse to the desired anchor (property) if present
            if ref_anchor:
                referenced_data = traverse_to_anchor(referenced_data, ref_anchor)
            replace_references_bottom_up(referenced_data, ref_file_path)
            if isinstance(referenced_data, dict):
                openapi_data.update(referenced_data)
            else:
                openapi_data[key] = referenced_data
            del openapi_data[key]
        else:
            print(f"Reference file not found or is a directory: {ref_file_path}")

def parse_reference(ref_value, base_path):
    # Split the reference into the file path and anchor (if any)
    ref_parts = ref_value.split('#')
    ref_file_path = os.path.join(base_path, ref_parts[0])
    ref_file_path = os.path.normpath(ref_file_path)
    ref_anchor = ref_parts[1] if len(ref_parts) > 1 else None
    return ref_file_path, ref_anchor

def traverse_to_anchor(data, anchor):
    # Traverse the data structure to find the anchor location
    parts = anchor.strip('/').split('/')
    for part in parts:
        if isinstance(data, dict) and part in data:
            data = data[part]
        else:
            print(f"Anchor part '{part}' not found in data.")
            return None
    return data

def dereference_yaml(input_file):
    yaml_data = load_yaml(input_file)
    if yaml_data is None:
        print(f"Error: Failed to load YAML file: {input_file}")
        return
    while True:
        references_before = count_references(yaml_data)
        replace_references_bottom_up(yaml_data, input_file)
        references_after = count_references(yaml_data)
        if references_before == references_after:
            break
    
    # Save the fully dereferenced YAML data
    with open(input_file, 'w') as file:
        print(f"Saving dereferenced file: {input_file}")
        yaml.dump(yaml_data, file, sort_keys=False)

def count_references(openapi_data):
    if isinstance(openapi_data, dict):
        return sum(1 for key, value in openapi_data.items() if key == '$ref') + sum(count_references(value) for value in openapi_data.values())
    elif isinstance(openapi_data, list):
        return sum(count_references(item) for item in openapi_data)
    return 0

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    print(f"Starting to dereference YAML file: {input_file}")
    dereference_yaml(input_file)
    print(f"All references have been dereferenced in the YAML file: {input_file}")