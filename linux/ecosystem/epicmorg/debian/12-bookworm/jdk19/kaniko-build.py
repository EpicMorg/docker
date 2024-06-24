import os
import shutil
import argparse
import yaml
import subprocess
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
from dotenv import load_dotenv
import logging
import sys

# Script version
SCRIPT_VERSION = "1.0.1.0"

# ASCII art for EpicMorg
ASCII_ART = r"""
+=================================================+
| ____|        _)         \  |                    |
| __|    __ \   |   __|  |\/ |   _ \    __|  _` | |
| |      |   |  |  (     |   |  (   |  |    (   | |
|_____|  .__/  _| \___| _|  _| \___/  _|   \__, | |
| |  /  _|           _)  |                 |___/  |
| ' /    _` |  __ \   |  |  /   _ \               |
| . \   (   |  |   |  |    <   (   |              |
|_|\_\ \__,_| _|  _| _| _|\_\ \___/               |
|\ \        /                                     |
| \ \  \   /   __|  _` |  __ \   __ \    _ \   __||
|  \ \  \ /   |    (   |  |   |  |   |   __/  |   |
|   \_/\_/   _|   \__,_|  .__/   .__/  \___| _|   |
|                        _|     _|                |
+=================================================+
"""

# Load environment variables from .env file
load_dotenv()

def setup_logging():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def parse_args():
    parser = argparse.ArgumentParser(description="EpicMorg: Kaniko-Compose Wrapper", add_help=False)
    parser.add_argument('--compose-file', default=os.getenv('COMPOSE_FILE', 'docker-compose.yml'), help='Path to docker-compose.yml file')
    parser.add_argument('--kaniko-image', default=os.getenv('KANIKO_IMAGE', 'gcr.io/kaniko-project/executor:latest'), help='Kaniko executor image')
    parser.add_argument('--push', '--deploy', '-d', '-p', action='store_true', help='Deploy the built images to the registry')
    parser.add_argument('--dry-run', '--dry', action='store_true', help='Dry run: build images without pushing and with cleanup')
    parser.add_argument('--version', '-v', action='store_true', help='Show script version')
    parser.add_argument('--help', '-h', action='store_true', help='Show this help message and exit')
    return parser.parse_args()

def load_compose_file(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

def build_with_kaniko(service_name, build_context, dockerfile, image_name, build_args, kaniko_image, deploy, dry):
    kaniko_command = [
        'docker', 'run',
        '--rm',
        '-t',
        '-v', f'{os.path.abspath(build_context)}:/workspace',
    ]

    # Add Docker config mounts for both read-only access
    kaniko_command.extend([
        '-v', '/var/run/docker.sock:/var/run/docker.sock:ro',  # Access to Docker daemon
        '-v', f'{os.path.expanduser("~")}/.docker:/kaniko/.docker:ro',  # Use existing Docker credentials in read-only mode
    ])

    kaniko_command.extend([
        kaniko_image,
        '--context', '/workspace',
        '--dockerfile', f'/workspace/{dockerfile}',
        '--compressed-caching',
        '--single-snapshot',
        '--cleanup'
    ])

    if deploy:
        kaniko_command.extend([
            '--destination', image_name
        ])
    elif dry:
        kaniko_command.extend([
            '--no-push'
        ])
    else:
        kaniko_command.extend([
            '--no-push'
        ])
    
    # Add build arguments if they exist
    for arg_name, arg_value in build_args.items():
        kaniko_command.extend(['--build-arg', f'{arg_name}={arg_value}'])
    
    logging.info(f"Building {service_name} with Kaniko: {' '.join(kaniko_command)}")
    
    process = subprocess.Popen(kaniko_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    # Stream output in real-time
    for line in process.stdout:
        logging.info(line.strip())
    
    process.wait()
    
    if process.returncode == 0:
        logging.info(f"Successfully built {service_name}")
    else:
        for line in process.stderr:
            logging.error(line.strip())
        logging.error(f"Error building {service_name}")
        raise Exception(f"Failed to build {service_name}")

def show_help():
    print(ASCII_ART)
    print("EpicMorg: Kaniko-Compose Wrapper\n")
    print("Arguments:")
    print("--compose-file        Path to docker-compose.yml file")
    print("--kaniko-image        Kaniko executor image")
    print("--push, --deploy, -d, -p    Deploy the built images to the registry")
    print("--dry-run, --dry      Dry run: build images without pushing and with cleanup")
    print("--version, -v         Show script version")
    print("--help, -h            Show this help message and exit")

def show_version():
    print(ASCII_ART)
    print(f"EpicMorg: Kaniko-Compose Wrapper {SCRIPT_VERSION}, Python: {sys.version}")

def main():
    setup_logging()
    
    args = parse_args()

    # Show help and exit if --help is provided
    if args.help:
        show_help()
        return
    
    # Show version and exit if --version or no relevant arguments are provided
    if args.version or not (args.push or args.dry_run or args.compose_file != 'docker-compose.yml' or args.kaniko_image != 'gcr.io/kaniko-project/executor:latest'):
        show_version()
        return
    
    compose_file = args.compose_file
    kaniko_image = args.kaniko_image
    deploy = args.push
    dry = args.dry_run
    
    if not os.path.exists(compose_file):
        logging.error(f"{compose_file} not found")
        return
    
    compose_data = load_compose_file(compose_file)
    
    services = compose_data.get('services', {})
    image_names = defaultdict(int)
    
    for service_name, service_data in services.items():
        image_name = service_data.get('image')
        
        if not image_name:
            logging.warning(f"No image specified for service {service_name}")
            continue
        
        image_names[image_name] += 1
    
    for image_name, count in image_names.items():
        if count > 1:
            logging.error(f"Error: Image name {image_name} is used {count} times.")
            return
    
    try:
        with ThreadPoolExecutor() as executor:
            futures = []
            for service_name, service_data in services.items():
                build_data = service_data.get('build', {})
                build_context = build_data.get('context', '.')
                dockerfile = build_data.get('dockerfile', 'Dockerfile')
                image_name = service_data.get('image')
                build_args = build_data.get('args', {})
                
                # Substitute environment variables with their values if they exist
                build_args = {key: os.getenv(key, value) for key, value in build_args.items()}
                
                if not image_name:
                    logging.warning(f"No image specified for service {service_name}")
                    continue
                
                futures.append(executor.submit(build_with_kaniko, service_name, build_context, dockerfile, image_name, build_args, kaniko_image, deploy, dry))
            
            for future in as_completed(futures):
                future.result()
    except Exception as exc:
        logging.error(f"Build failed: {exc}")
        sys.exit(1)

if __name__ == '__main__':
    main()
