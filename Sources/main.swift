import Foundation

let url = NSURL(string: "http://cist.nure.ua")!
let request = DataRequest(.GET, url: url) { respond in
    print("Here")
}
request.error = { error in
	print(error)
}
request.execute()