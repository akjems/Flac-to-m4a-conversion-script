
# Where from and to are you working
$source = "F:\Shared\Music\Lossless\flac"
$dest = "F:\Shared\Music\Lossless\m4a"

# Lists all .txt files
$source_files = Get-ChildItem $source -Filter *.flac -Recurse | % { $_.FullName } 
# Cleans the string of $source by removing source path and last 5 characters in name
$cleaned_source = foreach ($element in $source_files) {
    $temp = $element.Remove(0,$source.Length)
        foreach ($element in $temp) {
            $element.Substring(0,$element.Length-5)
    }
   }
# Same as above but for dest
$dest_files = Get-ChildItem $dest -Filter *.m4a -Recurse | % { $_.FullName } 
$cleaned_dest = foreach ($element in $dest_files) {
    $temp = $element.Remove(0,$dest.Length)
        foreach ($element in $temp) {
            $element.Substring(0,$element.Length-4)
    }
   }
# Is there a cleaner way?

# Array of files that are in $source or $dest but not the other
$compared = Compare-Object $cleaned_source $cleaned_dest -PassThru
# If in dest but not in source will also be included on this list. If cp fails I can just skip the file.
## TODO fix above behavior.

# Create Directories for in dest
foreach ($element in $compared) {
    $part_name = $dest + $element
    $dest_directory = $part_name.Substring(0, $part_name.lastIndexOf('\'))
    If ((Test-Path -path $dest_directory) -eq $False) {
    New-Item -ItemType Directory -Path $dest_directory
      }
   }

#Rebuild the full path for source files
$source_files_to_copy = foreach ($element in $compared) {
    $source + $element + ".flac"
   }

$dest_copied_files = foreach ($element in $compared) {
    $dest + $element + ".m4a"
   }

for( $i = 0; $i -lt $source_files_to_copy.length; $i++) {
  ffmpeg -nostdin -i $source_files_to_copy[$i] -c:a alac -c:v copy $dest_copied_files[$i]
}