## API Documentation:

## POST /api/v1/auth/sign_in
- Params: None
- Body: email and password
- Headers: None

### Responses
- Success 200: Renders the signed in user information in JSON format and returns authorizarion token and data
```
{
  "data": {
      
            "email":"linus@stardew.com",
            "nickname":"linus90",
            "provider":"email",
            "uid":"linus@stardew.com",
            "id":14,"first_name":"Linus",
            "last_name":"Tent",
            "birthday":"1942-03-05"
            }
}
```

- Unauthorized 401: Renders the following error message:
```
{
  "success":false,
  "errors":[
            "Invalid login credentials. Please try again."
            ]
}
```

## GET /api/v1/users
- Params: None
- Body: None
- Headers:
  - Authorization: Bearer token retreived when user is signed in successfully

#### Responses
- Success 200: Renders the users list in JSON format
```
{
    "users": [
        {
            "id": 11,
            "email": "lewis@stardew.com",
            "nickname": "mayor_lewis",
            "first_name": "Lewis",
            "last_name": "Mayor",
            "birthday": "1953-06-16"
        },
        {
            "id": 13,
            "email": "robin123@stardew.com",
            "nickname": "robin",
            "first_name": "Robin",
            "last_name": "Woods",
            "birthday": "1985-05-14"
        },
        {
            "id": 15,
            "email": "dwarf@stardew.com",
            "nickname": "dwarf_0",
            "first_name": "Dwarf",
            "last_name": "dwarf",
            "birthday": "1880-10-07"
        },
        {
            "id": 16,
            "email": "marnie@stardew.com",
            "nickname": "marniee",
            "first_name": "Marnie",
            "last_name": "Shovelnt",
            "birthday": "1967-06-06"
        },
        {
            "id": 17,
            "email": "clint@stardew.com",
            "nickname": "clint",
            "first_name": "Clint",
            "last_name": "Blacksmith",
            "birthday": "1977-05-17"
        },
        {
            "id": 12,
            "email": "emily@stardew.com",
            "nickname": "em_",
            "first_name": "Emily",
            "last_name": "Blue",
            "birthday": "1997-07-22"
        },
        {
            "id": 14,
            "email": "linus@stardew.com",
            "nickname": "linus90",
            "first_name": "Linus",
            "last_name": "Tent",
            "birthday": "1942-03-05"
        }
    ]
}
```
- Unauthorized 401: Renders the following error message:
```
{
    "errors": [
        "You need to sign in or sign up before continuing."
    ]
}
```
