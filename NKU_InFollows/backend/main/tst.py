import requests as rq


#usrname = "qige0"
#pwd = "admin@123"
def main():
    url = "http://0.0.0.0:8001/api/v1/wx/articles?offset=0&limit=5&mp_id=MP_WXS_2397804841&only_favorite=false&has_content=false"
    
    # MjM5NzgwNDg0MQ==：MP_WXS_2397804841 南开大学
    headers = {
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxaWdlMCIsImV4cCI6MTc3NjU2NjQzN30.u12-NwavPP9hh0ijC6OFClt2TqvR8_GruXt9KMu1DaY"
    }
    # -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxaWdlMCIsImV4cCI6MTc3NTk2MjMxMn0.KPMZVQk4kX2CyErH7XByWmekF2zrEJGm5K6lY7CH1eY'
    print(rq.get(url, headers=headers).json())


def test_rem_api():
    url = "https://down.mptext.top/api/public/v1/account"
    payload = {"keyword": "南开大学"}
    cookies = {"auth-key": "522f079173fb4a9db7da44f901d43be6"}
    print(rq.get(url, params=payload, cookies=cookies).json())

if __name__ == "__main__":
    test_rem_api()