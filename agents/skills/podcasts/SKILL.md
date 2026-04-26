---
name: podcasts
description: "Use when managing the chpeters.me podcast feed backed by public Vercel Blob: extract and encode audio from YouTube URLs, upload episode audio or transcripts, edit app/(www)/data/podcast.ts, validate /podcast.xml, commit, push to main, or remove podcast blobs and feed entries."
---

# chpeters.me Podcasts

## Scope

Work in `/Users/charlie/Dev/chpeters.me`.

Podcast metadata lives in:

- `app/(www)/data/podcast.ts`

The RSS route lives in:

- `app/podcast.xml/route.ts`

Media must live in public Vercel Blob, not in the repo. Do not add audio or transcript files under `public/`.

## Safety Rules

- Do not print secrets from `.env`, `.env.local`, or Vercel output.
- Use public Blob URLs for podcast clients.
- Use unique, stable pathnames. Never overwrite `latest.m4a`.
- Do not pass `--allow-overwrite` unless the user explicitly asks.
- Before any Blob delete, show the exact Blob URL/pathname and wait for explicit confirmation.
- Before pushing, show the staged stat/diff summary and confirm it only touches the podcast metadata/cover/route files expected by the request.
- If the user explicitly asked to add/delete a podcast and push to `main`, push after validation passes.

## Add Episode From YouTube

Required inputs:

- YouTube URL
- episode title
- description/materials
- RFC 2822 publish date

Generate the slug from the title. Use lowercase ASCII, replace non-alphanumeric runs with `-`, and trim leading/trailing `-`. If the title does not produce a unique or readable slug, ask before adding a suffix.

If any required metadata is missing, ask for it before uploading.

Use 64k AAC with faststart:

```sh
WORKDIR="$(mktemp -d /tmp/podcast.XXXXXX)"
TITLE="Episode Title"
YOUTUBE_URL="https://youtube.com/watch?v=..."
SLUG="$(printf '%s' "$TITLE" | iconv -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

yt-dlp -x --audio-format m4a \
  -o "$WORKDIR/source.%(ext)s" \
  "$YOUTUBE_URL"

ffmpeg -i "$WORKDIR/source.m4a" \
  -vn \
  -c:a aac \
  -b:a 64k \
  -movflags +faststart \
  "$WORKDIR/$SLUG.m4a"

BYTES="$(stat -f %z "$WORKDIR/$SLUG.m4a")"
SECONDS="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$WORKDIR/$SLUG.m4a")"
DURATION="$(python3 - "$SECONDS" <<'PY'
import sys
s = int(round(float(sys.argv[1])))
print(f"{s//3600:02d}:{(s%3600)//60:02d}:{s%60:02d}")
PY
)"
```

Upload to public Blob:

```sh
npx vercel@latest blob put "$WORKDIR/$SLUG.m4a" \
  --pathname "podcast/audio/$SLUG.m4a" \
  --content-type audio/mp4 \
  --access public
```

Record the returned public Blob URL.

Edit `app/(www)/data/podcast.ts` and add one episode object to `episodes`:

```ts
{
  slug: "episode-slug",
  title: "Episode title",
  description: "Episode description and materials.",
  publishedAt: "Fri, 24 Apr 2026 12:00:00 -0700",
  guid: "episode-slug",
  audioUrl: `${blobUrl}/podcast/audio/episode-slug.m4a`,
  audioBytes: Number(BYTES),
  mimeType: "audio/mp4",
  duration: DURATION,
}
```

Use the full returned Blob URL only if it does not match the repo's `blobUrl` base.

## Upload Transcript

Prefer `.vtt`; the current route emits `type="text/vtt"`.

```sh
SLUG="episode-slug"
TRANSCRIPT="path/to/episode-slug.vtt"

npx vercel@latest blob put "$TRANSCRIPT" \
  --pathname "podcast/transcripts/$SLUG.vtt" \
  --content-type text/vtt \
  --access public
```

Add to the matching episode:

```ts
transcriptUrl: `${blobUrl}/podcast/transcripts/episode-slug.vtt`,
```

## Delete Episode Or Blob

1. Find the episode in `app/(www)/data/podcast.ts`.
2. Capture `audioUrl` and optional `transcriptUrl`.
3. Show the exact metadata object and Blob URL/pathnames to delete.
4. Wait for explicit confirmation.
5. Remove the episode object, or remove only `transcriptUrl` if deleting a transcript.
6. Validate, commit, and push.
7. After push succeeds, delete confirmed Blob objects:

```sh
npx vercel@latest blob del "podcast/audio/episode-slug.m4a"
npx vercel@latest blob del "podcast/transcripts/episode-slug.vtt"
```

For lower risk, verify production `/podcast.xml` no longer references the URL before deleting the Blob.

## Validation

Run after metadata changes:

```sh
bunx biome check app/'(www)'/data/podcast.ts app/podcast.xml/route.ts

bun -e 'import { GET } from "./app/podcast.xml/route.ts"; const response = GET(); console.log(await response.text());' \
  | xmllint --noout -

bun run build
```

For uploaded audio:

```sh
curl -I "$AUDIO_URL"
curl -I -H 'Range: bytes=0-9' "$AUDIO_URL"
```

## Commit And Push

```sh
git status --short
git add app/'(www)'/data/podcast.ts app/podcast.xml/route.ts
git diff --cached --stat
git commit -m "Add podcast episode: $SLUG"
git push origin main
```
