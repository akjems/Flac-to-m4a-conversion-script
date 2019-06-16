New-Item -ItemType file example.txt # Create an empty file, Linux touch

$fso = Get-ChildItem -Recurse -path F:\cp_testing\source # Cannot be empty
## TODO parameter based source directory

$fsoBU = Get-ChildItem -Recurse -path F:\cp_testing\dest # Cannot be empty
## TODO parameter based destination directory

Compare-Object -ReferenceObject $fso -DifferenceObject $fsoBU # Shows which file are in fso or fsoBU and not in the other.
# Doesn't return full path so not best tool be used for automatd script.

$source = Get-ChildItem F:\cp_testing\source -Filter *.txt -Recurse | % { $_.FullName } # Lists all .txt files

$dest = Get-ChildItem F:\cp_testing\dest -Filter *.txt -Recurse | % { $_.FullName } 

$source.GetType() # Checks type, it is an array.

$source_file = "F:\cp_testing\source\dir_1\file_1.txt"

$source_file.Remove(0,20) # Remove all the text in front of \dir_1

$source_file = $source_file.Substring(0,$source_file.Length-4) # Removes the .txt at the end.

# Loop through array cleaning the string
$shortened = foreach ($element in $source) {
    $element.Remove(0,20)
   }

$cleaned = foreach ($element in $shortened) {
    $element.Substring(0,$element.Length-4)
   }
##TODO do it one array loop instead of two
##############################################################################
## Script Starts here ##
##############################################################################

# Where from and to are you working
$source = "F:\cp_testing\source"
$dest = "F:\cp_testing\dest"

# Lists all .txt files
$source_files = Get-ChildItem $source -Filter *.txt -Recurse | % { $_.FullName } 
# Cleans the string of $source by removing source path and last 5 characters in name
$cleaned_source = foreach ($element in $source_files) {
    $temp = $element.Remove(0,$source.Length)
        foreach ($element in $temp) {
            $element.Substring(0,$element.Length-4)
    }
   }
# Same as above but for dest
$dest_files = Get-ChildItem $dest -Filter *.txt -Recurse | % { $_.FullName } 
$cleaned_dest = foreach ($element in $dest_files) {
    $temp = $element.Remove(0,18)
        foreach ($element in $temp) {
            $element.Substring(0,$element.Length-4)
    }
   }
# Is there a cleaner way?

# Array of files that are in $source or $dest but not the other
$compared = Compare-Object $cleaned_source $cleaned_dest -PassThru
# If in dest but not in source will also be included on this list. If cp fails I can just skip the file.
## TODO fix above behavior.

#Rebuild the full path for source
$source_files_to_copy = foreach ($element in $compared) {
    $source + $element + ".txt"
   }

foreach ($element in $source_files_to_copy) {
    cp $element F:\temp\
}



# Copy all $source_files_to_copy to a temp directory. !If files don't exist skip!
# Convert all files in temp directory to m4a
ffmpeg -i track.flac -acodec alac track.m4a # Same command I have been using on Mac
# Move all temp/*.m4a files to dest
# Delete temp directory

# If I want to share the script, it needs to create the dest directories.
