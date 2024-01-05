---

# Networking Library for Swift

This lightweight networking library simplifies making HTTP requests in Swift. It's designed to be easy to integrate into your projects and follows modern Swift conventions.

## Installation

### Swift Package Manager

To integrate this library into your Xcode project using Swift Package Manager, follow these steps:

1. Open your Xcode project.
2. Navigate to the menu `File > Swift Packages > Add Package Dependency...`.
3. Enter the following URL of this repository: `https://github.com/VictorKreniski/Networking.git`.
4. Click **Next** and select the version or branch you want to use.
5. Click **Next** and then **Finish**.

The library will be automatically resolved and linked with your Xcode project.

## Usage

Once you've added the package to your project, you can start using the networking capabilities.

### Import the Library

In the Swift file where you want to use the networking library, import it at the top:

```swift
import Networking
```

### Making a Request

Create a `Networking.Request` to make a network request. Here's an example:

```swift
let url = URL(string: "https://api.example.com/data")!
let request = Networking.Request(url: url, method: .get)

do {
    let result: YourDecodableType = try await request.run()
    // Handle the result
} catch {
    // Handle errors
}
```

Replace `YourDecodableType` with the type you expect the response to be.

### Handling Errors

The library defines a set of errors that can occur during network requests. You can catch and handle these errors as needed:

```swift
do {
    // Make a request
} catch Networking.Errors.noResponse {
    // Handle no response error
} catch Networking.Errors.unauthorized {
    // Handle unauthorized error
} catch Networking.Errors.unknown(let description) {
    // Handle unknown error with the provided description
} catch {
    // Handle other errors
}
```

Refer to the [Errors](#errors) section for a list of possible errors.

## Errors

The library defines the following errors:

- `.decode`: Error encountered during decoding the response.
- `.invalidURL(urlString: String)`: The provided URL is invalid.
- `.noResponse`: No response received from the server.
- `.unauthorized`: The request is unauthorized.
- `.unexpectedStatusCode(statusCode: Int)`: Unexpected HTTP status code received.
- `.unknown(description: String)`: An unknown error occurred with the provided description.
- `.forbidden`: The request is forbidden.
- `.badRequest`: The request is malformed or contains invalid parameters.
- `.noConnection`: There is no internet connection.

## Contributing

We welcome contributions! If you find any issues or have improvements to suggest, please open an issue or submit a pull request.

---

Feel free to modify and customize this template based on the specific details of your networking library and the conventions you want to promote.
