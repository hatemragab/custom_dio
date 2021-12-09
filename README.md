start  init before you send any request 
``` 
  WidgetsFlutterBinding.ensureInitialized();
  CustomDio.setInitData(
    CustomDioOptions(
      baseUrl: "http://www.google.com",
      headers: {"authorization": "Bearer xxx"},
    ),
  );
```

## POST
```
  try {
  final data =  await CustomDio()
        .send(reqMethod: "post", path: "user/login", body: {"email": "email"});
  } catch (err) {
    print(err.toString());
  }
```

## GET 
```
  try {
   final data = await CustomDio()
        .send(reqMethod: "get", path: "user/login", query: {"search": "email"});
  } catch (err) {
    print(err.toString());
  }
```

## UPLOAD

```
  try {
    final data = await CustomDio()
        .uploadFile(path: "path", filePath: File("").path, body: [
      {"one": "one"},
      {"two": "two"},
    ]);
  } catch (err) {
    print(err.toString());
  }
```
