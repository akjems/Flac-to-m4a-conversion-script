
# Codes the files smaller
for name in *.flac; do ffmpeg -nostdin -i "$name" -c:a alac -c:v copy "${name%.*}.m4a"; done

# One file at a time
ffmpeg -i track.flac -acodec alac track.m4a

# Seems to be the correct command
for name in *.flac; do ffmpeg -nostdin -i "$name" -c:acodec alac -c:v copy "${name%.*}.m4a"; done

