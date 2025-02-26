#!/bin/bash

CONFIG_FILE="$HOME/.switchaudiosource.conf"

# Function to generate the configuration file
generate_config() {
  echo "Generating configuration file at $CONFIG_FILE..."

  # Clear existing config file or create a new one
  echo "# ~/.switchaudiosource.conf" > "$CONFIG_FILE"
  echo "# Format: key=\"actual device name\"" >> "$CONFIG_FILE"

  # Temporary file to collect devices (both input and output) without duplicates
  tmp_file=$(mktemp)

  # List output and input devices and add them to tmp_file
  SwitchAudioSource -t output -a >> "$tmp_file"
  SwitchAudioSource -t input -a >> "$tmp_file"

  # Remove duplicates based on device name and generate key-value pairs without prefixes
  awk '!seen[$0]++' "$tmp_file" | while IFS= read -r device; do
    key=$(echo "$device" | tr ' ' '_')
    echo "$key=\"$device\"" >> "$CONFIG_FILE"
  done

  # Cleanup
  rm "$tmp_file"

  echo "Configuration file created at $CONFIG_FILE with unique entries."
}

# Function to delete the configuration file
delete_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
    echo "Configuration file $CONFIG_FILE deleted."
  else
    echo "No configuration file found at $CONFIG_FILE."
  fi
}

# Function to get the device name from config using key
get_device_name_by_key() {
  local key="$1"
  # Search for the key in the config file and extract the device name
  device_name=$(grep "^$key=" "$CONFIG_FILE" | cut -d '"' -f2)
  echo "$device_name"
}

# Function to switch output device by name
switch_output_device() {
  local device_name="$1"
  SwitchAudioSource -t output -s "$device_name"
  if [[ $? -eq 0 ]]; then
    echo "Switched output to device: $device_name"
  else
    echo "Failed to switch output to device: $device_name"
    exit 1
  fi
}

# Function to switch input device by name
switch_input_device() {
  local device_name="$1"
  SwitchAudioSource -t input -s "$device_name"
  if [[ $? -eq 0 ]]; then
    echo "Switched input to device: $device_name"
  else
    echo "Failed to switch input to device: $device_name"
    exit 1
  fi
}

# Function to display help
print_help() {
  echo "Usage: $0 [-g] [-d] [-k key] [-n device_name] [-o] [-i]"
  echo "  -g               Generate a new configuration file"
  echo "  -d               Delete the configuration file"
  echo "  -k key           Specify device by key from the config file"
  echo "  -n device_name   Specify device by full device name"
  echo "  -o               Only switch output device (can be combined with -k or -n)"
  echo "  -i               Only switch input device (can be combined with -k or -n)"
  echo "  -h               Show this help message"
}

# Argument parsing
generate_flag=false
delete_flag=false
device_name=""
output_only=false
input_only=false
key_specified=false
name_specified=false

# If no arguments, show help
if [[ $# -eq 0 ]]; then
  print_help
  exit 0
fi

while getopts "gdk:n:oih" opt; do
  case $opt in
    g) generate_flag=true ;;  # Generate config file
    d) delete_flag=true ;;    # Delete config file
    k)
      key_specified=true
      device_name=$(get_device_name_by_key "$OPTARG")
      if [[ -z "$device_name" ]]; then
        echo "Error: Key '$OPTARG' not found in config."
        exit 1
      fi
      ;;
    n)
      name_specified=true
      device_name="$OPTARG" ;;  # Actual device name
    o) output_only=true ;;      # Only change output
    i) input_only=true ;;       # Only change input
    h)
      print_help
      exit 0
      ;;
    *) echo "Invalid option"; exit 1 ;;
  esac
done

# Ensure that either -k or -n is specified if -o or -i is used
if { $output_only || $input_only; } && [[ -z "$device_name" ]]; then
  echo "Error: You must specify a device with -k or -n when using -o or -i."
  exit 1
fi

# Handle generation and deletion of config file
if $generate_flag; then
  generate_config
  exit 0
fi

if $delete_flag; then
  delete_config
  exit 0
fi

# Switch devices based on flags
if $output_only; then
  switch_output_device "$device_name"
elif $input_only; then
  switch_input_device "$device_name"
else
  # If neither -o nor -i was specified, switch both input and output
  switch_output_device "$device_name"
  switch_input_device "$device_name"
fi