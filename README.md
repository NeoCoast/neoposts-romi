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

## GET /api/v1/users/:user_id/posts
- Params: user_id
- Body: None
- Headers:
  - Authorization: Bearer token retreived when user is signed in successfully

#### Responses
- Success 200: Renders the posts list for the user in JSON format
```
{
    "posts": [
        {
            "id": 14,
            "title": "Geodes",
            "body": "You can bring your geodes to open",
            "published_at": "2024-06-03T13:34:52.438Z",
            "likes_count": 0,
            "comments_count": 2
        },
        {
            "id": 13,
            "title": "Hi",
            "body": "Shop opens at 9:00",
            "published_at": "2024-06-03T13:34:15.237Z",
            "likes_count": 2,
            "comments_count": 2
        }
    ]
}
```
- Not Found 404: When user does not exist renders the following error message:
```
{
    "message": "User not found"
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

## GET /api/v1/posts/:post_id
- Params: post_id
- Body: None
- Headers:
  - Authorization: Bearer token retreived when user is signed in successfully

#### Responses
- Success 200: Renders the post details with likes, comments and replies in JSON format
```
{
    "id": 13,
    "title": "Hi",
    "body": "Shop opens at 9:00",
    "published_at": "2024-06-03T13:34:15.237Z",
    "user_id": 17,
    "likes": [
        {
            "user_id": 12,
            "nickname": "em_"
        },
        {
            "user_id": 14,
            "nickname": "linus90"
        }
    ],
    "comments": [
        {
            "id": 234,
            "body": "ksdnfoasi",
            "replies": [
                {
                    "id": 238,
                    "body": "lalala"
                }
            ]
        },
        {
            "id": 235,
            "body": "adsopij",
            "replies": []
        }
    ]
}
```
- Not Found 404: When post does not exist renders the following error message:
```
{
    "message": "Post not found"
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

## POST /api/v1/users/:user_id/posts
- Params: user_id
- Body: {
          "post": {
            "title": "title",
            "body": "body"
          }
        }
- Headers:
  - Authorization: Bearer token retreived when user is signed in successfully

#### Responses
- Created 201: Renders the created post details in JSON format
```
{
    "id": 26,
    "title": "New post title 2",
    "body": "This is my other new post.",
    "published_at": "2024-07-10T12:53:37.186Z",
    "likes_count": 0
}
```
- Unauthorized 401: 
  - Renders the following error message when user_id is not the same as the current logged user:
  ```
  {
      "message": "Unauthorized"
  }
  ```
  - Renders the following error message when no logged user:
  ```
  {
      "errors": [
          "You need to sign in or sign up before continuing."
      ]
  }
  ```
- Bad Request 400: Renders the following error message when invalid parameters are entered:
```
{
    "errors": [
        "Title can't be blank",
        "Body can't be blank"
    ]
}
```
- Not Found 404: When user does not exist renders the following error message:
```
{
    "message": "User not found"
}
```

## PUT /api/v1/posts/:post_id
- Params: post_id
- Body: {
          "post": {
            "title": "updated title",
            "body": "updated body"
          }
        }
- Headers:
  - Authorization: Bearer token retreived when user is signed in successfully

#### Responses
- Success 200: Renders the updated post details in JSON format
```
{
    "id": 27,
    "title": "updated title",
    "body": "updated body",
    "published_at": "2024-07-10T13:19:47.308Z",
    "likes_count": 0
}
```
- Unauthorized 401: 
  - Renders the following error message when the post does not belong to the logged user:
  ```
  {
      "message": "Unauthorized"
  }
  ```
  - Renders the following error message when no logged user:
  ```
  {
      "errors": [
          "You need to sign in or sign up before continuing."
      ]
  }
  ```
- Bad Request 400: Renders the following error message when invalid parameters are entered:
```
{
    "errors": [
        "Title can't be blank",
        "Body can't be blank"
    ]
}
```
- Not Found 404: When post does not exist renders the following error message:
```
{
    "message": "Post not found"
}
```
