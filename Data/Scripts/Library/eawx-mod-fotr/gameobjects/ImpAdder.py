import os

# Get the current working directory (you can modify this if needed)
current_dir = os.getcwd()

# Iterate over all files in the current directory
for filename in os.listdir(current_dir):
    # Check if the file has a .lua extension (case-insensitive)
    if filename.lower().endswith('.lua'):
        # Split the filename and the extension
        base_name, extension = os.path.splitext(filename)
        
        # Form the new filename by adding '_IMP' before the .lua extension
        new_filename = base_name + '_IMP' + extension
        
        # Construct full file paths
        old_file = os.path.join(current_dir, filename)
        new_file = os.path.join(current_dir, new_filename)
        
        try:
            # Rename the file
            os.rename(old_file, new_file)
            print(f"Renamed: {filename} -> {new_filename}")
        except OSError as e:
            # Catch any errors and print them
            print(f"Error renaming file {filename}: {e}")
