import requests as rq


#usrname = "qige0"
#pwd = "admin@123"
def main():
    url = "http://0.0.0.0:8001/api/v1/wx/articles?offset=0&limit=5&mp_id=MP_WXS_2397804841&only_favorite=false&has_content=false"
    headers = {
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxaWdlMCIsImV4cCI6MTc3NTk2MjMxMn0.KPMZVQk4kX2CyErH7XByWmekF2zrEJGm5K6lY7CH1eY"
    }
    # -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxaWdlMCIsImV4cCI6MTc3NTk2MjMxMn0.KPMZVQk4kX2CyErH7XByWmekF2zrEJGm5K6lY7CH1eY'
    print(rq.get(url, headers=headers).json())
if __name__ == "__main__":
    main()