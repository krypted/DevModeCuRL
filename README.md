# DevModeCuRL
SwiftUI project to CuRL information from an endpoint from within an app 

# Intent
This project can be compiled && run as a standalone app but has no branding and is super-basic, as it is intended to be used inside other apps, likely via a hidden developer mode to run arbitrary CuRL commands and get basic responses.

<p><a href="url"><img src="https://github.com/krypted/DevModeCuRL/blob/main/Screenshots/main.png" height="400" width="200" ></a></p>

Supported HTTP methods include GET, POST, PUT, and DELETE. It can run anonymous or use Basic Auth, Bearer Tokens, or OAuth 2. There are also options for arbitrary headers (implemented as apiHeaders:HTTPHeaders in the NetworkManager.swift) and parameters (implemented as apiParameters in the NetworkManager.swift). 

<p><a href="url"><img src="https://github.com/krypted/DevModeCuRL/Screenshots/example.png" height="400" width="200" ></a></p>

The responses are not parsed but for my purposes I don't want them parsed.

<p><a href="url"><img src="https://github.com/krypted/DevModeCuRL/blob/main/Screenshots/response.png" height="400" width="200" ></a></p>

There are some UI tests but didn't bother as I don't plan to ship it in a final app release.

# Dependencies

Uses AlamoFire ( https://github.com/Alamofire/Alamofire ) and OIDCLite ( https://github.com/mactroll/OIDCLite ) from https://github.com/mactroll.
