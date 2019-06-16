Clear-Variable -Name File* 
$source = "F:\cp_testing\source"
$dest = "F:\cp_testing\dest"

$FilesFlac = Get-ChildItem $source -Filter *.flac -Recurse
ForEach ($File in $FilesFlac) {
  $FileFullnameSource = $File.Fullname
  $FileFullnameDest = $FileFullnameSource.replace(".mp3","")
  $FileFullnameDest = $FileFullnameDest.replace("$source", "$dest")
  $FileDirectorySource = $file.DirectoryName
  $FileDirectoryDest = $FileDirectorySource.replace("$source", "$dest")
  
# If destination directory doesn't exist, create it.
  If ((Test-Path -path $FileDirectoryDest) -eq $False) {
    New-Item -ItemType Directory -Path $FileDirectoryDest
  }

  # If m4a file doesn't exist in destination path, convert it.
  If ((Test-Path -path "$FileFullnameDest.m4a") -eq $False) {
    write-host "Converting $File..."
    # Your conversion process here.
  }
}

#ffmpeg -nostdin -i $source_files_to_copy[$i] -c:a alac -c:v copy $dest_copied_files[$i]