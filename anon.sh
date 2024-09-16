#!/bin/bash

# Define the output directory
output_dir="anonymized_submissions"
mkdir -p "$output_dir"

# Counter for anonymized folder names
counter=1

# Unzip the main file
unzip submissions.zip -d temp_submissions

# Iterate over each student's folder
for student_dir in temp_submissions/*; do
    if [ -d "$student_dir" ]; then
        # Create a new anonymized folder
        new_folder_name="Submission_$counter"
        mkdir "$output_dir/$new_folder_name"

        # Find the zip file inside each student's folder
        inner_zip=$(find "$student_dir" -name "*.zip")

        # Unzip the inner zip file
        unzip "$inner_zip" -d "$output_dir/$new_folder_name"

        # Remove identifying information from the inner files (if needed)
        for file in "$output_dir/$new_folder_name"/*; do
            # Rename files that have student names
            mv "$file" "${file//[student name pattern]/}"
        done

        # Re-zip the anonymized submission
        (cd "$output_dir/$new_folder_name" && zip -r "../${new_folder_name}.zip" .)

        # Increment the counter
        ((counter++))
    fi
done

# Clean up
rm -rf temp_submissions
