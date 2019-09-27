write-Host "Started Music Mover"
Clear-Variable -Name File* 

# TODO Ask to confirm source and destination directories
$source = "F:\Shared\Music\flac"
$dest = "F:\Shared\Music\m4a_temp"


$FilesFlac = Get-ChildItem $source -Filter *.flac -Recurse
write-Host $FilesFlac

# TODO increase performance, maybe run on mulitple threads

ForEach ($File in $FilesFlac) {
  $FileFullnameSource = $File.Fullname
  write-host "$FileFullNameSource"
  $FileFullnameDest = $FileFullnameSource.replace(".flac",".m4a")
  $FileFullnameDest = $FileFullnameDest.replace("$source", "$dest")
  $FileDirectorySource = $file.DirectoryName
  $FileDirectoryDest = $FileDirectorySource.replace("$source", "$dest")
  
# If destination directory doesn't exist, create it.
# TODO Have a list of files that have been converted and skip those that have been converted before.Don't need duplicate copies of flac and m4a
  If ((Test-Path -path $FileDirectoryDest) -eq $False) {
    New-Item -ItemType Directory -Path $FileDirectoryDest
  }

  # If m4a file doesn't exist in destination path, convert it.
  If ((Test-Path -path "$FileFullnameDest") -eq $False) {
   
    ffmpeg -nostdin -i $FileFullnameSource -c:a alac -c:v copy $FileFullnameDest

  }
}
