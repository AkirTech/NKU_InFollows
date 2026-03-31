import requests as rq

def main():
    url = "https://down.mptext.top/api/public/v1/download"
    target_url = "https://mp.weixin.qq.com/s/zwf4uJ7aBLfXzqIX9Q68ow"
    post_json = {
        "url":target_url,
        "format":"html"
    }
    data = rq.get(url, params=post_json).content
    with open("test.html", "wb") as f:
        f.write(data)
if __name__ == "__main__":
    main()