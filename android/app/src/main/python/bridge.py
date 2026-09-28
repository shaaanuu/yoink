import sys
import json

def check_deps():
    try:
        import yt_dlp
        return json.dumps({"ok": True})
    except Exception as e:
        return json.dumps({"ok": False, "error": str(e)})

def get_info(url):
    try:
        import yt_dlp
        opts = {
            'format': 'all',
            'quiet': True,
            'no_warnings': True,
            'skip_download': True,
            'listformats': True,
        }
        with yt_dlp.YoutubeDL(opts) as ydl:
            info = ydl.extract_info(url, download=False)
            return json.dumps({
                "ok": True,
                "data": {
                    "title": info.get("title"),
                    "duration": info.get("duration"),
                    "formats": [
                        {
                            "format_id": f.get("format_id"),
                            "ext": f.get("ext"),
                            "resolution": f.get("resolution"),
                            "filesize": f.get("filesize"),
                            "url": f.get("url"),
                            "vcodec": f.get("vcodec"),
                            "acodec": f.get("acodec"),
                            "format_note": f.get("format_note"),
                            "fps": f.get("fps"),
                            "tbr": f.get("tbr"),
                            "protocol": f.get("protocol"),
                        }
                        for f in info.get("formats", [])
                    ],
                    "thumbnail": info.get("thumbnail"),
                    "uploader": info.get("uploader"),
                    "view_count": info.get("view_count"),
                }
            })
    except Exception as e:
        return json.dumps({"ok": False, "error": str(e)})