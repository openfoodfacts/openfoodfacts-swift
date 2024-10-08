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

def replace_references_bottom_up(openapi_data, current_file_path, components):
    base_path = os.path.dirname(current_file_path)
    # Find all references and replace them in a bottom-up manner
    references_to_replace = []
    if isinstance(openapi_data, dict):
        for key, value in openapi_data.items():
            if key == '$ref' and isinstance(value, str):
                if not value.endswith('example'):
                    references_to_replace.append((key, value))
            elif key == 'examples' and isinstance(value, dict):
                # Handle example references separately to directly insert them as YAML code
                for example_key, example_value in value.items():
                    if isinstance(example_value, dict) and '$ref' in example_value:
                        ref_file_path, ref_anchor = parse_reference(example_value['$ref'], base_path)
                        if os.path.exists(ref_file_path) and not os.path.isdir(ref_file_path):
                            referenced_data = load_yaml(ref_file_path)
                            if referenced_data is not None:
                                if ref_anchor:
                                    referenced_data = traverse_to_anchor(referenced_data, ref_anchor)
                                value[example_key] = referenced_data
            elif key == 'type' and value == 'int':
                # Replace 'type: int' with 'type: integer'
                openapi_data[key] = 'integer'
            else:
                replace_references_bottom_up(value, current_file_path, components)
    elif isinstance(openapi_data, list):
        for item in openapi_data:
            replace_references_bottom_up(item, current_file_path, components)
    
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
            replace_references_bottom_up(referenced_data, ref_file_path, components)
            
            # Add the referenced data into appropriate components section
            component_name = generate_component_name(ref_file_path, ref_anchor)
            if is_parameter_reference(ref_anchor, ref_file_path):
                components.setdefault('parameters', {})[component_name] = referenced_data
                openapi_data[key] = f"#/components/parameters/{component_name}"
            else:
                components.setdefault('schemas', {})[component_name] = referenced_data
                openapi_data[key] = f"#/components/schemas/{component_name}"
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

def generate_component_name(ref_file_path, ref_anchor):
    # Generate a unique component name based on the file path and anchor
    component_name = os.path.basename(ref_file_path).replace('.yaml', '')
    if ref_anchor:
        anchor_parts = ref_anchor.strip('/').split('/')
        component_name += '_' + '_'.join(anchor_parts)
    return component_name

def is_parameter_reference(ref_anchor, ref_file_path):
    # Determine if the reference should be placed under parameters or schemas
    if ref_anchor and ('parameters' in ref_anchor or 'properties' in ref_anchor):
        return True
    if 'parameters' in ref_file_path:
        return True
    return False

def dereference_yaml(input_file):
    yaml_data = load_yaml(input_file)
    if yaml_data is None:
        print(f"Error: Failed to load YAML file: {input_file}")
        return
    components = yaml_data.setdefault('components', {})
    while True:
        references_before = count_references(yaml_data)
        replace_references_bottom_up(yaml_data, input_file, components)
        references_after = count_references(yaml_data)
        if references_before == references_after:
            break
    
    # Save the fully dereferenced YAML data
    with open(input_file, 'w') as file:
        print(f"Saving dereferenced file: {input_file}")
        yaml.dump(yaml_data, file, sort_keys=False)

def unwind_pattern_properties(input_file):
    yaml_data = load_yaml(input_file)
    if yaml_data is None:
        print(f"Error: Failed to load YAML file: {input_file}")
        return
    
    def unwind_properties(data):
        if isinstance(data, dict):
            for key, value in list(data.items()):
                if key == 'patternProperties' and isinstance(value, dict):
                    # Unwind patternProperties into simple properties
                    for pattern_key, pattern_value in value.items():
                        # Handle regex keys like (?<nutrient>[\w-]+)_unit and replace with example key
                        regex_match = re.match(r'\(\?<(?P<key>\w+)>.*\)', pattern_key)
                        if regex_match:
                            pattern_key = regex_match.group('key') + '_example'
                        print(f"Unwinding patternProperties: {pattern_key}")
                        data.setdefault('properties', {})[pattern_key] = pattern_value
                    del data['patternProperties']
                else:
                    unwind_properties(value)
        elif isinstance(data, list):
            for item in data:
                unwind_properties(item)
    
    unwind_properties(yaml_data)
    
    # Save the updated YAML data
    with open(input_file, 'w') as file:
        print(f"Saving file after unwinding patternProperties: {input_file}")
        yaml.dump(yaml_data, file, sort_keys=False)

def replace_all_of(input_file):
    yaml_data = load_yaml(input_file)
    if yaml_data is None:
        print(f"Error: Failed to load YAML file: {input_file}")
        return
    
    def replace_all_of_recursive(data):
        if isinstance(data, dict):
            for key, value in list(data.items()):
                if key == 'allOf' and isinstance(value, list):
                    combined_schema = {'type': 'object', 'properties': {}}
                    for item in value:
                        if isinstance(item, dict):
                            for k, v in item.get('properties', {}).items():
                                combined_schema['properties'][k] = v
                    data.pop('allOf')
                    data.update(combined_schema)
                else:
                    replace_all_of_recursive(value)
        elif isinstance(data, list):
            for item in data:
                replace_all_of_recursive(item)
    
    replace_all_of_recursive(yaml_data)
    
    # Save the updated YAML data
    with open(input_file, 'w') as file:
        print(f"Saving file after replacing allOf: {input_file}")
        yaml.dump(yaml_data, file, sort_keys=False)

def count_references(openapi_data):
    if isinstance(openapi_data, dict):
        return sum(1 for key, value in openapi_data.items() if key == '$ref') + sum(count_references(value) for value in openapi_data.values())
    elif isinstance(openapi_data, list):
        return sum(count_references(item) for item in openapi_data)
    return 0

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python script.py <input_file> [<command>]\nCommands:\n  --dereference: Replace references with components.\n  --unwind-pattern-properties: Unwind patternProperties into simple properties.\n  --replace-all-of: Replace allOf with combined component.")
        sys.exit(1)
    
    input_file = sys.argv[1]
    command = sys.argv[2] if len(sys.argv) == 3 else None
    
    if command is None:
        print(f"Starting to dereference and then unwind patternProperties in YAML file: {input_file}")
        dereference_yaml(input_file)
        unwind_pattern_properties(input_file)
        print(f"All references have been dereferenced and all patternProperties have been unwound in the YAML file: {input_file}")
    elif command == '--dereference':
        print(f"Starting to dereference YAML file: {input_file}")
        dereference_yaml(input_file)
        print(f"All references have been dereferenced in the YAML file: {input_file}")
    elif command == '--unwind-pattern-properties':
        print(f"Starting to unwind patternProperties in YAML file: {input_file}")
        unwind_pattern_properties(input_file)
        print(f"All patternProperties have been unwound in the YAML file: {input_file}")
    elif command == '--replace-all-of':
        print(f"Starting to replace allOf in YAML file: {input_file}")
        replace_all_of(input_file)
        print(f"All allOf have been replaced in the YAML file: {input_file}")
    else:
        print("Unknown command. Use --dereference, --unwind-pattern-properties, or --replace-all-of.")
        sys.exit(1)