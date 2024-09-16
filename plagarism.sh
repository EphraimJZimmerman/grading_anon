#!/bin/bash

# Define the name of the zip file and the output directory
input_zip="submissions.zip"
output_dir="plagarism_ready"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Create a temporary directory for extraction
temp_dir=$(mktemp -d)

# Unzip the main submissions zip
unzip "$input_zip" -d "$temp_dir"

# Process each student's folder
for student_folder in "$temp_dir"/*; do
    if [ -d "$student_folder" ]; then
        student_name=$(basename "$student_folder")
        mkdir -p "$output_dir/$student_name"

        # Find the zip file inside the student's folder
        zip_file=$(find "$student_folder" -name "*.zip")

        # Unzip the student's zip file into their respective folder
        if [ -n "$zip_file" ]; then
            unzip "$zip_file" -d "$output_dir/$student_name"
        fi
    fi
done

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "Files have been organized and extracted into $output_dir."
