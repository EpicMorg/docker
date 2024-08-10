import os
import shutil

def copy_files_to_directories(root_directory, script_directory, ignore_directory, files_to_copy):
    for subdir, dirs, files in os.walk(root_directory):
        # Ignore the specified directory
        if ignore_directory in subdir:
            continue

        if 'docker-compose.yml' in files and 'Dockerfile' in files:
            for file_name in files_to_copy:
                source = os.path.join(script_directory, file_name)
                destination = os.path.join(subdir, file_name)
                # Copy and overwrite the file if it already exists
                shutil.copyfile(source, destination)
                print(f"Copied {file_name} to {subdir}")

def main():
    # Determine the root directory of the project as two levels above the current script
    current_directory = os.path.dirname(os.path.abspath(__file__))
    root_directory = os.path.abspath(os.path.join(current_directory, '..', '..'))
    
    # Directory where the source scripts are located
    script_directory = os.path.join(root_directory, 'bin/kaniko')
    
    # Directory to ignore
    ignore_directory = os.path.join(root_directory, 'win32')
    
    # List of files to copy
    files_to_copy = ['requirements.txt']
    
    # Check if the source files exist in the script directory
    for file_name in files_to_copy:
        if not os.path.exists(os.path.join(script_directory, file_name)):
            print(f"{file_name} not found in {script_directory}.")
            return
    
    # Copy the files to the appropriate directories
    copy_files_to_directories(root_directory, script_directory, ignore_directory, files_to_copy)

if __name__ == '__main__':
    main()
