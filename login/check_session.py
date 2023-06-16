def check_session(r, cookie):
    username = r.get(cookie).decode("utf-8")
    return username
