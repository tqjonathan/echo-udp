import Socket
import Foundation

let port = 7667

do {
    let serverSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
    try serverSocket.listen(on: port)
    print("Listening on \(port)")
    var buffer = Data(capacity: 1000)
    repeat {
        let (bytesRead, clientAddress) = try serverSocket.readDatagram(into: &buffer)
        if let address = clientAddress {
            let (clientHostname, clientPort) = Socket.hostnameAndPort(from: address)!
            let message = String(decoding: buffer, as: UTF8.self)
            print("Received length \(bytesRead) from \(clientHostname):\(clientPort)")
            print("Message: \(message)")

            // Send response
            try serverSocket.write(from: message, to: address)
        }
        buffer.removeAll()
    } while true
} catch let error {
    print("Connection error: \(error)")
}